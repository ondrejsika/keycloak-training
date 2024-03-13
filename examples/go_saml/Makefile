run:
	go run . --cert crt.pem --key key.pem --entity-id saml-example --metadata-url https://sso.sikademo.com/realms/sikademo/protocol/saml/descriptor

generate-certs:
	openssl req -x509 -newkey rsa:2048 -keyout key.pem -out crt.pem -days 3650 -nodes -subj "/CN=example"
