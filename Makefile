# Define common variables
TERRAFORM_DIR=terraform
SCRIPTS_DIR=scripts
SRC_DIR=src
TF_VARS_FILE=.tfvars
TF_OUTPUT_FILE=terraform-output.json
VENV_PATH=$(SCRIPTS_DIR)/venv
PYTHON=python

# Terraform commands
tf-init:
	cd $(TERRAFORM_DIR) && terraform init

tf:
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve -var-file=$(TF_VARS_FILE) && terraform output --json > ../$(TF_OUTPUT_FILE)

destroy-tf:
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve -var-file=$(TF_VARS_FILE)

# Python scripts setup and commands
scripts-init:
	cd $(SCRIPTS_DIR) && $(PYTHON) -m venv $(VENV_PATH) && source $(VENV_PATH)/bin/activate && pip install -r requirements.txt

deploy-src:
	cd $(SCRIPTS_DIR) && source $(VENV_PATH)/bin/activate && $(PYTHON) deploy.py

cleanup:
	cd $(SCRIPTS_DIR) && source $(VENV_PATH)/bin/activate && $(PYTHON) cleanup.py

# Docker and app-specific commands
init: tf-init scripts-init

dev:
	cd $(SRC_DIR) && docker compose up --build

migrate:
	cd $(SRC_DIR) && docker compose exec web python manage.py migrate

lint:
	terraform fmt -write -recursive

deploy: tf deploy-src

destroy: cleanup destroy-tf
