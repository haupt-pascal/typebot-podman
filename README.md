# Typebot Podman Deployment

This repository contains configuration and scripts to deploy Typebot using Podman or Docker Compose. Typebot is an open-source conversational form builder that allows you to create chatbots and interactive forms.

## Overview

This setup includes:
- PostgreSQL database for data storage
- Redis for caching
- Typebot Builder UI (administrative interface)
- Typebot Viewer (user-facing interface)

## Prerequisites

- Podman (preferred) or Docker with Docker Compose
- Bash shell
- Git (for cloning this repository)

## Quick Start

### Using Podman

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

3. Run the start script:
   ```bash
   chmod +x start.sh
   ./start.sh
   ```

4. Access Typebot:
   - Builder UI: http://localhost:8080
   - Viewer: http://localhost:8081

5. To stop the services:
   ```bash
   ./stop.sh
   ```

### Using Docker Compose

1. Clone this repository and configure the environment:
   ```bash
   git clone https://github.com/yourusername/typebot-podman.git
   cd typebot-podman
   cp .env.example .env
   # Edit .env with your settings
   ```

2. Start the services:
   ```bash
   docker-compose up -d
   ```

3. Access Typebot:
   - Builder UI: http://localhost:8080
   - Viewer: http://localhost:8081

4. To stop the services:
   ```bash
   docker-compose down
   ```

## Configuration

Configure your Typebot instance by editing the `.env` file:

### Required Settings

- `ENCRYPTION_SECRET`: Secret key for encryption (generate with `openssl rand -base64 24 | tr -d '\n' ; echo`)
- `DATABASE_URL`: PostgreSQL connection string
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

- `PODMAN_MEMORY_RESERVATION`: Memory reservation for containers
- `PODMAN_MEMORY_LIMIT`: Memory limit for containers

## Data Persistence

Data is stored in the following volumes:
- PostgreSQL data: `./volumes/db-data`
- Redis data: `./volumes/redis-data`

## Maintenance

### Updating

To update Typebot to the latest version:

1. Stop the running services:
   ```bash
   ./stop.sh
   ```
   or
   ```bash
   docker-compose down
   ```

2. Pull the latest images:
   ```bash
   podman pull baptistearno/typebot-builder:latest
   podman pull baptistearno/typebot-viewer:latest
   ```
   or
   ```bash
   docker-compose pull
   ```

3. Start the services again:
   ```bash
   ./start.sh
   ```
   or
   ```bash
   docker-compose up -d
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

## Collaboration Guide

### Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -am 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Submit a pull request

### Code Style

- Use descriptive variable names
- Add comments for complex logic
- Maintain consistent indentation
- Follow existing patterns in the codebase

### Development Workflow

1. Create an issue describing the feature or bug
2. Discuss the implementation approach if needed
3. Implement the changes
4. Test thoroughly
5. Submit a pull request referencing the issue

## Creating Issues

When reporting issues, please include:

1. **Clear Title**: Brief description of the issue
2. **Environment Details**:
   - Operating system
   - Podman/Docker version
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
