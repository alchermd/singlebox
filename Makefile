init:
	cd terraform && terraform init

lint:
	terraform fmt -write -recursive

tf:
	cd terraform && terraform apply -auto-approve -var-file=.tfvars && terraform output --json > ../terraform-output.json

deploy: tf

destroy:
	cd terraform && terraform destroy -auto-approve -var-file=.tfvars
