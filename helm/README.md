# Deployment with Helm

## Installation

```
helm install -n datamesh-manager --create-namespace datamesh-manager .
```

## Upgrade

```
helm upgrade -n datamesh-manager datamesh-manager .
```

## Uninstallation

```
helm uninstall -n datamesh-manager datamesh-manager
```

# Todos:
- Add Health Checks
- Add Security
- Flexible configuration via values.yaml