# Port Allocation for Fair Harvest

## Overview
This document outlines the port configuration for the Fair Harvest Docker setup to avoid conflicts with other services.

## Port Configuration

### Development Environment
- **Web Server (Nginx)**: `3001` → `80` (container internal)
  - External: http://localhost:3001
  - Internal: Container port 80

### Production Environment
- **Web Server (Nginx)**: `3010` → `80` (container internal)
  - External: http://localhost:3010
  - Internal: Container port 80
  - VPS Nginx Proxy: Configure to proxy to `localhost:3010`

## Configuration Files

### .env File
```bash
# Development
WEB_PORT=3001

# Production
WEB_PORT=3010
```

### Docker Network
- Network Name: `fairharvest-network-{dev|prod}`
- Container Name: `fairharvest-{dev|prod}`

## Port Conflict Resolution

If you encounter port conflicts:

1. **Check what's using the port:**
   ```bash
   lsof -i :3001  # For development
   lsof -i :3010  # For production
   ```

2. **Options to resolve:**
   - Stop the conflicting service
   - Change the port in `.env` file
   - Use a different port range

## VPS Deployment

For deployment on Ubuntu VPS with Nginx:

1. Docker container runs on port `3010`
2. Configure Nginx to proxy requests:
   ```nginx
   location / {
       proxy_pass http://localhost:3010;
       proxy_set_header Host $host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header X-Forwarded-Proto $scheme;
   }
   ```

## Quick Commands

```bash
# Start development
./docker-start.sh dev

# Start production
./docker-start.sh prod

# Check status
./docker-start.sh status

# Stop containers
./docker-start.sh stop

# Clean everything
./docker-start.sh clean
```