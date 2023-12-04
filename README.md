# Radius Demo

## Deploying the resources

**Step 1:** Initialize Radius

```bash
rad init --full
```

**Step 2:** Register the Azure recipe for Redis.

```bash
rad recipe register azure --environment default --template-kind bicep --template-path ghcr.io/radius-project/recipes/azure/rediscaches:latest --resource-type Applications.Datastores/redisCaches
```

**Step 3:** Deploy the app.

```bash
rad deploy app.bicep
```
