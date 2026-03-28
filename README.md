# cicd_bits

this repo contains a cicd pipeline example that uses drone (with gitea, see the docker setup for that in the docker_bits repo) to automatically build and deploy an app when commits are pushed into specific branches that would be locked to repo managers behind pull requests.

it also has an uses a make file which can be used to build the app locally, as well as to be used by the drone build process to build and deploy the app.

the app itself is within docker and gets built in a docker container using a dockerfile and for the staging and prod builds via drone gets pushed to and pulled from a local docker repository to host images, all using drone secrets for the ssh keys etc to securely manage the deployment process
