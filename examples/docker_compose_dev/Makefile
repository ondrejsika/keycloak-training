up:
	docker compose up -d

down:
	docker compose down

# Disable "HTTPS required" on the master realm, so the admin console
# works over plain HTTP on any (non-localhost) domain
disable-ssl-required:
	docker compose exec keycloak /opt/keycloak/bin/kcadm.sh config credentials --server http://127.0.0.1:8080 --realm master --user admin --password admin
	sleep 2
	docker compose exec keycloak /opt/keycloak/bin/kcadm.sh update realms/master -s sslRequired=NONE
