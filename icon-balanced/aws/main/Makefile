SHELL := /bin/bash -euo pipefail
.PHONY: all test clean

help: 								## Show help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

clear-cache:						## Clear the terragrunt and terraform caches
	find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \; && \
	find . -type d -name ".terraform" -prune -exec rm -rf {} \; && \
	find . -type f -name "*.tfstate*" -prune -exec rm -rf {} \;

apply:								## Applies all resources
	terragrunt apply-all --terragrunt-source-update --auto-approve

destroy:							## Destroys all resources
	terragrunt destroy-all --terragrunt-source-update --auto-approve
