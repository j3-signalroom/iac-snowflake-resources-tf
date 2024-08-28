# IaC Snowflake Resources Terraform Configuration
[Terraform](https://terraform.io), developed by HashiCorp, is an open-source Infrastructure as Code (IaC) tool that employs a *declarative* approach to resource management.  Unlike *imperative* programming languages like Java, which require explicit, step-by-step instructions to implement a solution, Terraform allows users to specify desired outcomes using a YAML-like syntax. Users can manage a variety of [Snowflake resources](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest), including Warehouses, Databases, Schemas, Tables, and Roles/Grants, by defining what they should look like in the configuration files.  Terraform maintains a record of the infrastructure's current state and compares it to the desired state outlined by the user.  It then automatically devises a reconciliation plan to align the current infrastructure with the desired configuration, handling the creation, update, or deletion of resources as needed.  This process enables efficient and predictable management of infrastructure components.

**Table of Contents**

<!-- toc -->
+ [Let's get started!](#lets-get-started)
+ [Resources](#resources)
<!-- tocstop -->

## Let's get started!
**These are the steps**

1. Take care of the cloud environment prequisities listed below:
    > You need to have the following cloud accounts:
    > - [AWS Account](https://signin.aws.amazon.com/) *with SSO configured*
    > - [GitHub Account](https://github.com) *with OIDC configured for AWS*
    > - [Terraform Cloud Account](https://app.terraform.io/)

2. Clone the repo:
    ```shell
    git clone https://github.com/j3-signalroom/iac-snowflake-resources-tf.git
    ```

3. Update the cloned Terraform module's [main.tf](main.tf) by following these steps:

    a. Locate the `terraform.cloud` block and replace **`signalroom`** with your [Terraform Cloud Organization Name](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/organizations).

    b. In the `terraform.cloud.workspaces` block, replace **`snowflake-resources-workspace`** with your [Terraform Cloud Organization's Workspaces Name](https://developer.hashicorp.com/terraform/cloud-docs/workspaces).

## Resources

[Snowflake's Terraforming Quickstart](https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#0)

[Terraform Snowflake Provider Beta](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs)
> *[Roadmap](https://github.com/Snowflake-Labs/terraform-provider-snowflake/blob/main/ROADMAP.md)*
