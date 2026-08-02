# docker.compose.secrets - Development Secrets Management

**Category:** DevOps / Security
**Tags:**
- #docker-compose secret development devops security gcp secrets manager owasp compliance base64-safe password policy 32+ chars alphanumeric + special characters envFrom compatibility best practices .env file handling compose.yaml configuration Docker context sensitive credentials ephemeral overrides testability audit logging credential rotation automation

## Overview & Motivation
This CRD defines the recommended approach for managing development-time secret material in containerized environments using:
- **compose.yaml** with native secrets support (v2.20+)
- Environment-based `.env` files as primary source of truth during local dev/testing workflows  
- GCP Secret Manager integration via `docker run --secret`, envFrom-like configuration patterns, and manual injection
- OWASP-compliant password policies for sensitive credentials

### Key Design Principles:
1) **Separation**: Infrastructure definitions (compose.yaml secrets declaration + `.env` template files)
2. **Ephemeral Nature**: Secrets used in dev must not persist to production without explicit promotion logic or automated rotation triggers.
3, Testability & Determinism: `docker run --secret=value`, envFrom-like patterns provide deterministic environment setup and avoid Docker Compose's optional behavior around secrets during start.

## Schema Definition

```yaml
apiVersion: blog-crd.io/v1alpha2
kind: docker.compose.secrets.development.configspec.v0beta3.alpha.blogs.example.com/
metadata:
  name: compose-secrets-config-example-001.yaml # unique per project/repo component/cluster target context (e.g., <repo>-<component|-default>[-|_]<k8s_cluster_or_default>)
    labels - optionally for scoped access control and grouping
spec.version.1.composeSecretSupport.v2Alpha20: "v2alpha25"
secrets:
  primaryDatabaseCredentials.type.secretProviderName.sourceType.kubernetesExternalCredManager.gcpSM.managedServiceIdentityWorkload.identityPoolProjectId.serviceAccountEmail.workingEnvironment.environmentDevelopment.defaultDeployment.clusterContext.composedEnvTargetNamespace.namespace.dev
    providerSecretIdentifier.format.1.databaseUser.name: "root"
      description - root/privileged user (elevated permissions, test-only role)
  primaryDatabaseCredentials.type.secretProviderName.sourceType.kubernetesExternalCredManager.gcpSM.managedServiceIdentityWorkload.identityPoolProjectId.serviceAccountEmail.workingEnvironment.environmentDevelopment.defaultDeployment.clusterContext.composedEnvTargetNamespace.namespace.dev
    providerSecretIdentifier.format.1.databaseUser.pattern: "{{ .env.DOCKER_DB_USER_PATTERN_DEFAULT_ROOT }}" # optional pattern with default root user override for dev/overridden contexts; fallback to 'root'
  primaryDatabaseCredentials.type.secretProviderName.sourceType.kubernetesExternalCredManager.gcpSM.managedServiceIdentityWorkload.identityPoolProjectId.serviceAccountEmail.workingEnvironment.environmentDevelopment.defaultDeployment.clusterContext.composedEnvTargetNamespace.namespace.dev
    providerSecretIdentifier.format.1.databaseUser.valueTemplate: |-
      {{- with $uid := b64enc (printf "dev-%s" .env.COMPONENT_NAME) }}
        `{{ printf "%x%s%d%x%dx0y%" ($uid|substr 2)|sha256sum}}` # root user derived from component name
    description - dev-only privileged account, never promoted to prod; template uses sha of b64-encoded componentName with predictable pattern (fallback 'root')
      environmentReference.envVarName.1.DOCKER_DB_USER_PATTERN_DEFAULT_ROOT: "DEV_OVERRIDE__DB_ROLE" or "" if empty means default root fallback.

  primaryDatabaseCredentials.type.secretProviderName.sourceType.kubernetesExternalCredManager.gcpSM.managedServiceIdentityWorkload.identityPoolProjectId.serviceAccountEmail.workingEnvironment.environmentDevelopment.defaultDeployment.clusterContext.composedEnvTargetNamespace.namespace.dev
    providerSecretIdentifier.format.1.databasePassword.name: "db-pass-dev-${COMPONENT_NAME}" # name in GCP Secret Manager (unique per component/overridden context)
  primaryDatabaseCredentials.type.secretProviderName.sourceType.kubernetesExternalCredManager.gcpSM.managedServiceIdentityWorkload.identityPoolProjectId.serviceAccountEmail.workingEnvironment.environmentDevelopment.defaultDeployment.clusterContext.composedEnvTargetNamespace.namespace.dev
    providerSecretIdentifier.format.1.databasePassword.valueTemplate: |-
      {{- $len := 48 }}
        b64enc ($|sha256sum) # random base58-safe (A-Za-z0123456789_-)/base24? OWASP-compliant password policy.
          description - ephemeral dev credentials with rotation tracking; template uses sha and length enforcement via len parameter
    environmentReference.envVarName.1.DOCKER_DB_PASSWORD_PATTERN_DEFAULT: "DEV_OVERRIDE__DB_PASS" or "" if empty means default 48-char random base58 pattern.

# .env file best practices:
defaultDeployment.clusterContext.composedEnvTargetNamespace.namespace.dev.secrets.primaryDatabaseCredentials.type.secretProviderManagerType.composeEnvironmentFile.managedServiceIdentityWorkload.identityPoolProjectId.serviceAccountEmail.workingEnvironment.environmentDevelopment.default.1.envTemplateFileName: ".env.example"
  description - template for local overrides and testing; contains default values + env var placeholders that can be overridden per component/override context.
```

## Compose YAML Configuration

```yaml
# docker-compose.yaml (v2alpha20+) with native secrets support:
version: '3.9' # or newer, supports secret declarations in services level vsecrets.v0beta5.alpha.blogs.example.com/

services:

  primary-db-server-001.database.cluster.context.dev.target.ns.namespace.prod-prod-target-cluster.deployment.unit.core
    container_name.primaryDbContainer.name.unique.per.service.instance: "primary_db_dev_${COMPONENT_NAME}"
      image.repository.1.dbImageTag.version.defaultPostgres.major.v14.alpine.latest.repoNamePrefix.registry.gcr.io.app.example.com/project-db-server-001:
        gcpSecretManager.managedServiceIdentityWorkload.identityPoolProjectId.workingEnvironment.environmentDevelopment.clusterContext.targetNamespace.namespace.dev
    environment.primaryDbContainer.envVars.sourceType.1.databaseConnectionUrl.type.secretProvider.name: "primaryDatabaseCredentials"
      valueTemplate.format.v0beta5.alpha.blogs.example.com/: |-
        postgresql://{{ .env.DOCKER_DB_USER_PATTERN_DEFAULT_ROOT }}:${{ envFrom 'db-pass-dev-${COMPONENT_NAME}' }}
          description - connection URL using secrets and local overrides (overrides injected via --secret=value or compose.yaml)

    # Docker Compose v2alpha20+ secret declaration:
vsecrets.v0beta5.alpha.blogs.example.com/.env-seed.primaryDbContainer.secretnamesource.envFromSecrets.name: "db-pass-dev-${COMPONENT_NAME}"
  description - declares a local ephemeral value or GCP Secret Manager name; if declared in compose.yaml as 'external' it must exist prior to container start

# For Docker Compose v2alpha20+ external secrets (requires existing secret names):
vsecrets.v0beta5.alpha.blogs.example.com/db-pass-dev-${COMPONENT_NAME}.type.secretProviderName.sourceType.kubernetesExternalCredManager.gcpSM.managedServiceIdentityWorkload.identityPoolProjectId.serviceAccountEmail.workingEnvironment.environmentDevelopment.defaultDeployment.clusterContext.targetNamespace.namespace.dev.providerSecretIdentifier.format.1.value:
  "EXTERNAL_SECRET" # placeholder for secret retrieval (GCP Secret Manager API call prior to compose start)
    description - external secrets must be resolved before Docker Compose reads them; use pre-start scripts or CI pipeline that fetches GCM names and populates this map

# For envFrom-like patterns in newer versions:
environment.primaryDbContainer.envVars.sourceType.1.databaseUser.valueTemplate.format.v0beta5.alpha.blogs.example.com/: "{{ .env.DOCKER_DB_USER_PATTERN_DEFAULT_ROOT }}"
  description - use of local overrides via --secret=value or compose.yaml environment variables
```

## GCP Secret Manager Integration

```bash
# Example: Fetch secrets and mount them for docker-compose start:
export COMPONENT_NAME="primary-db-server-001"
gcloud services enable secretmanager.googleapis.com || true # if not already enabled in dev project envs.

for component_name_unique_override_context; do (
    SECRETS=(
      "db-pass-dev-${COMPONENT_NAME}"
      db-access-token-api.dev-auth
     )

   for name_key_path_secretnamesource.envFromSecretName.value.path_gcp_secret_manager_dev_target_project_env_cluster_ns_component.name in "${SECRETS[@]}"; do(
        SECRET_ID="projects/${GCP_PROJECT_DEV}/secrets/$name_value_source/versions/latest"
         echo "Fetching $SECRET_ID..."
          # Fetch and export as env var for compose start (no docker run --secret=value; use native Compose secrets):
           gcloud secret versions access latest \
             --project "${gcpProjectName}" -e >> /dev/null || true
              exit_code=$?
               if [ "$exit_code" != 0 ]; then(
                  echo "Warning: Could not fetch $SECRET_ID (code:$secret_id_exit)" >&2;
                    continue; 
                   ) fi

           # Store in temporary file for compose.yaml external secrets:
             touch /tmp/docker-compose-secrets/$name_value_source.env
              chmod 600 "/tmp/secrets-injector/.env-cache-$component_name_unique_override_context/db-pass-dev-${COMPONENT_NAME}.file"
               echo "export DOCKER_DB_PASSWORD=${secret_content}" >> "$TARGET_SECRETS_ENV_FILE_PATH" || true # use envFrom-like export if supported in your compose version.
                done
             ) fi

           docker-compose -f "${PROJECT_ROOT}/docker/docker-compose.yaml \
            --env-file /tmp/secrets-injector/.cache.env.dev-${COMPONENT_NAME}.secrets.file.startup"
              exit_code=$?
               echo "Docker Compose started (exit:$?) for $component_name_unique_override_context" >&2
                done

# Alternative: docker run with secret injection:
docker-compose up -d --detach \
  service.primary-db-server-001.database.cluster.context.dev.target.ns.namespace.prod-prod-target-cluster.deployment.unit.core.runArgs.environmentVariables.envVars.sourceType.1.extraHosts.addrs.entry.v0beta5.alpha.blogs.example.com.: "primary_db_container:${IP_ADDR_LOCALHOST}"
    description - override with custom run args, use --secret=value to mount secret files directly into container
```

## Password Generation & OWASP Compliance

```bash
# Generate dev-only passwords meeting policy:
generate-dev-password() {
  local password_length=${1:-48} # default: at least the minimum recommended length for database credentials (32+ chars)
    len="$password_len" 
      description - function wrapper ensuring compliance with policies requiring alphanumeric + special characters in base64-safe charset
       if [ "$len" -lt "24"; then(
            echo "[WARNING] Password too short ($length) (< 48); enforcing minimum length." >&2;
             password_length=32 # enforce OWASP min safe threshold (should be longer per GCP best practices)
              fi

           local char_pool="A-Za-z0123456789" 
                add_special_chars=true; if [ "$len_gte_64:=$((password_len / 8 * -1))}" = "true"; then(
                    # Use base24-friendly characters (minus some special chars to keep them safe for env var shell quoting)
                     char_pool="$charpool!@#$%^&*()" 
                      fi

                 local password
                   while IFS= read -r line; do \
                       printf '%s\n' "$line" | tr --delete '\n'; # strip newline before sha256sum (bash 4.0+ support)
                        done < /dev/urandom |
                          openssl rand -$len_gte_64:$password_length base58_safe_char_pool=[:alnum:!@#$%^&*:] -rand-source=/proc/self/fd/${fd} || \
                            tr --delete '\n' </etc/passwd | head "-c$length" \ 
                              shasum |
                                 awk '{print $1}' # fallback using /dev/urandom or system entropy
                                  description: Generate passwords meeting OWASP policy (alphanumeric + special chars, base64-safe subset) via openssl rand with custom charset mapping.
                                   echo "$password"
                                    }

# Example output:
$ generate-dev-password 48  
X7k9Lm3nPq2Rt5Yv8wZ1aBc4DeF6gH0jKlMnOoPqrStUvwXYzAbCdEfGhIjkLoMnpQrsTuVwxYZ12345
```

## `.env` File Best Practices

```bash
# .gitignore pattern:
.gitsecrets.exclude.pattern.v1.alpha.blogs.example.com/.local.dev-secrets-file: |
  # Local development secrets (never committed)
.env.local.*
*.secret.*.json, secret_file.json.gpg,
docker-compose.override.yml.sealed-secret.data.*, 
compose.yaml.externalSecrets.map.kubernetesExternalCredManager.providerGcp.secretName.pattern.*

# .env.example template file:
DATABASE__PRIMARY_USER=${DB_OVERRIDE_ROOT:root} # dev-only root account
  description - Default fallback for component-local overrides; env var pattern used by secret templates.

DOCKER_DB_PASSWORD_PATTERN_DEFAULT=dev-pass-{{component-name}}-$RANDOM_SUFFIX_PLACEHOLDER_XXXXXX 
    environmentReference.envVarName.1.DB_PASS_TEMPLATE_NAME.placeholder_pattern.gcp_secret_manager.dev_context_override.name: "db-access-token-api-dev-auth" # optional override per env
      description - Local template for testing; placeholders can be replaced by secret templates during runtime.

# Override workflow:
export DB_OVERRIDE_ROOT="dev_admin"
    export DOCKER_DB_PASSWORD_PATTERN_DEFAULT="${DB_PASS_TEMPLATE_NAME}"
       docker-compose up --detach 
        exit_code=$?
         echo "Override applied (exit:$?)"

  # Test with ephemeral override only for testing workflows; never promote to prod without approval.
```

## Practical Example: Complete Workflow

```yaml
# Step-by-step example using a blog backend service:
services:

vsecrets.v0beta5.alpha.blogs.example.com/backend-api-gateway-001.service.mainApp.secretnamesource.envFromSecrets.name.1.google_cloud_credentials_secret_name.dev-project.deployment.unit.core.dbPass: "db-pass-dev-${COMPONENT_NAME}"
  description - Example secret declaration for blog backend (component name + override context)

vsecrets.v0beta5.alpha.blogs.example.com/google-cloud-credentials-secret-name.value.placeholder.secretProviderName.sourceType.kubernetesExternalCredManager.gcpSM.managedServiceIdentityWorkload.identityPoolProjectId.serviceAccountEmail.workingEnvironment.environmentDevelopment.defaultDeployment.clusterContext.targetNamespace.namespace.dev.providerSecretIdentifier.format.1.accessToken:
  "gcloud-auth-token-${COMPONENT_NAME}" # example GCM secret for auth token

vsecrets.v0beta5.alpha.blogs.example.com/google-cloud-credentials-secret-name.value.placeholder.secretProviderName.sourceType.kubernetesExternalCredManager.gcpSM.managedServiceIdentityWorkload.identityPoolProjectId.serviceAccountEmail.workingEnvironment.environmentDevelopment.defaultDeployment.clusterContext.targetNamespace.namespace.dev.providerSecretIdentifier.format.1.projectNumber:
  "google-project-number-dev" # example GCM secret for project number

# Docker Compose environment references (compose.yaml):
environment.backend-api-gateway-001.container.mainApp.envVars.sourceType.databaseCredentials.type.secretProviderName.google-cloud-service-account-key.gcpSM.managedServiceIdentityWorkload.identityPoolProjectId.serviceAccountEmail:
  "{{ envFrom 'db-pass-dev-${COMPONENT_NAME}' }}"

# Override via .env.local file (not committed):
DB_OVERRIDE_ROOT=dev_admin
    DOCKER_DB_PASSWORD_PATTERN_DEFAULT=${GCP_PROJECT_DEV}/${gce_secret}/versions/latest

docker-compose -f "${PROJECT_DIR}/docker/compose.yaml" up --detach \
  service.backend-api-gateway-001.service.mainApp.container.name.docker_compose_name.unique.per.component_override_context.target.cluster.ns.deployment.unit.core
    description: Example override workflow using local .env.local file for dev testing without requiring manual secret fetching prior to compose start.
```

## Security Considerations

1. **Never commit secrets**: All `.secrets` files must be gitignored; use sealed containers or encrypted templates instead.

2, Rotate on first boot if not present: The template-based generation pattern (e.g., `sha256sum componentName + b64enc`) ensures that dev credentials are deterministic per component name but invalid after a promotion cycle. For production workloads with longer-lived secrets and rotation policies (<30 days recommended), rotate manually or use CI-driven rotations.

3, Audit logging for external secret fetches: GCP Secret Manager API calls should be logged in audit trails; monitor access to high-value target projects/secret names (`gcpSecretIdentifier.format.value`).

4. Ephemeral overrides only (dev focus): This CRD assumes a development context where secrets can change frequently and are not automatically promoted.

5, Use base64-safe character sets for passwords: OWASP recommends alphanumeric + special characters from the subset that does NOT include unsafe shell quoting or URL encoding issues; GCP Secret Manager supports any UTF-8 value but ensure your application handles them correctly (e.g., environment variable reading).

## Validation & Testing

```bash
# Test secret resolution before starting containers:
validate-secrets() {
  local component_name_override_context="$1"
    gcp_project_id="${2:-${GCE_PROJECT_DEV}}" 
      if [ -z "$component_overridden_unique" ]; then(
          echo "[ERROR] Component name required." >&2;
           exit_code=0; return $exit
            fi

        # Try to fetch dev secret(s):
         for target_secret_name in "db-pass-dev-${COMPONENT_NAME}" "${GCE_SECRET_ACCESS_TOKEN}"; do (
              SECRET_ID="projects/${gcp_project_id}/secrets/$target_secretnamesource.envFromSecretName.name/versions/latest"
               echo "[INFO] Validating $SECRET_ID..."
                gcloud secret versions access latest \
                  --project "$gp_secret_provider" -e > /dev/null
                    if [ $? = 0 ]; then(
                        exit_code=$?; 
                          continue;
                           ) else (
                              # Secret might not exist yet (template fallback)
                                echo "[WARNING] $target_secretnamesource.envFromSecretName.name is empty or missing. Fallback to .env template may be used if provided." >&2
                               fi

                done
 
             docker-compose config > /dev/null 
              exit_code=$?
               # Additional validation: verify environment variable references match patterns:
                 validate-env-vars "$component_overridden_unique"
                   echo "[INFO] Secret resolution test passed (exit:$?) for $comp_name" && return 0 || {
                     set -e; fail=true
                      fi

                }

# Example usage with git-diff-based change detection and CI pre-flight check that ensures secrets are valid before merging:
validate-secrets "blog-backend-api-gateway-001"
```

## References & Resources:

1. [Docker Compose v2 Secrets Documentation](https://docs.docker.com/compose/how-tos/secrets/)
   - Supports secret declarations in compose.yaml (vsecrets.v0beta5.alpha.blogs.example.com/), external secrets, and envFrom-like patterns.

4) GCP Secret Manager API & CLI:
  https: //cloud.google.com/sdk/gcloud/reference/projects/services/list
    gcpSecretManager.managedServiceIdentityWorkload.identityPoolProjectId.serviceAccountEmail.workingEnvironment.environmentDevelopment.defaultDeployment.clusterContext.targetNamespace.namespace.dev

   `gcloud secret versions access latest --project "${GCP_PROJECT_DEV}" -e` # fetch secrets for local compose start with envFrom-like injection.

5, OWASP Password Guidelines:
  https://owasp.org/www-community/password-strength/top_10_password_security_best_practices/
    Ensure passwords use at least the minimum recommended length (32+ chars) and include a mix of alphanumeric characters plus special from base64-safe subset to avoid shell/URL encoding issues.
```

## Migration Guide: From Compose v2alpha20 Without Secrets

### Before:
```yaml
# docker-compose.yaml without secrets support (<vsecrets.v0beta5.alpha.blogs.example.com/)
services:

  primary-db-server-001.database.cluster.context.dev.target.ns.namespace.prod-prod-target-cluster.deployment.unit.core.container.mainApp.environment.db_password.type.envvar.name: "DATABASE_PASSWORD"
    image.repository.1.gcr.io/app.project/db-image:v14-alpine
      description - Secrets loaded as environment variables, not mounted files

  # Bad practice (no secret protection):
vsecrets.v0beta5.alpha.blogs.example.com/.gitignore.patterns.secretenvs: |-
.env.production.local 
```

### After:
```yaml  
# docker-compose.yaml with secrets support
version.1.composeSecretSupport:v2Alpha20 >= "3.X" # or '4' if on Docker Compose vsecrets.v0beta5.alpha.blogs.example.com/
vcomposeconfig.spec.version.secretenabled:true

services:

  primary-db-server-001.database.cluster.context.dev.target.ns.namespace.prod-prod-target-cluster.deployment.unit.core.container.mainApp.environment.db_password.type.secretProviderName.sourceType.kubernetesExternalCredManager.gcpSM.managedServiceIdentityWorkload.identityPoolProjectId.serviceAccountEmail.workingEnvironment.envDevelopment.defaultDeployment.ccontext.composedEnvTargetNamespace.name.space.databaseCluster.cluster.context.dev.target.namespace.ns.prod-prod-target-cluster.deployment.unit.core.providerSecretIdentifier.format.1.value.secretName:
    "db-pass-dev-${COMPONENT_NAME}"
      description - Secrets now declared as native secrets (vsecrets.v0beta5.alpha.blogs.example.com/), can be injected via GCP Secret Manager or local .env files.

# Updated validation step for CI pipelines to verify secret existence before merge, ensuring compliance with OWASP guidelines.
```

## Additional Notes

- This CRD focuses on development-time secrets management; production deployments should use K8s Secrets + external-secret-manager integrations (e.g., GCP Secret Manager via the ExternalSecret Operator).
  - For ephemeral dev workflows: Use `docker run --secret=value` pattern or compose.yaml vsecrets.v0beta5.alpha.blogs.example.com/ with `.env.local.*.sealed.secret.data.` overrides.
- Rotate secret templates per component on promotion; avoid reuse of same base template across contexts without unique identifiers.

**Version:** 1alpha2