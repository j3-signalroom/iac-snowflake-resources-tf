# Changelog
All notable changes to this project will be documented in this file.

The format is base on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [0.52.00.000] - TBD
### Added
- Issue [#122](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/122)
- Issue [#123](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/123)
- Issue [#130](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/130)
- Issue [#131](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/131)
- Issue [#134](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/134)

### Changed
- Issue [#126](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/126)
- Issue [#128](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/128)

## [0.51.00.000] - 2025-08-31
### Added
- Issue [#118](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/118)
- Issue [#119](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/119)

## [0.50.00.000] - 2025-08-08
### Added
- Issue [#97](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/97)
- Issue [#100](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/100)
- Issue [#102](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/102)
- Issue [#104](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/104)
- Issue [#108](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/108)

### Changed
- Issue [#111](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/111)

### Removed
- Issue [#106](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/106)

## [0.44.01.000] - 2025-05-19
### Added
- Issue [#91](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/91)

## [0.44.00.000] - 2025-05-19
### Added
- Issue [#89](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/89)

## [0.43.00.000] - 2025-04-19
### Added
- Issue [#85](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/85)

## [0.42.00.000] - 2025-04-13
### Added
- [Issue #83](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/83)

## [0.41.00.000] - 2025-01-09
### Added
- [Issue #77](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/77)

## [0.40.00.000] - 2024-12-13
### Added
- [Issue #74](https://github.com/j3-signalroom/iac-snowflake-resources-tf/issues/74)

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