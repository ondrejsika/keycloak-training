package main

import (
	"context"
	"log"
	"os"

	"github.com/coreos/go-oidc"
)

func main() {
	if len(os.Args) != 3 {
		log.Fatalf("Usage: %s <issuer> <rawIDToken>", os.Args[0])
	}

	issuer := os.Args[1]
	rawIDToken := os.Args[2]

	ctx := context.Background()

	provider, err := oidc.NewProvider(ctx, issuer)
	if err != nil {
		log.Fatal(err)
	}

	_, err = provider.Verifier(&oidc.Config{SkipClientIDCheck: true}).Verify(ctx, rawIDToken)
	if err != nil {
		log.Fatal(err)
	}

	log.Println("Token is valid")
}
