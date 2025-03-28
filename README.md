# Typebot Podman Deployment

This repository contains configuration and scripts to deploy Typebot using Podman. Typebot is an open-source conversational form builder that allows you to create chatbots and interactive forms.

## Overview

This setup includes:
- PostgreSQL database for data storage
- Redis for caching
- Typebot Builder UI (administrative interface)
- Typebot Viewer (user-facing interface)

## Prerequisites

- Podman installed on your system
- Bash shell
- Git (for cloning this repository)

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/haupt-pascal/typebot-podman.git
   cd typebot-podman
   ```

2. Copy the example environment file and configure it:
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

3. Make the scripts executable:
   ```bash
   chmod +x start.sh stop.sh
   ```

4. Run the start script:
   ```bash
   ./start.sh
   ```

5. Access Typebot:
   - Builder UI: http://localhost:8080
   - Viewer: http://localhost:8081

6. To stop the services:
   ```bash
   ./stop.sh
   ```

## Configuration

Configure your Typebot instance by editing the `.env` file:

### Required Settings

- `ENCRYPTION_SECRET`: Secret key for encryption (generate with `openssl rand -base64 24 | tr -d '\n' ; echo`)
- `DATABASE_URL`: PostgreSQL connection string (will be set automatically by the script)
- `NEXTAUTH_URL`: URL of the builder interface
- `NEXT_PUBLIC_VIEWER_URL`: URL of the viewer interface

### Email Settings

- `SMTP_USERNAME`: SMTP username for sending emails
- `SMTP_PASSWORD`: SMTP password
- `SMTP_HOST`: SMTP server hostname
- `SMTP_PORT`: SMTP server port
- `SMTP_SECURE`: Use TLS (true/false)
- `ADMIN_EMAIL`: Administrator email address

### Resource Limits

You can modify the start script to include resource limits:

```bash
# Example: Add memory limits to the podman run commands
-m 512m --memory-reservation 256m
```

## Understanding the Scripts

### start.sh

This script:
1. Stops and removes any existing Typebot containers
2. Creates a dedicated network for the Typebot containers
3. Starts the PostgreSQL database container
4. Starts the Redis cache container
5. Waits for the database and Redis to initialize
6. Starts the Typebot Builder container
7. Starts the Typebot Viewer container

### stop.sh

This script stops all running Typebot containers in the correct order.

## Data Persistence

Data is stored in the following volumes:
- PostgreSQL data: `db-data` volume
- Redis data: `redis-data` volume and `./volumes/redis-data` directory

## Maintenance

### Updating

To update Typebot to the latest version:

1. Stop the running services:
   ```bash
   ./stop.sh
   ```

2. Pull the latest images:
   ```bash
   podman pull baptistearno/typebot-builder:latest
   podman pull baptistearno/typebot-viewer:latest
   ```

3. Start the services again:
   ```bash
   ./start.sh
   ```

### Backup and Restore

To backup your PostgreSQL database:

```bash
podman exec typebot-db pg_dump -U postgres typebot > typebot_backup.sql
```

To restore:

```bash
podman exec -i typebot-db psql -U postgres typebot < typebot_backup.sql
```

## Troubleshooting

### Common Issues

1. **Port conflicts**: If ports 8080, 8081, 5432, or 6379 are already in use, modify the port mappings in the start script.

2. **Network connectivity issues**: Ensure containers can communicate with each other:
   ```bash
   podman network inspect typebot-network
   ```

3. **Database connection issues**: Verify the PostgreSQL container is running:
   ```bash
   podman logs typebot-db
   ```

### Advanced: Manual Container Management

If you need to manage containers individually:

```bash
# Start/stop individual containers
podman start typebot-db
podman stop typebot-viewer

# View logs
podman logs typebot-builder
podman logs -f typebot-viewer  # Follow logs

# Access a container shell
podman exec -it typebot-db bash
```

## Collaboration Guide

### Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -am 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Submit a pull request

### Creating Issues

When reporting issues, please include:

1. **Clear Title**: Brief description of the issue
2. **Environment Details**:
   - Operating system
   - Podman version
   - Typebot version
3. **Steps to Reproduce**: Detailed steps to reproduce the issue
4. **Expected Behavior**: What you expected to happen
5. **Actual Behavior**: What actually happened
6. **Screenshots/Logs**: If applicable, include relevant screenshots or logs
7. **Additional Context**: Any other relevant information

## License

This project is licensed under proprietary terms.

## Acknowledgements

- Typebot: [GitHub Repository](https://github.com/baptisteArno/typebot.io)
- Author: Pascal Haupt