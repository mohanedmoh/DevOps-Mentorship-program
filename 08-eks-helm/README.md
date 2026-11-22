# 08 EKS and Helm

Tasks 19 and 20.

## cluster

An EKS cluster built with the community module (`terraform-aws-modules/eks/aws`, pinned to `~> 21.0`). It reads the VPC from the network layer in `02-remote-state`. The subnets there carry the `kubernetes.io/role/elb` and `kubernetes.io/role/internal-elb` tags that load balancers look for.

- The control plane runs Kubernetes 1.36. EKS releases a new version every few months, so check the version calendar before you pick one.
- One managed node group of two `t3.medium` nodes on Amazon Linux 2023.
- The public API endpoint only accepts the address you give in `admin_cidr`.
- Access uses EKS access entries. `enable_cluster_creator_admin_permissions` gives the identity that ran Terraform admin rights.
- The core add-ons are managed by EKS.

```bash
cd cluster
cp terraform.tfvars.example terraform.tfvars    # set the bucket and your address
terraform init -backend-config=../../02-remote-state/backend.hcl
terraform apply
```

Then connect:

```bash
$(terraform output -raw kubeconfig_command)
kubectl get nodes
```

## Install the chart

`charts/webapp` is a small chart with a Deployment and a Service. The container runs as a non-root user, drops every Linux capability and has probes and resource limits.

```bash
helm lint charts/webapp
helm install demo charts/webapp
kubectl get pods
kubectl port-forward service/demo 8080:80
```

Open `http://localhost:8080`. Try `helm upgrade demo charts/webapp --set replicaCount=3`, then `helm uninstall demo`.

## Cost

The EKS control plane bills by the hour, on top of the nodes and the NAT gateway. This is the most expensive folder. Run `helm uninstall demo` and then `terraform destroy` as soon as you finish.

## Task 20: the final project

Take the WordPress build from `05-wordpress` onto Kubernetes. Write your own chart, `charts/wordpress`, that:

1. Runs the official `wordpress` image.
2. Takes the database host and a Secret name as values.
3. Reads the password from a Kubernetes Secret, never from `values.yaml`.
4. Has readiness and liveness probes.
5. Passes `helm lint` and `helm template`.

Then decide how the password gets into the cluster. That is the interesting part, and there is more than one good answer.

## Questions to talk through

- What does the module create that you would otherwise write by hand? How many resources is that?
- What is an access entry? Why did EKS move away from the `aws-auth` config map?
- Why are the worker nodes in private subnets?
- What does `helm template` show that `helm install` hides?
