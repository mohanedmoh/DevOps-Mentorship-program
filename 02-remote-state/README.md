# 02 Remote state and layers

Tasks 6, 7, 8 and 9.

State is how Terraform remembers what it built. On your laptop it is a file next to your code. That does not work for a team, and it is easy to lose or leak. This folder moves state to S3 and splits the code into layers.

## The three layers

- `bootstrap` creates the S3 bucket for state. It is the only layer that keeps its state locally, because the bucket does not exist yet.
- `network` builds the VPC. It writes its outputs to its own state file.
- `app` builds one web server. It reads the VPC from the network layer's state with `terraform_remote_state` and never creates a network itself.

Each layer has its own state file, so a mistake in `app` cannot damage the network.

## Order

```bash
# 1. The bucket
cd bootstrap
terraform init
terraform apply -var bucket_name=mentor-tfstate-<your-account-id>

# 2. Tell the other layers where it is
cd ..
cp backend.hcl.example backend.hcl      # then put the bucket name in it

# 3. The network
cd network
terraform init -backend-config=../backend.hcl
terraform apply

# 4. The app
cd ../app
export TF_VAR_allowed_cidr="$(curl -s https://checkip.amazonaws.com)/32"
export TF_VAR_state_bucket=<the same bucket>
terraform init -backend-config=../backend.hcl
terraform apply
```

Open the URL from the `url` output. The page shows the instance ID and zone, read from the instance metadata service.

Destroy in the reverse order: `app`, then `network`. Leave the bucket until you have finished with the course.

## Locking

The backend sets `use_lockfile = true`. Terraform writes a small `.tflock` object next to the state file while it works, and a second run waits or fails. The older way used a DynamoDB table. That option is deprecated, so this course does not use it.

The role that runs Terraform needs `s3:GetObject`, `s3:PutObject` and `s3:DeleteObject` on the lock object as well as on the state.

## Questions to talk through

- Why can `bootstrap` not use the bucket it creates?
- What is in a state file that you would not want in Git?
- Why is bucket versioning turned on? How would you use it after a bad apply?
- What happens if two people run `terraform apply` on the same layer at once?
- Why does `bootstrap` set `prevent_destroy`?
