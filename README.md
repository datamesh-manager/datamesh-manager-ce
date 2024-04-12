# Data Mesh Manager (Community Edition)

Data Mesh Manager (Community Edition) is a free version of the [Data Mesh Manager](https://www.datamesh-manager.com) that you can host yourself.

In the Community Edition, every user can change any data product or data contract.  
If you need advanced role and permission management, SSO, or customizations, consider the [Enterprise Edition](https://www.datamesh-manager.com/#pricing).

## Demo

Play with our [demo app](https://demo.datamesh-manager.com/)!


## Getting Started

Data Mesh Manager (Community Edition) is available as container image `datameshmanager/datamesh-manager-ce` on [Docker Hub](https://hub.docker.com/r/datameshmanager/datamesh-manager-ce).

Start Data Mesh Manager (Community Edition) locally with Docker Compose:

```bash
git clone https://github.com/datamesh-manager/datamesh-manager-ce.git
cd datamesh-manager-ce
docker compose up --detach
```

Now you can access the Data Mesh Manager (Community Edition) at [http://localhost:8081](http://localhost:8081).

> **_NOTE:_**  The Docker Compose configuration uses a dummy mail server, so no mails are actually sent. Configure our SMTP host accordingly as environment variables.

## Configuration

Configure an external database and mail server for production use.

| Environment Variable       | Example                                  | Description                                                                                                                                                            |
| -------------------------- | ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DATAMESHMANAGER_HOST      | `http://localhost:8081` | The host of the application, used e.g., in email templates build URLs to Data Mesh Manager.                                                                                                                                              |
| SPRING_DATASOURCE_URL      | `jdbc:postgresql://postgres:5432/postgres` | JDBC URL of the database                                                                                                                                              |
| SPRING_DATASOURCE_USERNAME | `postgres`                                 | Login username of the database                                                                                                                                        |
| SPRING_DATASOURCE_PASSWORD | `postgres`                                 | Login password of the database                                                                                                                                |
| SPRING_MAIL_HOST           | `smtp.example.com`                         | SMTP server host                                                                                                                                                       |
| SPRING_MAIL_PORT           | `587`                                      | SMTP server port                                                                                                                                                     |
| SPRING_MAIL_USERNAME       |                                          | Login user of the SMTP server |
| SPRING_MAIL_PASSWORD       |                                          | Login password of the SMTP server                                                                                                                             |

## Deployment

You may want to use the provided [helm chart](./helm) for Kubernetes Deployments.

## Reporting bugs and feature requests

Want to report a bug or request a feature? Open an [issue](https://github.com/datamesh-manager/datamesh-manager-ce/issues/new).

## License

The Data Mesh Manager (Community Edition), being made available as a Docker image, is licensed under the [Community License](https://www.datamesh-manager.com/COMMUNITY-LICENSE.txt).
