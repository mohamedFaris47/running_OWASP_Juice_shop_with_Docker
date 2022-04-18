# Running OWASP Juice Shop on AWS EC2

* Deploy method: 
    * Terraform is used to provision the required aws resources. 
    * The resources required are: 
        1. Security group to allow network traffic to the website on port 80.
        2. `t2.micro` instance to host the website.

    * Terraform is used to configure the instance to run OWASP Juice shop using the offical Docker container provided in the OWASP Juice shop github repo.

* To use this code:
    * You just need to have Terraform installed.
    * Edit the `variables.tf` file to add your aws credentials, instance_ami, vpc_id, and the used key_pair name.
    * Then open a terminal in the same directory of these 2 terraform files. Then write in the terminal.
    ```hcl
    terraform apply -auto-approve
    ```
    * Wait for the deployment to take place, it takes about 5 minutes.
    * The website should be working on `port 80` of the `instance ip`.


