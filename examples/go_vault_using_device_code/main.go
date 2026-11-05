package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"strings"

	"github.com/coreos/go-oidc/v3/oidc"
	"github.com/spf13/cobra"
	"golang.org/x/oauth2"
)

func main() {
	Cmd.Execute()
}

var FlagIssuer string
var FlagClientID string
var FlagClientSecret string
var FlagVaultAddr string
var FlagVaultAuthMount string
var FlagVaultRole string
var FlagSecretMount string
var FlagSecretPath string

func init() {
	Cmd.Flags().StringVar(&FlagIssuer, "issuer", "https://sso.sikalabs.com/realms/training", "Issuer")
	Cmd.Flags().StringVar(&FlagClientID, "client-id", "vault", "Client ID")
	Cmd.Flags().StringVar(&FlagClientSecret, "client-secret", "vault", "Client Secret")
	Cmd.Flags().StringVar(&FlagVaultAddr, "vault-addr", "https://vault.sikademo.com", "Vault address")
	Cmd.Flags().StringVar(&FlagVaultAuthMount, "vault-auth-mount", "jwt", "Vault JWT auth mount path")
	Cmd.Flags().StringVar(&FlagVaultRole, "vault-role", "jwt", "Vault role (must have role_type jwt)")
	Cmd.Flags().StringVar(&FlagSecretMount, "secret-mount", "secret", "KV v2 secret engine mount path")
	Cmd.Flags().StringVar(&FlagSecretPath, "secret-path", "hello-world", "Secret path in the KV v2 secret engine")
}

var Cmd = &cobra.Command{
	Use:   "example",
	Short: "Read a Vault secret using Keycloak Device Authorization Grant",
	Run: func(cmd *cobra.Command, args []string) {
		idToken := Device(FlagIssuer, FlagClientID, FlagClientSecret)
		vaultToken := VaultLogin(FlagVaultAddr, FlagVaultAuthMount, FlagVaultRole, idToken)
		data := VaultReadKV2(FlagVaultAddr, vaultToken, FlagSecretMount, FlagSecretPath)
		out, _ := json.MarshalIndent(data, "", "  ")
		fmt.Println(string(out))
	},
}

// Device gets an ID Token from Keycloak using Device Authorization Grant
func Device(issuer, clientID, clientSecret string) string {
	ctx := context.Background()

	provider, err := oidc.NewProvider(ctx, issuer)
	if err != nil {
		log.Fatal(err)
	}

	config := oauth2.Config{
		ClientID:     clientID,
		ClientSecret: clientSecret,
		Endpoint:     provider.Endpoint(),
		Scopes:       []string{oidc.ScopeOpenID},
	}

	// oauth2 sends only client_id here, confidential client needs client_secret too
	deviceAuth, err := config.DeviceAuth(ctx, oauth2.SetAuthURLParam("client_secret", clientSecret))
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Open:", deviceAuth.VerificationURIComplete)
	fmt.Println()

	oauth2Token, err := config.DeviceAccessToken(ctx, deviceAuth)
	if err != nil {
		log.Fatal(err)
	}

	// Vault role has bound_audiences = [client_id], ID Token has "aud": client_id
	// (Access Token has "aud": "account" by default), so we use the ID Token
	rawIDToken, ok := oauth2Token.Extra("id_token").(string)
	if !ok {
		log.Fatal("No id_token field in oauth2 token.")
	}

	return rawIDToken
}

// VaultLogin exchanges the JWT for a Vault token
// POST /v1/auth/<mount>/login {"role": "...", "jwt": "..."}
func VaultLogin(vaultAddr, mount, role, jwt string) string {
	body, _ := json.Marshal(map[string]string{
		"role": role,
		"jwt":  jwt,
	})

	var resp struct {
		Auth struct {
			ClientToken string   `json:"client_token"`
			Policies    []string `json:"policies"`
		} `json:"auth"`
	}
	vaultRequest(http.MethodPost, vaultAddr+"/v1/auth/"+mount+"/login", "", body, &resp)

	fmt.Println("Logged in to Vault, policies:", strings.Join(resp.Auth.Policies, ", "))
	fmt.Println()

	return resp.Auth.ClientToken
}

// VaultReadKV2 reads a secret from KV v2 secret engine
// GET /v1/<mount>/data/<path>
func VaultReadKV2(vaultAddr, token, mount, path string) map[string]interface{} {
	var resp struct {
		Data struct {
			Data map[string]interface{} `json:"data"`
		} `json:"data"`
	}
	vaultRequest(http.MethodGet, vaultAddr+"/v1/"+mount+"/data/"+path, token, nil, &resp)
	return resp.Data.Data
}

func vaultRequest(method, url, token string, body []byte, out interface{}) {
	req, err := http.NewRequest(method, url, bytes.NewReader(body))
	if err != nil {
		log.Fatal(err)
	}
	req.Header.Set("Content-Type", "application/json")
	if token != "" {
		req.Header.Set("X-Vault-Token", token)
	}

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	defer res.Body.Close()

	resBody, _ := io.ReadAll(res.Body)
	if res.StatusCode != http.StatusOK {
		log.Fatalf("%s %s: %s: %s", method, url, res.Status, resBody)
	}

	if err := json.Unmarshal(resBody, out); err != nil {
		log.Fatal(err)
	}
}
