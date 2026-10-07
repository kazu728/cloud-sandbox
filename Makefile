SSH ?= ssh
SSH_HOST ?= root@$(HOST)

.PHONY: switch secrets
switch:
	@case "$(HOST)" in \
		google|oci) ;; \
		*) printf '%s\n' 'Usage: make switch HOST=google|oci' >&2; exit 1 ;; \
	esac
	rsync -rt --delete -e "$(SSH)" flake.nix flake.lock nixos "$(SSH_HOST):/etc/nixos/"
	$(SSH) "$(SSH_HOST)" "nixos-rebuild switch --flake /etc/nixos#$(HOST)"

# Only the OCI VM runs k3s.
secrets: HOST = oci
secrets:
	@set -e; trap 'stty echo' EXIT INT; \
	printf 'Slack webhook URL: ' >&2; stty -echo; read -r url; stty echo; printf '\n' >&2; \
	test -n "$$url"; \
	printf '%s' "$$url" | $(SSH) "$(SSH_HOST)" ' \
		set -eu; \
		url=$$(cat); \
		k3s kubectl create namespace observability --dry-run=client -o yaml | k3s kubectl apply -f -; \
		printf %s "$$url" | k3s kubectl -n observability create secret generic alertmanager-slack-webhook \
			--from-file=url=/dev/stdin --dry-run=client -o yaml | k3s kubectl apply -f -; \
		k3s kubectl -n observability get secret grafana-admin >/dev/null 2>&1 || \
			tr -dc A-Za-z0-9 </dev/urandom | head -c 32 | k3s kubectl -n observability create secret generic grafana-admin \
				--from-literal=admin-user=admin --from-file=admin-password=/dev/stdin'
