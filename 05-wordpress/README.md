# 05 WordPress

Tasks 15, 16 and 20.

WordPress in a Docker container on EC2, with its database on RDS and HTTPS on a domain you own.

- Route 53 holds the DNS records. An ACM certificate is validated with a DNS record that Terraform creates.
- An Application Load Balancer terminates HTTPS and redirects HTTP to HTTPS.
- One server in a private subnet runs the official `wordpress` image.
- RDS for MySQL 8.4 sits in the private subnets. Only the WordPress server can reach port 3306.

## The password

The database password never appears in the code, in a variable or in the state file. The database uses `manage_master_user_password = true`, so RDS creates the password and stores it in Secrets Manager. At boot the server reads that one secret with its instance role and hands it to the container through a file only root can read.

RDS rotates that secret every seven days by default, and the boot script reads it once. A server that started before a rotation holds the old value, so replace the server to pick up the new one.

## HTTPS behind the load balancer

The load balancer ends the HTTPS connection and talks plain HTTP to the server. It adds an `X-Forwarded-Proto` header that says which protocol the visitor used. The official image reads that header in its `wp-config.php`, so WordPress builds `https` links with no extra setting.

## You need

- The network layer from `02-remote-state`.
- A public Route 53 hosted zone for a domain you own.

## Run

```bash
cp terraform.tfvars.example terraform.tfvars   # set the bucket, the zone and the host name
terraform init -backend-config=../02-remote-state/backend.hcl
terraform apply
```

The first apply takes a while. The certificate must validate and the database must start. Then open the `url` output and finish the WordPress setup page.

## Cost

RDS, the load balancer and the NAT gateway bill while they run. Destroy at the end of the session. The database skips its final snapshot, so destroy deletes the data. That suits practice and no one's real site.

## Next step

The server keeps uploads on its own disk, so the Auto Scaling group is fixed at one instance. To run more than one, move `wp-content` to shared storage such as EFS, or store media in S3. That is a good exercise.

## Questions to talk through

- Why does the load balancer need to tell WordPress that the original request used HTTPS?
- Who can read the database password? Trace each path.
- Why is the health check allowed to accept a 302 redirect?
- What would a final snapshot and deletion protection change?
