# Radius Demo

## Deploying and configuring the resources and application

**Step 1:** Set the variables. Replace `subscription_id` with the subscription identifier.

```bash
export SUBSCRIPTION_ID=subscription_id
export ENVIRONMENT=staging
export LOCATION=northeurope
export RESOURCE_GROUP=rg-radius-stage-neu
```

**Step 2:** Create a service principal and assign it the Contributor role to the subscription.

```bash
az ad sp create-for-rbac \
  --role Contributor \
  --scope /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}
```

**Step 3:** Set the variables. Replace `client_id`, `client_secret`, and `tenant_id` with the service principal information.

```bash
export CLIENT_ID=client_id
export CLIENT_SECRET=client_secret
export TENANT_ID=tenant_id
```

**Step 4:** Create the Azure resource group for the application resources.

```bash
az group create \
  --location ${LOCATION} \
  --name ${RESOURCE_GROUP}
```

**Step 5:** Install Radius on the Kubernetes cluster.

```bash
rad install kubernetes
```

**Step 6:** Create a workspace for the application.

```bash
rad workspace create kubernetes ${ENVIRONMENT}
```

**Step 7:** Register the Azure credentials with Radius.

```bash
rad credential register azure \
  --client-id ${CLIENT_ID} \
  --client-secret ${CLIENT_SECRET} \
  --tenant-id ${TENANT_ID}
```

**Step 8:** Create the Radius resource group for the environment.

```bash
rad group create ${ENVIRONMENT}
```

**Step 9:** Create the environment in the Radius resource group.

```bash
rad env create azure --group ${ENVIRONMENT}
```

**Step 10:** Deploy the environment configuration.

```bash
rad deploy environments/azure.bicep \
  --environment azure \
  --group ${ENVIRONMENT} \
  --parameters subscriptionId=${SUBSCRIPTION_ID} \
  --parameters resourceGroup=${RESOURCE_GROUP}
```

**Step 11:** Deploy the application.

```bash
rad deploy app.bicep \
  --environment azure \
  --group ${ENVIRONMENT}
```

# Removing the resources and application

**Step 1:** Delete the application.

```bash
rad env delete azure \
  --group ${ENVIRONMENT} \
  --yes
```
