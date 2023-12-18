# terraform-vms-nginx
Terraform - Linux VMs with a Nginx Containers

Goal:
- An HTML page rendering the text "Giacomo Quaglia Exercise 002 - VM 01" will be browsable at the URL http://<IP_1>:80/
- An HTML page rendering the text "Giacomo Quaglia Exercise 002 - VM 02" will be browsable at the URL http://<IP_2>:80/

Expectations:
- Azure Azure Cloud Resources will be created in the Resource Group: Giacomo-Quaglia-001
- Stack: Linux virtual machines with a NGINX container exposing the requested HTML page
- Public IP on top of the virtual machines to make the VM reachable on internet
- The Cloud Resources provisioning will be done ONLY through Terraform
  - The Azure credentials for Terraform are available in the LastPass shared folder "Shared-Tutoring Giacomo Quaglia"
- The Virtual Machines configurations will be performed through bash script/s to run after the Cloud Resources provisioning
  - The Terraform "remote-exec" provider or other solutions can be used to execute the script/s
- The work, to be considered done, should be pushed in the git repository "tutoring_giacomo-quaglia_terraform-001"

![tickets-SXPDEVOG-432](https://github.com/giacomoquaglia11/terraform-vms-nginx/assets/153645847/24d87ced-8831-4f0c-a71c-fac7ef32a916)
