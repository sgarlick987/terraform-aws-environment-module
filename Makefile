.ONESHELL:
.PHONEY: help set-env init update plan plan-destroy show graph apply output taint
GLOBAL_AWS_REGION?=us-east-1
AWS_REGION?=us-east-1
GLOBAL_ENVIRONMENT?=global

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

set-env:
	@if [ -z $(ENVIRONMENT) ]; then\
		 echo "ENVIRONMENT was not set"; exit 10;\
	 fi

	@if [ -z $(SHORT_DOMAIN) ]; then\
		 echo "SHORT_DOMAIN was not set"; exit 10;\
	 fi

init: set-env
	@cd environments/$(ENVIRONMENT)/$(AWS_REGION)
	@rm -rf .terraform/*.tf*
	@terraform remote config \
		-backend=S3 \
		-backend-config="region=$(GLOBAL_AWS_REGION)" \
		-backend-config="bucket=$(SHORT_DOMAIN)-$(GLOBAL_ENVIRONMENT)-terraform-state-$(GLOBAL_AWS_REGION)" \
		-backend-config="key=$(ENVIRONMENT)/$(AWS_REGION).tfstate"
	@terraform remote pull

update: ## Gets a newer version of the state
	@cd environments/$(ENVIRONMENT)/$(AWS_REGION)
	@terraform get -update=true 1>/dev/null

plan: init update ## Runs a plan to show proposed changes.
	@cd environments/$(ENVIRONMENT)/$(AWS_REGION)
	@terraform plan -input=false -refresh=true -module-depth=-1

plan-destroy: init update ## Runs a plan to show what will be destroyed
	@terraform plan -input=false -refresh=true -module-depth=-1 -destroy

show: init
	@cd environments/$(ENVIRONMENT)/$(AWS_REGION)
	@terraform show -module-depth=-1

graph: ## Creates a graph of the resources that Terraform is aware of
	@cd environments/$(ENVIRONMENT)/$(AWS_REGION)
	@rm -f graph.png
	@terraform graph -draw-cycles -module-depth=-1 | dot -Tpng > graph.png
	@open graph.png

apply: init update ## DANGER! Runs changes against your environment
	@cd environments/$(ENVIRONMENT)/$(AWS_REGION)
	@terraform apply -input=true -refresh=true && terraform remote push

output: init update
	@cd environments/$(ENVIRONMENT)/$(AWS_REGION)
	@if [ -z $(MODULE) ]; then\
		terraform output;\
	 else\
		terraform output -module=$(MODULE);\
	 fi

taint: init update ## Specifically choose a resource to taint
	@cd environments/$(ENVIRONMENT)/$(AWS_REGION)
	@echo "Tainting involves specifying a module and a resource"
	@read -p "Module: " MODULE &&\
		read -p "Resource: " RESOURCE &&\
		terraform taint -module=$$MODULE $$RESOURCE &&\
		terraform remote push
	@echo "You will now want to run a plan to see what changes will take place"

destroy: init update ## DANGER! Destroys a set of resources
	@cd environments/$(ENVIRONMENT)/$(AWS_REGION)
	@terraform destroy && terraform remote push

destroy-target: init update ## Specifically choose a resource to destroy
	@cd environments/$(ENVIRONMENT)/$(AWS_REGION)
	@echo "Specifically destroy a piece of Terraform data"
	@echo "Example: module.rds.aws_route53_record.rds-master"
	@read -p "Destroy this: " DATA &&\
		terraform destroy -target=$$DATA &&\
terraform remote push