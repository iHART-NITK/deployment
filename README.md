# iHART

> A Distributed, Real-Time Cross Platform Application for Healthcare Management and Automation

**iHART** is a software product that provides an interface for students and faculty of NITK to access healthcare facilities on campus. It also helps the HCC staff manage their work and documents better.

## iHART Deployment

This repository contains 3 GitHub Actions, namely:

- **[Terraform Validation Action](https://github.com/iHART-NITK/deployment/actions/workflows/terraform-plan.yml)**: This action simply validates the Terraform configuration and generates the Terraform Plan, which essentially performs a dry run on the configuration and shows the infrastructure to be configured.
- **[Terraform Apply Action](https://github.com/iHART-NITK/deployment/actions/workflows/terraform-apply.yml)**: This action applies the configuration and deploys the entire application to the Microsoft Azure Cloud.
- **[Terraform Destroy Action](https://github.com/iHART-NITK/deployment/actions/workflows/terraform-destroy.yml)**: This action destroys the infrastructure that was created.

The Terraform State is managed on the Terraform Cloud, enabling remote workflows to run using the same state.
