#!/bin/bash

# Fair Harvest with Nginx Proxy - Clean URLs
# Usage: ./docker-start-nginx.sh [start|stop|status|clean]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to check if port 80 is available
check_port_80() {
    if lsof -i :80 >/dev/null 2>&1; then
        echo -e "${RED}Error: Port 80 is already in use!${NC}"
        echo "Please stop the service using port 80 first."
        echo "Find what's using it: lsof -i :80"
        return 1
    fi
    return 0
}

case "$1" in
    start)
        echo -e "${GREEN}🚀 Starting Fair Harvest with Nginx Proxy...${NC}"
        
        # Check port 80
        if ! check_port_80; then
            exit 1
        fi
        
        # Start services
        docker-compose -f docker-compose.nginx.yml up -d
        
        echo -e "\n${GREEN}✅ Fair Harvest is running with clean URLs!${NC}"
        echo -e "${BLUE}┌─────────────────────────────────────────────┐${NC}"
        echo -e "${BLUE}│                 🌐 ACCESS URLS               │${NC}"
        echo -e "${BLUE}├─────────────────────────────────────────────┤${NC}"
        echo -e "${BLUE}│ Fair Harvest: ${YELLOW}http://localhost/fairharvest/${BLUE} │${NC}"
        echo -e "${BLUE}│ Status Page:  ${YELLOW}http://localhost/status${BLUE}       │${NC}"
        echo -e "${BLUE}│ Auto Redirect: ${YELLOW}http://localhost${BLUE}            │${NC}"
        echo -e "${BLUE}└─────────────────────────────────────────────┘${NC}"
        ;;
        
    stop)
        echo -e "${YELLOW}🛑 Stopping Fair Harvest with Nginx Proxy...${NC}"
        docker-compose -f docker-compose.nginx.yml down
        echo -e "${GREEN}✓ Stopped${NC}"
        ;;
        
    status)
        echo -e "${GREEN}📊 Fair Harvest + Nginx Proxy Status:${NC}"
        docker-compose -f docker-compose.nginx.yml ps
        echo -e "\n${GREEN}🌐 Access URLs:${NC}"
        echo -e "Fair Harvest: ${YELLOW}http://localhost/fairharvest/${NC}"
        echo -e "Status Page: ${YELLOW}http://localhost/status${NC}"
        echo -e "Auto Redirect: ${YELLOW}http://localhost${NC}"
        ;;
        
    clean)
        echo -e "${YELLOW}🧹 Cleaning up Fair Harvest + Nginx Proxy...${NC}"
        docker-compose -f docker-compose.nginx.yml down -v --remove-orphans
        docker rmi fairharvest:latest nginx:alpine 2>/dev/null || true
        echo -e "${GREEN}✓ Cleaned up${NC}"
        ;;
        
    *)
        echo -e "${BLUE}Fair Harvest with Nginx Proxy - Clean URLs${NC}"
        echo ""
        echo "Usage: $0 {start|stop|status|clean}"
        echo ""
        echo "Commands:"
        echo "  start  - Start with clean URLs (localhost/fairharvest/)"
        echo "  stop   - Stop all services"
        echo "  status - Show service status and URLs"
        echo "  clean  - Remove everything"
        echo ""
        echo -e "${GREEN}Access URLs after start:${NC}"
        echo -e "• Fair Harvest: ${YELLOW}http://localhost/fairharvest/${NC}"
        echo -e "• Status Page: ${YELLOW}http://localhost/status${NC}"
        echo -e "• Auto Redirect: ${YELLOW}http://localhost${NC} → /fairharvest/"
        exit 1
        ;;
esac