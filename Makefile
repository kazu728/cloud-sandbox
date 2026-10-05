SSH ?= ssh
SSH_HOST ?= root@$(HOST)

.PHONY: switch
switch:
	@case "$(HOST)" in \
		google|oci) ;; \
		*) printf '%s\n' 'Usage: make switch HOST=google|oci' >&2; exit 1 ;; \
	esac
	rsync -rt --delete -e "$(SSH)" flake.nix flake.lock nixos "$(SSH_HOST):/etc/nixos/"
	$(SSH) "$(SSH_HOST)" "nixos-rebuild switch --flake /etc/nixos#$(HOST)"
