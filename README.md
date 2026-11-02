# Terraform CI/CD and DevSecOps Automation

A practical **portfolio CI/CD starter**, matching the DevSecOps workflow listed on my resume: **Terraform → format → validate → TFLint → tfsec → SonarQube (optional) → plan → manual approval → apply**.

## What's included
- `infra/`: minimal Azure RG + VNet Terraform foundation (safe starter, no public compute).
- `.github/workflows/terraform-quality.yml`: static CI validation; no cloud credentials required for `terraform validate`.
- `azure-pipelines.yml`: Azure DevOps pipeline (main branch only) with Azure service connection, a required **preconfigured remote Azure Storage backend**, and **explicit manual validation** before apply. Pull requests run the credential-free GitHub Actions quality checks instead.
- `.tflint.hcl`: baseline Terraform lint config.
- `sonar-project.properties`: optional SonarQube static-analysis configuration, requires `SONAR_TOKEN` and SonarQube server.

## Local quality checks
```powershell
terraform -chdir=infra init -backend=false
terraform -chdir=infra fmt
terraform -chdir=infra fmt -check
terraform -chdir=infra validate
# Optional installed scanners:
tflint --chdir=infra --init
tflint --chdir=infra
tfsec infra
```

## Review Azure changes (only with real access)
```powershell
az login
cd infra
Copy-Item terraform.tfvars.example terraform.tfvars
# Edit Azure subscription ID
terraform init -backend=false  # LOCAL demo state only; use remote backend for CI
terraform plan -out=deploy.tfplan
terraform apply deploy.tfplan    # creates Azure resources; costs possible
terraform destroy                # removes only these Terraform-managed resources
```

## Azure DevOps pipeline configuration
1. Create Azure Resource Manager service connection with least privilege and preferably workload identity federation.
2. In `azure-pipelines.yml`, replace `YOUR-AZURE-SERVICE-CONNECTION`.
3. In pipeline Variables, set `TF_VAR_subscription_id` to your Azure subscription ID (not a password).
4. The `plan` stage authenticates through `AzureCLI@2`; the `apply` stage has a `ManualValidation@1` server job. Validate approval policy in your Azure DevOps project.
5. **Required for apply pipeline:** create a separate Azure Storage state account/container **before running the Azure DevOps pipeline**. Configure protected `TF_BACKEND_RG`, `TF_BACKEND_STORAGE`, `TF_BACKEND_CONTAINER` and `TF_BACKEND_KEY` pipeline variables; give the pipeline identity Storage Blob Data Contributor on the container. The pipeline initializes the same remote state in Plan and Apply jobs.
6. The example creates a Terraform **plan artifact**, which can contain sensitive data; restrict pipeline readers/artifact access and never commit plan binaries. Real production pipelines should add environment approvals, credential hardening, and artifact retention policies.
6. Do not configure CI to auto-apply changes on untrusted pull requests.

## SonarQube and Azure Key Vault
- The repository provides SonarQube configuration and opt-in scan using `SONAR_TOKEN`/`SONAR_HOST_URL` secrets. A SonarQube instance/project must exist first.
- Azure Key Vault integration is shown as an **optional example** in `docs/KEY_VAULT.md`; no hard-coded secrets or Key Vault are created by default.

**Important:** Pipeline definitions are reusable starter code. They are **not evidence that a live Azure DevOps pipeline, SonarQube server, or deployed Azure resources already exist.**
