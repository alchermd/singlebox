tf-init:
	cd terraform && terraform init

scripts-init:
	cd scripts && python -m venv venv && source ./venv/bin/activate && pip install -r requirements.txt

init: tf-init scripts-init

lint:
	terraform fmt -write -recursive

tf:
	cd terraform && terraform apply -auto-approve -var-file=.tfvars && terraform output --json > ../terraform-output.json

deploy-src:
	cd scripts && source ./venv/bin/activate && python deploy.py

deploy: tf deploy-src

cleanup:
	cd scripts && source ./venv/bin/activate && python cleanup.py

destroy-tf:
	cd terraform && terraform destroy -auto-approve -var-file=.tfvars

destroy: cleanup destroy-tf
