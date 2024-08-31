package main

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"github.com/coreos/go-oidc"
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
	Short: "Examle OIDC",
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
		RedirectURL:  "http://localhost:8000/callback",
		Scopes:       []string{oidc.ScopeOpenID, "profile", "email"},
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		http.Redirect(w, r, config.AuthCodeURL("state"), http.StatusFound)
	})

	http.HandleFunc("/callback", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Query().Get("state") != "state" {
			http.Error(w, "state did not match", http.StatusBadRequest)
			return
		}

		oauth2Token, err := config.Exchange(ctx, r.URL.Query().Get("code"))
		if err != nil {
			http.Error(w, "Failed to exchange token: "+err.Error(), http.StatusInternalServerError)
			return
		}

		rawIDToken, ok := oauth2Token.Extra("id_token").(string)
		if !ok {
			http.Error(w, "No id_token field in oauth2 token.", http.StatusInternalServerError)
			return
		}

		idToken, err := provider.Verifier(&oidc.Config{ClientID: clientID}).Verify(ctx, rawIDToken)
		if err != nil {
			http.Error(w, "Failed to verify ID Token: "+err.Error(), http.StatusInternalServerError)
			return
		}

		_ = idToken // ID Token is now verified and can be used

		fmt.Println(rawIDToken)

		fmt.Fprintf(w, "%s\n", rawIDToken)
	})

	fmt.Println("http://localhost:8000/")
	log.Fatal(http.ListenAndServe(":8000", nil))
}
