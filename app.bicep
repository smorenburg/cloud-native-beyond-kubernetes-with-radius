import radius as radius

@description('The Radius Application ID. Injected automatically by the rad CLI.')
param application string

@description('The ID of your Radius Environment. Set automatically by the rad CLI.')
param environment string

resource app 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'app'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    connections: {
      redis: {
        source: db.id
      }
    }
  }
}

resource db 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'db'
  properties: {
    environment: environment
    application: application
    recipe: {
      name: 'azure'
    }
  }
}

resource gateway 'Applications.Core/gateways@2023-10-01-preview' = {
  name: 'gateway'
  properties: {
    application: application
    routes: [
      {
        path: '/'
        destination: 'http://app:3000'
      }
    ]
  }
}
