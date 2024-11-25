# AWS

- Create an user with admin privileges on aws.
- Create an app key and secret.
- Install awscli
- Install terraform
- install kubectl
- Install aws-iam-authenticator
- Configure the secret and key with `aws config` .

## Documents

https://registry.terraform.io/providers/hashicorp/aws/latest/docs

## How it works

When you execute `terraform apply` , it will start some services on aws and this services cames from two modules.

- /modules/vpc
    1. A vpc.
    2. Two sunets.
    3. An internet gateway.
    4. A route table
- /moddules/eks
    1. A security group.
    2. A role to let eks assume role.
    3. Some policies tha allow eks work.
    4. A EKS cluster
    

## Provider file

To help it works, we have a local provider besides aws to generate the kubeconfig file, when you trigger `terraform apply` , will appear a kubecofing file, put this file on kubectl location, by example `cp kubeconfig ~/.kube/config` .

## Notes

After apply terraform, we will able to see the eks online

- Use the command `kubectl get noodes` to see the nodes that was created.