# Important: Prepare remote state before Azure DevOps Plan/Apply

Azure Pipelines uses separate ephemeral agents for Plan and Apply, so the state **must** be shared and locked via an Azure Storage backend. The example pipeline refuses to initialize without backend variables.

1. Sign in as an Azure administrator and create a dedicated RG, Storage Account, and private blob container for Terraform state, separate from the Terraform-managed app resources.
2. Set account configuration to prevent anonymous access and enable versioning. Configure cloud RBAC: the pipeline identity must have `Storage Blob Data Contributor` for the container. It also needs scoped Azure permissions for the resources it plans to deploy.
3. Create a protected Azure Resource Manager service connection (OIDC federation preferred).
4. Set pipeline variables: `TF_VAR_subscription_id`, `TF_BACKEND_RG`, `TF_BACKEND_STORAGE`, `TF_BACKEND_CONTAINER`, `TF_BACKEND_KEY` (for example `devsecops-demo.tfstate`).
5. Replace the placeholder service-connection name in `azure-pipelines.yml`.
6. Plan/Apply jobs both call `terraform init` using the **same** backend key. Verify state exists and permissions are correct before manually approving Apply.
7. Do NOT use shared state across unrelated environments. Avoid publishing plan files to public build artifacts; they can contain secrets.

For local examples, `terraform init -backend=false` uses local state; don't use ephemeral local state in a multi-agent deployment pipeline.

References: https://developer.hashicorp.com/terraform/language/backend/azurerm and https://learn.microsoft.com/en-us/azure/terraform/terraform-backend
