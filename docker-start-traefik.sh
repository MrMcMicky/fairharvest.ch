#!/bin/bash

# Fair Harvest with Traefik - Beautiful Local Domains
# Usage: ./docker-start-traefik.sh [start|stop|status|clean]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to update hosts file
update_hosts_file() {
    local action=$1
    local domains=("fairharvest.local" "traefik.local")
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        HOSTS_FILE="/etc/hosts"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        HOSTS_FILE="/c/Windows/System32/drivers/etc/hosts"
    else
        HOSTS_FILE="/etc/hosts"
    fi
    
    if [ "$action" == "add" ]; then
        echo -e "${BLUE}Adding domains to hosts file...${NC}"
        for domain in "${domains[@]}"; do
            if ! grep -q "$domain" "$HOSTS_FILE" 2>/dev/null; then
                echo "127.0.0.1 $domain" | sudo tee -a "$HOSTS_FILE" > /dev/null
                echo -e "${GREEN}✓ Added $domain to hosts file${NC}"
            else
                echo -e "${YELLOW}• $domain already exists in hosts file${NC}"
            fi
        done
    elif [ "$action" == "remove" ]; then
        echo -e "${BLUE}Removing domains from hosts file...${NC}"
        for domain in "${domains[@]}"; do
            if grep -q "$domain" "$HOSTS_FILE" 2>/dev/null; then
                sudo sed -i "/$domain/d" "$HOSTS_FILE"
                echo -e "${GREEN}✓ Removed $domain from hosts file${NC}"
            fi
        done
    fi
}

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
        echo -e "${GREEN}🚀 Starting Fair Harvest with Traefik...${NC}"
        
        # Check port 80
        if ! check_port_80; then
            exit 1
        fi
        
        # Update hosts file
        update_hosts_file add
        
        # Start services
        docker-compose -f docker-compose.traefik.yml up -d
        
        echo -e "\n${GREEN}✅ Fair Harvest is running with beautiful domains!${NC}"
        echo -e "${BLUE}┌─────────────────────────────────────────────┐${NC}"
        echo -e "${BLUE}│                 🌐 ACCESS URLS               │${NC}"
        echo -e "${BLUE}├─────────────────────────────────────────────┤${NC}"
        echo -e "${BLUE}│ Fair Harvest: ${YELLOW}http://fairharvest.local${BLUE}     │${NC}"
        echo -e "${BLUE}│ Traefik:      ${YELLOW}http://traefik.local:8080${BLUE}    │${NC}"
        echo -e "${BLUE}└─────────────────────────────────────────────┘${NC}"
        echo -e "\n${GREEN}Note: If domains don't work, wait 30 seconds for DNS propagation${NC}"
        ;;
        
    stop)
        echo -e "${YELLOW}🛑 Stopping Fair Harvest with Traefik...${NC}"
        docker-compose -f docker-compose.traefik.yml down
        echo -e "${GREEN}✓ Stopped${NC}"
        ;;
        
    status)
        echo -e "${GREEN}📊 Fair Harvest + Traefik Status:${NC}"
        docker-compose -f docker-compose.traefik.yml ps
        echo -e "\n${GREEN}🌐 Access URLs:${NC}"
        echo -e "Fair Harvest: ${YELLOW}http://fairharvest.local${NC}"
        echo -e "Traefik Dashboard: ${YELLOW}http://traefik.local:8080${NC}"
        ;;
        
    clean)
        echo -e "${YELLOW}🧹 Cleaning up Fair Harvest + Traefik...${NC}"
        docker-compose -f docker-compose.traefik.yml down -v --remove-orphans
        docker rmi fairharvest:latest traefik:v3.0 2>/dev/null || true
        
        # Remove from hosts file
        update_hosts_file remove
        
        echo -e "${GREEN}✓ Cleaned up${NC}"
        ;;
        
    *)
        echo -e "${BLUE}Fair Harvest with Traefik - Beautiful Local Domains${NC}"
        echo ""
        echo "Usage: $0 {start|stop|status|clean}"
        echo ""
        echo "Commands:"
        echo "  start  - Start with domains (fairharvest.local, traefik.local)"
        echo "  stop   - Stop all services"
        echo "  status - Show service status and URLs"
        echo "  clean  - Remove everything including hosts entries"
        echo ""
        echo -e "${GREEN}Access URLs after start:${NC}"
        echo -e "• Fair Harvest: ${YELLOW}http://fairharvest.local${NC}"
        echo -e "• Traefik Dashboard: ${YELLOW}http://traefik.local:8080${NC}"
        exit 1
        ;;
esac