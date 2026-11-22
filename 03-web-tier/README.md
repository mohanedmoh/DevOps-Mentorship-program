# 03 Web tier

Tasks 10, 11, 12 and 13.

The single server from the last folder becomes a pool of servers behind a load balancer.

- An Application Load Balancer in the public subnets takes HTTP on port 80.
- A target group checks each server with an HTTP health check.
- An Auto Scaling group keeps at least two servers running in the private subnets, using a launch template.
- The servers accept traffic from the load balancer's security group and nothing else.
- An instance profile gives each server the AWS managed policy for Systems Manager. There is no bastion and no SSH. You connect with Session Manager.

It reads the network layer from the state bucket in `02-remote-state`, so run that first.

```bash
export TF_VAR_state_bucket=<your bucket>
terraform init -backend-config=../02-remote-state/backend.hcl
terraform apply
```

Open the `url` output and refresh. The instance ID changes as the load balancer moves between servers.

## Connect with Session Manager

```bash
aws ssm start-session --target <instance-id>
```

Find an instance ID in the EC2 console or with `aws autoscaling describe-auto-scaling-groups`. You need the Session Manager plugin for the AWS CLI installed on your machine.

## Things worth trying

- Terminate one instance and watch the group replace it.
- Change `userdata.sh` and run `terraform apply`. The group replaces the servers in a rolling refresh and keeps at least half of them healthy.
- Set `health_check_type` back to `EC2` and break the web server. What changes?

## Cost

The load balancer and the NAT gateway bill while they exist. Destroy at the end of the session.

## Questions to talk through

- Why do the servers sit in private subnets when the load balancer is public?
- What does `health_check_type = "ELB"` do that `EC2` does not?
- Why is IMDSv2 required in the launch template?
- What would you need to add to serve HTTPS? The `05-wordpress` folder does it.
