# Deployment with Helm

## Installation

Create required secrets via bash or any secrets-management mechanism you prefer.

```bash
kubectl create secret generic datamesh-manager-database \
  --from-literal=username=<database-username> \
  --from-literal=password=<database-password>

kubectl create secret generic datamesh-manager-smtp \
  --from-literal=username=<smtp-username> \
  --from-literal=password=<smtp-password>
```

```bash
helm install -n datamesh-manager --create-namespace datamesh-manager .
```

## Upgrade

```bash
helm upgrade -n datamesh-manager datamesh-manager .
```

## Uninstallation

```bash
helm uninstall -n datamesh-manager datamesh-manager
```

## Todos
- Add Health Check paths
- Add realistic ressource limits and requests
