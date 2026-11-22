# 07 Audit

Infrastructure code ages. A repository that worked in 2023 can still plan today and be wrong in ways nothing warns you about. This folder is a checklist for reviewing Terraform that someone wrote a while ago, and a script that finds the easy ones.

## Run the scan

```bash
./scan.sh path/to/your/terraform
```

It prints each finding with the file, the line and a reason. The exit status is 1 when it finds anything, so you can put it in CI.

To see it work, point it at the teaching fixture:

```bash
./scan.sh examples
```

You should see ten findings.

## The checklist

The script covers the first eleven. The rest need your eyes.

1. **`aws_eip` with `vpc = true`.** Use `domain = "vpc"`.
2. **DynamoDB locking.** The `dynamodb_table` setting on the S3 backend is deprecated. Use `use_lockfile = true`.
3. **Amazon Linux 2.** It reached end of support on 30 June 2026. Move to Amazon Linux 2023.
4. **Ubuntu 20.04.** Standard support ended in May 2025.
5. **RDS for MySQL 5.7 and 8.0.** Both now run under paid Extended Support, which ends on 30 June 2029 for 5.7 and 31 July 2029 for 8.0. Move to 8.4.
6. **`t1.micro`.** It is a previous generation type. Use a current one.
7. **`AmazonEC2RoleforSSM`.** AWS is deprecating it. Use `AmazonSSMManagedInstanceCore`.
8. **Fixed IP addresses in code.** Take them from variables.
9. **Credentials in code or user data.** Use a managed secret, and read it at run time.
10. **Unpinned modules.** Every registry module needs a `version`. The scan reports the ones that have none.
11. **State committed to Git.** The scan checks this too. State can hold secrets.
12. **Provider versions.** Pin them with `~>` and commit the lock file in a real project.
13. **Open security groups.** Look for `0.0.0.0/0` on anything but a public web port.
14. **Encryption.** Look for unencrypted volumes, buckets and databases.

## Sources

I checked the dated facts against these pages on 22 November 2026. Check them again before you rely on a date, because cloud providers change them.

- [Amazon Linux 2 FAQ](https://aws.amazon.com/amazon-linux-2/faqs/)
- [Ubuntu release cycle](https://ubuntu.com/about/release-cycle)
- [Terraform S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3)
- [RDS for MySQL release calendar](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Concepts.VersionMgmt.html)
- [AmazonEC2RoleforSSM managed policy](https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEC2RoleforSSM.html)
- [aws_eip resource](https://github.com/hashicorp/terraform-provider-aws/blob/main/website/docs/r/eip.html.markdown)
