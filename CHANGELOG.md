# Changelog
All notable changes to this project will be documented in this file.

The format is base on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.39.00.000] - 2024-11-27
### Added
- [Issue #70](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/70)

## [0.38.00.000] - 2024-11-26
### Added
- [Issue #66](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/66)

### Changed
- [Issue #67](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/67)

## [0.37.00.000] - 2024-11-22
### Changed
- Upgraded the version of Terraform AWS Provider to `5.77.0`, and Terraform Snowflake Provider to `0.98.0`.

## [0.36.00.000] - 2024-11-08
### Changed
- Upgraded the version of Terraform AWS Provider to `5.75.0`, and Terraform Snowflake Provider to `0.97.0`.

## [0.35.00.000] - 2024-09-06
### Changed
- Replace deprecated `snowflake_role` with `snowflake_account_role`.

## [0.34.00.000] - 2024-09-06
### Fixed
- Passing `snowflake_warehouse` variable to the Terraform configuration in the GitHub Workflows.

## [0.33.00.000] - 2024-09-06
### Fixed
- Passing `service_account_user` variable to the Terraform configuration in the GitHub Workflows.

## [0.32.00.000] - 2024-09-06
### Fixed
- Removed the unused `snowflake_user` variable in the BASH script and GitHub `deploy` Workflow/Action.

## [0.31.00.000] - 2024-09-05
### Changed
- Upgraded the version of Terraform AWS Provider to `5.66.0`, and Terraform Snowflake Provider to `0.95.0`.

## [0.30.00.000] - 2024-09-04
### Added
- GitHub Action that determines the AWS Account ID.
- instructions on how to execute Terraform from a GitHub Workflow.
- update the `README.md`.

### Changed
- Updated the `.terraform.lock.hcl` with Terraform AWS Provider.

## [0.10.00.000] - 2024-08-30
### Changed
- Integrated the module output variables from `github.com/j3-signalroom/iac-snowflake-user-rsa_key_pairs_rotation-tf_module`.
- Removed direct reference to the AWS Secrets Manager secrets.

## [0.01.00.000] - 2024-08-28
### Added
- First release.