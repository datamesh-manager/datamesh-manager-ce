# Data Mesh Manager (Community Edition)

The [Data Mesh Manager](https://www.datamesh-manager.com) (Community Edition) is a free version of the Data Mesh Manager that you can host yourself.

## Getting Started

Start the Data Mesh Manager (Community Edition) locally with Docker Compose.

```bash
git clone https://github.com/datamesh-manager/datamesh-manager-ce.git
cd datamesh-manager-ce
docker compose up --detach
```

Now you can access the Data Mesh Manager (Community Edition) at [http://localhost:8081](http://localhost:8081).

## Configuration

The Data Mesh Manager (community edition) uses a Postgres database and a dummy mail server (no mails are actually sent).

Configure an external database and mail server for production use.

| Environment Variable       | Example                                  | Description                                                                                                                                                            |
| -------------------------- | ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| SPRING_DATASOURCE_URL      | jdbc:postgresql://postgres:5432/postgres | JDBC URL of the database                                                                                                                                              |
| SPRING_DATASOURCE_USERNAME | postgres                                 | Login username of the database                                                                                                                                        |
| SPRING_DATASOURCE_PASSWORD | postgres                                 | Login password of the database                                                                                                                                |
| SPRING_MAIL_HOST           | smtp.example.com                         | SMTP server host                                                                                                                                                       |
| SPRING_MAIL_PORT           | 587                                      | SMTP server port.                                                                                                                                                     |
| SPRING_MAIL_USERNAME       |                                          | Login user of the SMTP server |
| SPRING_MAIL_PASSWORD       |                                          | Login password of the SMTP server                                                                                                                             |

## Reporting bugs and feature requests

Want to report a bug or request a feature? Open an [issue](https://github.com/datamesh-manager/datamesh-manager-ce/issues/new).

## License

TBD
