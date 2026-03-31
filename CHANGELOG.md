# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v3.1.1] - 2026-03-31
### Fixed
- Do not set password for `CLOUD_IAM_USER` and `CLOUD_IAM_SERVICE_ACCOUNT` types — Google Cloud SQL rejects any password (including empty string) for IAM-authenticated users

## [v3.0.0] - 2024-01-28
### Changed
- replication parameter for `google_secret_manager_secret` - making this compatible only with Google provider version 5

## [v2.2.0] - 2023-09-19
### Add
- `dont_create_user` to not create users in Cloud SQL if set to `true`

## [v2.1.0] - 2023-08-30
### Add
- default privileges setup for users once owner is set

## [v2.0.0] - 2023-05-30
### Removed
- `vault` support in favor of GCP Secrets Manager

## [v1.0.0] - 2022-11-28
### Added
- Add init, example, pre-commit hooks
