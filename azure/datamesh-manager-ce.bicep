@description('Location for all resources.')
param location string = resourceGroup().location

@description('The name of the web app. This will also be used for the default domain name \${webAppName}.azurewebsites.net, so it must be unique.')
param webAppName string = 'datameshmanager-${resourceGroup().name}'

@description('SMTP server host')
param smtpHost string

@description('SMTP server port')
param smtpPort string

@description('Login user of the SMTP server')
param smtpUsername string

@description('Login password of the SMTP server')
@secure()
param smtpPassword string

@description('Use basic authentication for SMTP')
param smtpBasicAuth bool = true

@description('Ensure that TLS is used')
param smtpStarttls bool = true

@description('The Docker container image URL.')
param containerImageUrl string = 'datameshmanager/datamesh-manager-ce:latest'

@description('App Service plan pricing tier. Should have 4 GB.')
// P1v2 = 1vCPU, 3.5 GB, $83/month
param appServicePlanSku string = 'P1v2'

@description('Postgres compute tier size')
// $160/month
param postgresComputeTierSizeSku string = 'Standard_D2s_v3'

@description('Postgres storge size in GB. Min 128 GB.')
param postgresStorageSizeGB int = 128

@description('The name of the PostgreSQL server.')
param postgresServerName string = 'datameshmanager-postgres'

@description('The administrator username of the PostgreSQL server.')
param postgresAdminUsername string = 'adminuser'

@description('The administrator password of the PostgreSQL server.')
@secure()
param postgresAdminPassword string = newGuid()

@description('The database name.')
param databaseName string = 'postgres'

@description('The virtual network name.')
param vnetName string = 'datameshmanager-vnet'

@description('The address prefix for the virtual network.')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('The subnet name.')
param webappSubnetName string = 'webapp-subnet'

@description('The address prefix for the subnet.')
param webappSubnetAddressPrefix string = '10.0.1.0/24'

@description('The address prefix for the PostgreSQL subnet.')
param postgresSubnetName string = 'postgres-subnet'

@description('The address prefix for the PostgreSQL subnet.')
param postgresSubnetAddressPrefix string = '10.0.2.0/24'


resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: '${webAppName}-plan'
  location: location
  sku: {
    name: appServicePlanSku
  }
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  location: location
  kind: 'app,linux,docker'
  properties: {
    serverFarmId: appServicePlan.id 
    // AutoGeneratedDomainNameLabelScope: 'TenantReuse'
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://index.docker.io'
        }
        {
          name: 'POSTGRES_HOST'
          value: '${postgres.name}.postgres.database.azure.com'
        }
        {
          name: 'POSTGRES_DB'
          value: databaseName
        }
        {
          name: 'POSTGRES_USER'
          value: '${postgresAdminUsername}@${postgres.name}'
        }
        {
          name: 'POSTGRES_PASSWORD'
          value: postgresAdminPassword
        }
        {
          name: 'WEBSITES_PORT'
          value: '8080'
        }
        {
          name: 'DATAMESHMANAGER_HOST'
          value: '\${WEBSITE_HOSTNAME}'
        }
        {
          name: 'SPRING_DATASOURCE_URL'
          value: 'jdbc:postgresql://${postgres.name}.postgres.database.azure.com:5432/${databaseName}'
        }
        {
          name: 'SPRING_DATASOURCE_USERNAME'
          value: postgresAdminUsername
        }
        {
          name: 'SPRING_DATASOURCE_PASSWORD'
          value: postgresAdminPassword
        }
        {
          name: 'SPRING_MAIL_HOST'
          value: smtpHost
        }
        {
          name: 'SPRING_MAIL_PORT'
          value: smtpPort
        }
        {
          name: 'SPRING_MAIL_USERNAME'
          value: smtpUsername
        }
        {
          name: 'SPRING_MAIL_PASSWORD'
          value: smtpPassword
        }
        {
          name: 'SPRING_MAIL_PROPERTIES_MAIL_SMTP_AUTH'
          value: '${smtpBasicAuth}'
        }
        {
          name: 'SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_ENABLE'
          value: '${smtpStarttls}'
        }
      ]
      linuxFxVersion: 'DOCKER|index.docker.io/${containerImageUrl}'
      alwaysOn: true
      vnetRouteAllEnabled: true
      ftpsState: 'FtpsOnly'
      appCommandLine: ''
    }
    virtualNetworkSubnetId: '${vnet.id}/subnets/${webappSubnetName}'
    httpsOnly: true
  }
}

resource postgres 'Microsoft.DBforPostgreSQL/flexibleServers@2023-12-01-preview' = {
  name: postgresServerName
  location: location
  sku: {
    name: postgresComputeTierSizeSku
    tier: 'GeneralPurpose'
  }
  properties: {
    version: '14'
    replica: {
      role: 'Primary'
    }
    storage: {
      iops: 500
      tier: 'P10'
      storageSizeGB: postgresStorageSizeGB
      autoGrow: 'Enabled'
    }
    network: {
      publicNetworkAccess: 'Disabled'
      delegatedSubnetResourceId: '${vnet.id}/subnets/${postgresSubnetName}'
      privateDnsZoneArmResourceId: privateDnsZones_privatelink_postgres.id
    }
    dataEncryption: {
      type: 'SystemManaged'
    }
    authConfig: {
      activeDirectoryAuth: 'Disabled'
      passwordAuth: 'Enabled'
    }
    administratorLogin: postgresAdminUsername
    administratorLoginPassword: postgresAdminPassword
    availabilityZone: '3'
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    highAvailability: {
      mode: 'Disabled'
    }
    maintenanceWindow: {
      customWindow: 'Disabled'
      dayOfWeek: 0
      startHour: 0
      startMinute: 0
    }
    replicationRole: 'Primary'
  }
}


resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: webappSubnetName
        properties: {
          addressPrefix: webappSubnetAddressPrefix
          delegations: [
            {
              name: 'dlg-appServices'
              properties: {
                serviceName: 'Microsoft.Web/serverfarms'
              }
            }
          ]
        }
      }
      {
        name: postgresSubnetName
        properties: {
          addressPrefix: postgresSubnetAddressPrefix
          delegations: [
            {
              name: 'dlg-postgres'
              properties: {
                serviceName: 'Microsoft.DBforPostgreSQL/flexibleServers'
              }
            }
          ]
        }        
      }
    ]
  }
}
resource webAppVnetIntegration 'Microsoft.Web/sites/virtualNetworkConnections@2023-12-01' = {
  name: '${webAppName}vnet'
  properties: {
    vnetResourceId: '${vnet.id}/subnets/${webappSubnetName}'
    isSwift: true
  }
  parent: webApp
}

resource privateDnsZones_privatelink_postgres 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.postgres.database.azure.com'
  location: 'global'
  properties: {}
}

resource privateDnsZones_privatelink_postgres_dblink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZones_privatelink_postgres
  name: '${privateDnsZones_privatelink_postgres.name}-dblink'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}




// // Email Communication Service
// resource emailService 'Microsoft.Communication/emailServices@2023-03-31' = {
//   name: 'datameshmanager-es'
//   location: 'global'
//   properties: {
//     dataLocation: 'Europe'
//   }
// }

// // Email Communication Services Domain (Azure Managed)
// resource emailServiceAzureDomain 'Microsoft.Communication/emailServices/domains@2023-03-31' = {
//   parent: emailService
//   name: 'AzureManagedDomain'
//   location: 'global'
//   properties: {
//     domainManagement: 'AzureManaged'
//     userEngagementTracking: 'Disabled'
//   }
// }

// // SenderUsername (Azure Managed Domain)
// resource senderUserNameAzureDomain 'Microsoft.Communication/emailServices/domains/senderUsernames@2023-03-31' = {
//   parent: emailServiceAzureDomain
//   name: 'donotreply'
//   properties: {
//     username: 'DoNotReply'
//     displayName: 'DoNotReply'
//   }
// }

// // Communication Service
// resource communcationService 'Microsoft.Communication/communicationServices@2023-03-31' = {
//   name: 'datameshmanager-cs'
//   location: 'global'
//   properties: {
//     dataLocation: 'Europe'
//     linkedDomains: [
//       emailServiceAzureDomain.id
//     ]
//   }
// }

// @description('A role to send emails')
// resource symbolicname 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' = {
//   name: 'ACS Email Write'
//   properties: {
//     assignableScopes: [
//       communcationService.id
//     ]
//     permissions: [
//       {
//         actions: [
//           'Microsoft.Communication/CommunicationServices/Read'
//           'Microsoft.Communication/EmailServices/write'
//         ]
//         dataActions: [
//           'string'
//         ]
//         notActions: [
//           'string'
//         ]
//         notDataActions: [
//           'string'
//         ]
//       }
//     ]
//     roleName: 'string'
//     type: 'string'
//   }
// }



output webAppUrl string = webApp.properties.defaultHostName