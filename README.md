# IaC Snowflake Resources Terraform Configuration
[Terraform](https://terraform.io), an open-source Infrastructure as Code (IaC) tool developed by HashiCorp, uses a declarative approach for managing infrastructure resources. Unlike imperative programming languages like Java, which require explicit, sequential commands to achieve a specific outcome, Terraform enables users to define their desired infrastructure state through configuration files using a YAML-like syntax. This approach abstracts the complexity of manual infrastructure management by allowing users to focus on "what" the final state should be rather than "how" to achieve it.

With Terraform, users can efficiently manage a wide range of [Snowflake resources](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest)—including Warehouses, Databases, Schemas, Tables, and Roles/Grants—by defining their desired state in configuration files. Terraform maintains a detailed record of the current state of these resources and compares it against the desired state specified by the user. Based on this comparison, Terraform automatically generates a reconciliation plan to bring the existing infrastructure into alignment with the desired configuration. This process involves creating, updating, or deleting resources as needed, enabling consistent, repeatable, and predictable management of infrastructure components.

The configuration leverages the [IaC Snowflake User RSA key pairs Rotation Terraform module](https://github.com/j3-signalroom/iac-snowflake-user-rsa_key_pairs_rotation-tf_module) to automate the creation and rotation of [RSA key pairs](https://github.com/j3-signalroom/j3-techstack-lexicon/blob/main/cryptographic-glossary.md#rsa-key-pair) for a Snowflake service account user. This module ensures that each RSA key pair is securely rotated based on a defined schedule, reducing the risk of credential compromise and improving the overall security of the data streaming environment.

To protect sensitive credentials, the configuration securely stores the generated RSA key pairs for both resources in AWS Secrets Manager, ensuring that only authorized users and services have access to these credentials. This secure storage method prevents unauthorized access and minimizes the risk of key exposure.

**Table of Contents**

<!-- toc -->
+ [Let's get started!](#lets-get-started)
+ [Resources](#resources)
<!-- tocstop -->

## Let's get started!
**These are the steps**

1. Take care of the cloud and local environment prequisities listed below:
    > You need to have the following cloud accounts:
    > - [GitHub Account](https://github.com) *with OIDC configured for AWS*
    > - [Snowflake Account](https://www.snowflake.com/en/)
    > - [Terraform Cloud Account](https://app.terraform.io/)

    > You need to have the following installed on your local machine:
    > - [Terraform CLI version 1.85 or higher](https://developer.hashicorp.com/terraform/install)

2. Clone the repo:
    ```bash
    git clone https://github.com/j3-signalroom/create-snowflake_admin_user-with_rsa_key_pair_authentication.git
    ```

    Then refer to [`create-snowflake_admin_user-with_rsa_key_pair_authentication README`](https://github.com/j3-signalroom/snowflake_admin_service_account_user) to set it up.

3. Clone the repo:
    ```bash
    git clone https://github.com/j3-signalroom/iac-snowflake-user-rsa_key_pairs_generator-lambda.git
    ```

    Then refer to [`iac-snowflake-user-rsa_key_pairs_generator-lambda README`](https://github.com/j3-signalroom/iac-snowflake-user-rsa_key_pairs_generator-lambda) to set it up.
 
4. Clone the repo:
    ```shell
    git clone https://github.com/j3-signalroom/iac-snowflake-resources-tf.git
    ```

5. Update the cloned Terraform module's [main.tf](main.tf) by following these steps:

    a. Locate the `terraform.cloud` block and replace **`signalroom`** with your [Terraform Cloud Organization Name](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/organizations).

    b. In the `terraform.cloud.workspaces` block, replace **`iac-snowflake-resources-workspace`** with your [Terraform Cloud Organization's Workspaces Name](https://developer.hashicorp.com/terraform/cloud-docs/workspaces).

## Resources

[Snowflake's Terraforming Quickstart](https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#0)

[Terraform Snowflake Provider Beta](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.94.1)
> *[Roadmap](https://github.com/Snowflake-Labs/terraform-provider-snowflake/blob/main/ROADMAP.md)*
