
Suffix 11 indicates the terraform version is 0.11.x
Suffix 12 corresponds to terraform version 0.12.x

In the initial file the main.tf had a local-exec provisioner which tried to execute multiple commands but only the last command was executed 
so the updated main.tf file has two local-exec provisioner blocks

this provisioner block is helpful when we run terraform on a vm, also note that the configuration required for the vm to run gcloud commands to 
update the cluster.

If this script is executed via a jenkins pipeline most probably it will throw an error which would relate to insufficient authentication scopes

