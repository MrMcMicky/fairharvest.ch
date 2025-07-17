#!/bin/bash

# Fair Harvest Docker Management Script
# Usage: ./docker-start.sh [dev|prod|status|clean]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Load environment variables
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo -e "${RED}Error: .env file not found!${NC}"
    echo "Please copy .env.docker.example to .env and configure it."
    exit 1
fi

# Function to check if port is in use
check_port() {
    local port=$1
    if lsof -i :$port >/dev/null 2>&1; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Function to check all required ports
check_ports() {
    echo "Checking port availability..."
    
    local ports_to_check=("$WEB_PORT")
    local port_conflicts=()
    
    for port in "${ports_to_check[@]}"; do
        if check_port $port; then
            port_conflicts+=($port)
            echo -e "${RED}✗ Port $port is already in use${NC}"
        else
            echo -e "${GREEN}✓ Port $port is available${NC}"
        fi
    done
    
    if [ ${#port_conflicts[@]} -gt 0 ]; then
        echo -e "\n${RED}Port conflicts detected!${NC}"
        echo "Options to resolve:"
        echo "1. Stop the conflicting service(s)"
        echo "2. Change the port(s) in your .env file"
        echo -e "\nTo find what's using a port: ${YELLOW}lsof -i :<port>${NC}"
        return 1
    fi
    
    return 0
}

# Main command handling
case "$1" in
    dev)
        echo -e "${GREEN}Starting Fair Harvest in development mode...${NC}"
        
        # Check ports
        if ! check_ports; then
            exit 1
        fi
        
        # Set development environment
        export NODE_ENV=development
        export COMPOSE_PROJECT_NAME=dev
        
        # Build and start
        docker-compose build
        docker-compose up -d
        
        echo -e "\n${GREEN}✓ Fair Harvest is running!${NC}"
        echo -e "Access the site at: ${YELLOW}http://localhost:${WEB_PORT}${NC}"
        ;;
        
    prod)
        echo -e "${GREEN}Starting Fair Harvest in production mode...${NC}"
        
        # Check ports
        if ! check_ports; then
            exit 1
        fi
        
        # Set production environment
        export NODE_ENV=production
        export COMPOSE_PROJECT_NAME=prod
        
        # Build and start
        docker-compose build --no-cache
        docker-compose up -d
        
        echo -e "\n${GREEN}✓ Fair Harvest is running in production mode!${NC}"
        echo -e "Access the site at: ${YELLOW}http://localhost:${WEB_PORT}${NC}"
        ;;
        
    status)
        echo -e "${GREEN}Fair Harvest Docker Status:${NC}"
        docker-compose ps
        echo -e "\n${GREEN}Port Usage:${NC}"
        echo "Web Port: ${WEB_PORT:-3001}"
        ;;
        
    stop)
        echo -e "${YELLOW}Stopping Fair Harvest...${NC}"
        docker-compose down
        echo -e "${GREEN}✓ Stopped${NC}"
        ;;
        
    clean)
        echo -e "${YELLOW}Cleaning up Fair Harvest Docker resources...${NC}"
        docker-compose down -v --remove-orphans
        docker rmi fairharvest:latest 2>/dev/null || true
        echo -e "${GREEN}✓ Cleaned up${NC}"
        ;;
        
    *)
        echo "Fair Harvest Docker Management"
        echo "Usage: $0 {dev|prod|status|stop|clean}"
        echo ""
        echo "Commands:"
        echo "  dev    - Start in development mode (port ${WEB_PORT:-3001})"
        echo "  prod   - Start in production mode"
        echo "  status - Show container status"
        echo "  stop   - Stop containers"
        echo "  clean  - Stop and remove all containers, volumes, and images"
        exit 1
        ;;
esac