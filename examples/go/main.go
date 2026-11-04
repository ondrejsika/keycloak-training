package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"time"

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
var FlagRedirectOrigin string

func init() {
	Cmd.Flags().StringVar(&FlagIssuer, "issuer", "", "Issuer")
	Cmd.MarkFlagRequired("issuer")
	Cmd.Flags().StringVar(&FlagClientID, "client-id", "", "Client ID")
	Cmd.MarkFlagRequired("client-id")
	Cmd.Flags().StringVar(&FlagClientSecret, "client-secret", "", "Client Secret")
	Cmd.MarkFlagRequired("client-secret")
	Cmd.Flags().StringVar(&FlagRedirectOrigin, "redirect-origin", "http://127.0.0.1:8000", "Redirect Origin")
}

var Cmd = &cobra.Command{
	Use:   "example",
	Short: "Example OIDC",
	Run: func(cmd *cobra.Command, args []string) {
		Server(FlagIssuer, FlagClientID, FlagClientSecret)
	},
}

func Server(issuer, clientID, clientSecret string) {
	ctx := context.Background()

	provider, err := oidc.NewProvider(ctx, issuer)
	if err != nil {
		log.Fatal(err)
	}

	config := oauth2.Config{
		ClientID:     clientID,
		ClientSecret: clientSecret,
		Endpoint:     provider.Endpoint(),
		RedirectURL:  FlagRedirectOrigin + "/callback",
		Scopes:       []string{oidc.ScopeOpenID, "profile", "email"},
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// Random state protects against CSRF, PKCE verifier protects the code exchange.
		// Both are stored in cookies for simplicity of the example.
		state := oauth2.GenerateVerifier()
		verifier := oauth2.GenerateVerifier()
		setTmpCookie(w, "state", state)
		setTmpCookie(w, "verifier", verifier)
		http.Redirect(w, r, config.AuthCodeURL(state, oauth2.S256ChallengeOption(verifier)), http.StatusFound)
	})

	http.HandleFunc("/callback", func(w http.ResponseWriter, r *http.Request) {
		state, err := r.Cookie("state")
		if err != nil || r.URL.Query().Get("state") != state.Value {
			http.Error(w, "state did not match", http.StatusBadRequest)
			return
		}

		verifier, err := r.Cookie("verifier")
		if err != nil {
			http.Error(w, "verifier not found", http.StatusBadRequest)
			return
		}

		oauth2Token, err := config.Exchange(ctx, r.URL.Query().Get("code"), oauth2.VerifierOption(verifier.Value))
		if err != nil {
			http.Error(w, "Failed to exchange token: "+err.Error(), http.StatusInternalServerError)
			return
		}

		rawIDToken, ok := oauth2Token.Extra("id_token").(string)
		if !ok {
			http.Error(w, "No id_token field in oauth2 token.", http.StatusInternalServerError)
			return
		}

		rawAccessToken := oauth2Token.AccessToken
		rawRefreshToken := oauth2Token.RefreshToken

		idToken, err := provider.Verifier(&oidc.Config{ClientID: clientID}).Verify(ctx, rawIDToken)
		if err != nil {
			http.Error(w, "Failed to verify ID Token: "+err.Error(), http.StatusInternalServerError)
			return
		}
		_ = idToken // ID Token is now verified and can be used

		// Keycloak Access Token has "aud": "account" unless an audience mapper
		// for this client is configured, so skip the client ID (audience) check
		accessToken, err := provider.Verifier(&oidc.Config{SkipClientIDCheck: true}).Verify(ctx, rawAccessToken)
		if err != nil {
			http.Error(w, "Failed to verify Access Token: "+err.Error(), http.StatusInternalServerError)
			return
		}
		_ = accessToken // Access Token is now verified and can be used

		// Refresh Token is not verified, it is signed by Keycloak using a symmetric
		// key (HS512) and it is not intended to be validated by the client

		fmt.Fprintf(w, "id_token\n")
		fmt.Fprintf(w, "%s\n", rawIDToken)
		fmt.Fprintf(w, "\n")
		fmt.Fprintf(w, "access_token\n")
		fmt.Fprintf(w, "%s\n", rawAccessToken)
		fmt.Fprintf(w, "\n")
		fmt.Fprintf(w, "refresh_token\n")
		fmt.Fprintf(w, "%s\n", rawRefreshToken)
		fmt.Fprintf(w, "\n")
	})

	fmt.Println(FlagRedirectOrigin)
	log.Fatal(http.ListenAndServe(":8000", nil))
}

func setTmpCookie(w http.ResponseWriter, name, value string) {
	http.SetCookie(w, &http.Cookie{
		Name:     name,
		Value:    value,
		MaxAge:   int((5 * time.Minute).Seconds()),
		HttpOnly: true,
		SameSite: http.SameSiteLaxMode,
	})
}
