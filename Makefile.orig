PROJECT_ID=storybooks-devops-jj
ZONE=us-central1-c
DB_NAME=storybooks-devops

run-local:
	docker-compose up

###

create-tf-backend-bucket:
	gsutil mb -p $(PROJECT_ID) gs://$(PROJECT_ID)-terraform

###

define get-secret
$(shell gcloud secrets versions access latest --secret=$(1) --project=$(PROJECT_ID))
endef

###

ENV=staging

terraform-create-workspace:
	cd terraform &&  \
	  terraform workspace new $(ENV)

terraform-init:
	cd terraform &&  \
	  terraform workspace select $(ENV) && \
	  terraform init

TF_ACTION?=plan

terraform-action:
	cd terraform &&  \
	  terraform workspace select $(ENV) && \
	  terraform $(TF_ACTION) \
	  -var-file="./environments/common.tfvars" \
	  -var-file="./environments/$(ENV)/config.tfvars" \
	  -var="mongodbatlas_private_key=$(call get-secret,atlas_private_key)" \
	  -var="atlas_user_password=$(call get-secret,atlas_user_password)" \
	  -var="cloudflare_api_token=$(call get-secret,cloudflare_api_token)"

###

SSH_STRING=palas@storybooks-vm-$(ENV)

VERSION?=latest
LOCAL_TAG=storybooks-app:$(VERSION)
REMOTE_TAG=gcr.io/$(PROJECT_ID)/$(LOCAL_TAG)

CONTAINER_NAME=storybooks-api

ssh:
	gcloud compute ssh $(SSH_STRING) \
	--project=$(PROJECT_ID) \
	--zone=$(ZONE)

ssh-cmd:
	@gcloud compute ssh $(SSH_STRING) \
	--project=$(PROJECT_ID) \
	--zone=$(ZONE) \
	--command="$(CMD)"

build:
	docker build -t $(LOCAL_TAG) .

push:
	docker tag $(LOCAL_TAG) $(REMOTE_TAG)
	docker push $(REMOTE_TAG)

deploy:
	$(MAKE) ssh-cmd CMD='docker-credential-gcr configure-docker'
	$(MAKE) ssh-cmd CMD='docker pull $(REMOTE_TAG)'
	-$(MAKE) ssh-cmd CMD='docker container stop $(CONTAINER_NAME)'
	-$(MAKE) ssh-cmd CMD='docker container rm $(CONTAINER_NAME)'
	@$(MAKE) ssh-cmd CMD='\
	  docker run -d --name=$(CONTAINER_NAME) \
	    --restart=unless-stopped \
	    -p 80:3000 \
		-e PORT=3000 \
		-e \"MONGO_URI=mongodb+srv://storybooks-user-$(ENV):$(call get-secret,atlas_user_password)@storybooks-vm-$(ENV).sl8ce.mongodb.net/$(DB_NAME)?retryWrites=true&w=majority\" \
		-e GOOGLE_CLIENT_ID=771516168511-82aj4uf3cmv4s4m0rpitkj4siol85g69.apps.googleusercontent.com \
		-e GOOGLE_CLIENT_SECRET=$(call get-secret,google_oauth_client_secret) \
	    $(REMOTE_TAG) \
		'