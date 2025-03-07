-include .env
-include .env.example
export

build-repos:
	git submodule sync --recursive
	git submodule update --init --recursive --remote

build-tig:
	$(MAKE) -C observablity_tig build-tig

build-pyats-server:
	$(MAKE) -C pyats_server container-run

build-grafana-to-langgraph-proxy:
	$(MAKE) -C oncall-netops build-proxy

validate_env_vars:
	$(MAKE) -C oncall-netops validate_env_vars

set-env-var-oncall-netops:
	cp .env oncall-netops/.env
	echo "" >> oncall-netops/.env
	cat .env.example >> oncall-netops/.env

build-demo:
	$(MAKE) validate_env_vars
	$(MAKE) build-tig
	$(MAKE) build-pyats-server
	$(MAKE) build-grafana-to-langgraph-proxy
	$(MAKE) set-env-var-oncall-netops

run-environment:
	$(MAKE) -C oncall-netops build-environment
	$(MAKE) -C oncall-netops build-proxy
	$(MAKE) -C oncall-netops run-environment
