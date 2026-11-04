package main

import (
	"context"
	"fmt"
	"log"

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

func init() {
	Cmd.Flags().StringVar(&FlagIssuer, "issuer", "", "Issuer")
	Cmd.MarkFlagRequired("issuer")
	Cmd.Flags().StringVar(&FlagClientID, "client-id", "", "Client ID")
	Cmd.MarkFlagRequired("client-id")
	Cmd.Flags().StringVar(&FlagClientSecret, "client-secret", "", "Client Secret")
	Cmd.MarkFlagRequired("client-secret")
}

var Cmd = &cobra.Command{
	Use:   "example",
	Short: "Example OIDC Device Authorization Grant",
	Run: func(cmd *cobra.Command, args []string) {
		Device(FlagIssuer, FlagClientID, FlagClientSecret)
	},
}

func Device(issuer, clientID, clientSecret string) {
	ctx := context.Background()

	provider, err := oidc.NewProvider(ctx, issuer)
	if err != nil {
		log.Fatal(err)
	}

	config := oauth2.Config{
		ClientID:     clientID,
		ClientSecret: clientSecret,
		// Endpoint contains DeviceAuthURL from the discovery document
		// (device_authorization_endpoint)
		Endpoint: provider.Endpoint(),
		Scopes:   []string{oidc.ScopeOpenID},
	}

	// POST /protocol/openid-connect/auth/device
	// oauth2 sends only client_id here, confidential client needs client_secret too
	deviceAuth, err := config.DeviceAuth(ctx, oauth2.SetAuthURLParam("client_secret", clientSecret))
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Open in browser:", deviceAuth.VerificationURIComplete)
	fmt.Println("Or open:        ", deviceAuth.VerificationURI)
	fmt.Println("and enter code: ", deviceAuth.UserCode)
	fmt.Println()

	// Polls POST /protocol/openid-connect/token
	// with grant_type=urn:ietf:params:oauth:grant-type:device_code
	// until the user approves (or denies) the login or the code expires
	oauth2Token, err := config.DeviceAccessToken(ctx, deviceAuth)
	if err != nil {
		log.Fatal(err)
	}

	rawIDToken, ok := oauth2Token.Extra("id_token").(string)
	if !ok {
		log.Fatal("No id_token field in oauth2 token.")
	}

	rawAccessToken := oauth2Token.AccessToken
	rawRefreshToken := oauth2Token.RefreshToken

	idToken, err := provider.Verifier(&oidc.Config{ClientID: clientID}).Verify(ctx, rawIDToken)
	if err != nil {
		log.Fatal("Failed to verify ID Token: " + err.Error())
	}
	_ = idToken // ID Token is now verified and can be used

	// Keycloak Access Token has "aud": "account" unless an audience mapper
	// for this client is configured, so skip the client ID (audience) check
	accessToken, err := provider.Verifier(&oidc.Config{SkipClientIDCheck: true}).Verify(ctx, rawAccessToken)
	if err != nil {
		log.Fatal("Failed to verify Access Token: " + err.Error())
	}
	_ = accessToken // Access Token is now verified and can be used

	// Refresh Token is not verified, it is signed by Keycloak using a symmetric
	// key (HS512) and it is not intended to be validated by the client

	fmt.Println("id_token")
	fmt.Println(rawIDToken)
	fmt.Println()
	fmt.Println("access_token")
	fmt.Println(rawAccessToken)
	fmt.Println()
	fmt.Println("refresh_token")
	fmt.Println(rawRefreshToken)
}
