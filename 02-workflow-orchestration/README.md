# Workflow Orchestration with Kestra

This folder contains materials for learning workflow orchestration using Kestra.

## What is Kestra?

Kestra is an open-source, event-driven workflow orchestration platform that allows you to build, schedule, and monitor data pipelines and workflows using declarative YAML files.

## Prerequisites

- Docker and Docker Compose installed on your system
- At least 4GB of available RAM
- Internet connection for pulling Docker images

## Launching Kestra

### Method 1: Using Docker Compose (Recommended)

1. **Create a `docker-compose.yml` file** (if not already present):

```yaml
version: "3.8"

services:
  kestra:
    image: kestra/kestra:latest
    container_name: kestra
    ports:
      - "8080:8080"
      - "8081:8081"
    environment:
      KESTRA_CONFIGURATION: |
        datasources:
          postgres:
            url: jdbc:postgresql://postgres:5432/kestra
            driverClassName: org.postgresql.Driver
            username: kestra
            password: k3str4
        kestra:
          server:
            basic-auth:
              enabled: false
          repository:
            type: postgres
          storage:
            type: local
            local:
              base-path: /app/storage
          queue:
            type: postgres
          tasks:
            tmp-dir:
              path: /tmp/kestra-wd/tmp
    volumes:
      - kestra-data:/app/storage
      - /var/run/docker.sock:/var/run/docker.sock
      - /tmp/kestra-wd:/tmp/kestra-wd
    depends_on:
      postgres:
        condition: service_healthy

  postgres:
    image: postgres:14
    container_name: kestra-postgres
    environment:
      POSTGRES_DB: kestra
      POSTGRES_USER: kestra
      POSTGRES_PASSWORD: k3str4
    volumes:
      - postgres-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U kestra"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  kestra-data:
  postgres-data:
```

2. **Start Kestra**:

```bash
docker-compose up -d
```

3. **Access Kestra UI**:

Open your browser and navigate to:
```
http://localhost:8080
```

4. **Stop Kestra**:

```bash
docker-compose down
```

5. **Stop and remove volumes** (this will delete all data):

```bash
docker-compose down -v
```

### Method 2: Using Docker Run (Quick Start)

For a quick test without persistence:

```bash
docker run --rm -it -p 8080:8080 kestra/kestra:latest server standalone
```

Access the UI at `http://localhost:8080`

## Verifying Installation

Once Kestra is running, you can verify the installation:

1. Open `http://localhost:8080` in your browser
2. You should see the Kestra dashboard
3. Navigate to **Flows** to create your first workflow
4. Check **Executions** to monitor running workflows

## Viewing Logs

To view Kestra logs:

```bash
docker-compose logs -f kestra
```

Or for Docker run:

```bash
docker logs -f kestra
```

## Creating Your First Flow

1. Go to **Flows** in the Kestra UI
2. Click **Create**
3. Paste this example flow:

   ```yaml
   id: hello-world
   namespace: dev

   tasks:
     - id: hello
       type: io.kestra.core.tasks.log.Log
       message: Hello, World!
   ```

4. Click **Save**
5. Click **Execute** to run the flow
6. Check the **Executions** page to see the results

## Common Commands

### Check running containers

```bash
docker-compose ps
```

### Restart Kestra

```bash
docker-compose restart kestra
```

### Update Kestra to latest version

```bash
docker-compose pull
docker-compose up -d
```

### Access Kestra container shell

```bash
docker exec -it kestra /bin/bash
```

## Troubleshooting

### Port Already in Use

If port 8080 is already in use, modify the `docker-compose.yml` to use a different port:

```yaml
ports:
  - "9090:8080"  # Maps container port 8080 to host port 9090
```

Then access Kestra at `http://localhost:9090`

### Container Won't Start

Check the logs:

```bash
docker-compose logs kestra
```

### Permission Issues (Linux/Mac)

Ensure Docker has proper permissions:

```bash
sudo chown -R $USER:$USER /tmp/kestra-wd
```

## Resources

- [Kestra Documentation](https://kestra.io/docs)
- [Kestra GitHub](https://github.com/kestra-io/kestra)
- [Kestra Community Slack](https://kestra.io/slack)
- [Example Flows](https://kestra.io/docs/tutorial)

## Next Steps

1. Explore the built-in flow templates
2. Create flows for data extraction and transformation
3. Set up triggers and schedules
4. Integrate with databases and APIs
5. Monitor and debug workflow executions
