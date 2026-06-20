# Docker Setup Guide - FAF Hackathon Challenge

## Overview

This project has been fully dockerized with the following services:

| Service | Language | Port | Type |
|---------|----------|------|------|
| **frontend** | TypeScript/React | 5173 | Web UI |
| **gateway** | Go | 8080 | API Gateway |
| **airport** | Python/Flask | 5000 | Microservice |
| **beach** | Java/Ktor | 8081 | Microservice |
| **broadcast** | TypeScript/Node | 3001 | Event Service |
| **hotel** | NestJS | 3000 | Main Service |
| **parrot** | Python/FastAPI | 8000 | AI Service |
| **postgres** | PostgreSQL | 5432 | Database |

## Prerequisites

- Docker 20.10+
- Docker Compose 2.0+

## Quick Start

### 1. Build all images

```bash
chmod +x docker-build.sh
./docker-build.sh
```

Or manually:

```bash
docker-compose build
```

### 2. Start all services

```bash
docker-compose up -d
```

### 3. View logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f hotel
```

### 4. Check service status

```bash
docker-compose ps
```

### 5. Stop all services

```bash
docker-compose down
```

## Service Access

Once all services are running:

- **Frontend**: http://localhost:5173
- **Gateway**: http://localhost:8080
- **Airport**: http://localhost:5000
- **Beach**: http://localhost:8081
- **Broadcast**: http://localhost:3001
- **Hotel**: http://localhost:3000
- **Parrot**: http://localhost:8000/docs (API docs)
- **PostgreSQL**: localhost:5432

## Environment Configuration

1. Copy `.env.example` to `.env`:

```bash
cp .env.example .env
```

2. Update `.env` with your configuration:

```bash
# Set your OpenAI API key
OPENAI_API_KEY=sk-...
```

3. Restart services:

```bash
docker-compose restart
```

## Individual Service Management

### Build specific service

```bash
docker-compose build hotel
```

### Start specific service

```bash
docker-compose up -d broadcast
```

### Rebuild and restart service

```bash
docker-compose up -d --build airport
```

### View service logs

```bash
docker-compose logs -f parrot
```

### Stop specific service

```bash
docker-compose stop beach
```

## Database Management

### Connect to PostgreSQL

```bash
docker-compose exec postgres psql -U user -d hotel_db
```

### Run migrations (Hotel service)

```bash
docker-compose exec hotel pnpm run db:migrate
```

### Seed database

```bash
docker-compose exec hotel pnpm run db:seed
```

### Reset database

```bash
docker-compose exec hotel pnpm run db:reset
```

## Debugging

### View container logs with timestamps

```bash
docker-compose logs -f --timestamps
```

### Execute command in running container

```bash
docker-compose exec service_name sh
# or
docker-compose exec service_name bash
```

### Example: Check hotel service

```bash
docker-compose exec hotel sh
ps aux  # view running processes
npm list  # view installed packages
```

### Rebuild without cache

```bash
docker-compose build --no-cache
```

## Performance Optimization

### Clean up unused resources

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune

# Clean everything
docker system prune -a
```

### Reduce image sizes

- Frontend builds are optimized with multi-stage builds
- Python services use alpine/slim images
- Go gateway uses alpine image
- Node services use alpine images

## Troubleshooting

### Port already in use

If a port is already in use, change the port mapping in `docker-compose.yml`:

```yaml
ports:
  - "8080:8080"  # Change first 8080 to another port like 8081:8080
```

### Service fails to start

Check logs:

```bash
docker-compose logs service_name
```

### Database connection issues

Ensure PostgreSQL is running:

```bash
docker-compose ps postgres
```

If not running:

```bash
docker-compose up -d postgres
```

### Memory issues

Increase Docker memory limit in Docker Desktop settings or add memory limits to services:

```yaml
services:
  hotel:
    mem_limit: 1g
    memswap_limit: 2g
```

### Clean restart

```bash
# Stop all services
docker-compose down

# Remove volumes (will delete database)
docker-compose down -v

# Rebuild and start
docker-compose up -d --build
```

## Production Considerations

For production deployment:

1. **Use environment-specific compose files:**
   - Create `docker-compose.prod.yml`
   - Override settings like image registries, resource limits, etc.

2. **Use a container registry:**
   - Push images to Docker Hub, AWS ECR, or similar
   - Update compose file to pull from registry

3. **Add reverse proxy (Nginx/Traefik):**
   - Handle HTTPS/TLS
   - Load balancing
   - Rate limiting

4. **Security:**
   - Don't commit `.env` files with secrets
   - Use Docker secrets or external secret management
   - Run containers as non-root users
   - Keep base images updated

5. **Monitoring & Logging:**
   - Use ELK stack, Prometheus, or similar
   - Configure log rotation
   - Set up health checks (already configured)

6. **Database backups:**
   - Automate PostgreSQL backups
   - Test restore procedures

## Network Isolation

All services communicate through the `faf-network` bridge network. They can reference each other by service name:

- `hotel` can connect to `postgres:5432`
- `gateway` can connect to `hotel:3000`
- `frontend` connects to `gateway:8080` (exposed to host)

## File Structure

```
project/
├── docker-compose.yml          # Main orchestration file
├── .dockerignore                # Global ignore file
├── docker-build.sh              # Build helper script
├── .env.example                 # Example environment variables
├── frontend/
│   ├── Dockerfile
│   └── .dockerignore
├── gateway/
│   ├── Dockerfile
│   └── .dockerignore
└── services/
    ├── airport/
    │   ├── Dockerfile
    │   └── .dockerignore
    ├── beach/
    │   ├── Dockerfile
    │   └── .dockerignore
    ├── broadcast/
    │   ├── Dockerfile
    │   └── .dockerignore
    ├── hotel/
    │   ├── Dockerfile
    │   └── .dockerignore
    └── parrot/
        ├── Dockerfile
        └── .dockerignore
```

## Support

For issues or questions, check individual service README files:

- [Frontend](frontend/README.md)
- [Gateway](gateway/README.md)
- [Airport](services/airport/README.md)
- [Beach](services/beach/README.md)
- [Broadcast](services/broadcast/README.md)
- [Hotel](services/hotel/README.md)
- [Parrot](services/parrot/README.md)
