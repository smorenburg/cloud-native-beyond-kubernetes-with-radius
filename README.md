# Radius Demo

## Deploy and configure the resources and application

**Step 1:** Set the variables. Replace `subscription_id` with the subscription identifier.

```bash
export APP=demo
export SUBSCRIPTION_ID=subscription_id
export ENVIRONMENT=staging
export LOCATION=northeurope
export RESOURCE_GROUP=rg-demo-stage-neu
```

**Step 2:** Create the Azure resource group for the application resources.

```bash
az group create \
  --location ${LOCATION} \
  --name ${RESOURCE_GROUP}
```

**Step 3:** Create a service principal and assign it the Contributor role to the subscription.

```bash
az ad sp create-for-rbac \
  --display-name ${RESOURCE_GROUP} \
  --role Contributor \
  --scope /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}
```

**Step 4:** Set the variables. Replace `client_id`, `client_secret`, and `tenant_id` with the service principal information.

```bash
export CLIENT_ID=client_id
export CLIENT_SECRET=client_secret
export TENANT_ID=tenant_id
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
rad group create ${APP}
```

**Step 9:** Create the environment in the Radius resource group.

```bash
rad env create azure --group ${APP}
```

**Step 10:** Deploy the environment configuration.

```bash
rad deploy environments/azure.bicep \
  --environment azure \
  --group ${APP} \
  --parameters subscriptionId=${SUBSCRIPTION_ID} \
  --parameters resourceGroup=${RESOURCE_GROUP}
```

**Step 11:** Deploy the application.

```bash
rad deploy app.bicep \
  --environment azure \
  --group ${APP}
```

# Delete the application and resources

**Step 1:** Delete the environment (including the application).

```bash
rad env delete azure \
  --group ${APP} \
  --yes
```
**Step 2:** Delete the resource group.

```bash
rad group delete ${APP} --yes
```

**Step 3:** Delete the workspace.

```bash
rad workspace delete ${ENVIRONMENT} --yes
```

**Step 4:** Delete the Azure resource group.

```bash
az group delete \
  --name ${RESOURCE_GROUP} \
  --yes
```

**Step 5:** Delete the app registration (including the service principal).
```bash
az ad app delete --id $(az ad app list --filter "displayName eq '${RESOURCE_GROUP}'" --query "[].appId" --output tsv)
```
