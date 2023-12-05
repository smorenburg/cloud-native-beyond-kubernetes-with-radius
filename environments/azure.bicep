import radius as radius

param resourceGroup string
param subscriptionId string

resource environment 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'azure'
  properties: {
    compute: {
      kind: 'kubernetes'
      resourceId: 'self'
      namespace: 'azure'
    }
    providers: {
      azure: {
        scope: '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}'
      }
    }
    recipes: {
      'Applications.Datastores/redisCaches': {
        default: {
          templateKind: 'bicep'
          templatePath: 'ghcr.io/radius-project/recipes/azure/rediscaches:latest'
        }
      }
    }
  }
}
