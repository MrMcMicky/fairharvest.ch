# 🌐 Lokale Clean URLs für alle Projekte - Anleitung

## Übersicht

Diese Anleitung zeigt dir, wie du für **alle deine Projekte** lokale URLs wie `http://localhost/project-name/` erstellen kannst, anstatt Port-Nummern zu verwenden.

## 📋 Voraussetzungen

- Docker Desktop läuft
- Grundlegende Docker-Kenntnisse
- Port 80 muss frei sein (kein anderer Webserver)

## 🚀 Methode 1: Einzelprojekt mit eigenem Nginx (empfohlen)

### Schritt 1: Dateien erstellen

Für jedes Projekt diese Dateien kopieren und anpassen:

#### `docker-compose.nginx.yml`
```yaml
version: '3.8'

services:
  nginx-proxy:
    image: nginx:alpine
    container_name: nginx-proxy-PROJEKTNAME
    restart: unless-stopped
    ports:
      - "80:80"
    volumes:
      - ./nginx-proxy.conf:/etc/nginx/conf.d/default.conf
    networks:
      - proxy-network
    depends_on:
      - PROJEKTNAME-web

  PROJEKTNAME-web:
    build: .
    image: PROJEKTNAME:latest
    container_name: PROJEKTNAME-web-proxied
    restart: unless-stopped
    networks:
      - proxy-network
    environment:
      - NODE_ENV=${NODE_ENV:-development}

networks:
  proxy-network:
    name: proxy-network-PROJEKTNAME
    driver: bridge
```

#### `nginx-proxy.conf`
```nginx
server {
    listen 80;
    server_name localhost;
    
    # Redirect root to project
    location = / {
        return 301 /PROJEKTNAME/;
    }
    
    # Project application
    location /PROJEKTNAME/ {
        rewrite ^/PROJEKTNAME/(.*) /$1 break;
        
        proxy_pass http://PROJEKTNAME-web-proxied:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        proxy_redirect http://PROJEKTNAME-web-proxied:80/ /PROJEKTNAME/;
    }
    
    # Status page
    location /status {
        default_type text/html;
        return 200 '<html><body><h1>PROJEKTNAME läuft</h1><a href="/PROJEKTNAME/">Zur App</a></body></html>';
    }
}
```

#### `docker-start-nginx.sh`
```bash
#!/bin/bash
# Kopiere das Script von fairharvest und passe die Namen an
```

### Schritt 2: Anpassungen

**Ersetze in allen Dateien:**
- `PROJEKTNAME` → dein Projektname (z.B. `myapp`)
- `fairharvest` → dein Projektname
- Ports anpassen falls nötig

### Schritt 3: Starten

```bash
chmod +x docker-start-nginx.sh
./docker-start-nginx.sh start
```

**Zugriff:** `http://localhost/PROJEKTNAME/`

## 🎯 Methode 2: Zentraler Traefik (für mehrere Projekte)

### Setup einmalig erstellen

#### `docker-compose.traefik-global.yml`
```yaml
version: '3.8'

services:
  traefik:
    image: traefik:v3.0
    container_name: traefik-global
    restart: unless-stopped
    ports:
      - "80:80"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./traefik-global.yml:/traefik.yml:ro
    networks:
      - traefik-global
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.dashboard.rule=Host(`traefik.local`)"
      - "traefik.http.routers.dashboard.service=api@internal"

networks:
  traefik-global:
    name: traefik-global
    driver: bridge
```

### Für jedes Projekt

#### `docker-compose.yml`
```yaml
version: '3.8'

services:
  PROJEKTNAME-web:
    build: .
    image: PROJEKTNAME:latest
    container_name: PROJEKTNAME-web
    restart: unless-stopped
    networks:
      - traefik-global
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.PROJEKTNAME.rule=Host(`PROJEKTNAME.local`)"
      - "traefik.http.routers.PROJEKTNAME.service=PROJEKTNAME"
      - "traefik.http.services.PROJEKTNAME.loadbalancer.server.port=80"
      - "traefik.docker.network=traefik-global"

networks:
  traefik-global:
    external: true
```

### Hosts-File aktualisieren

```bash
# Windows (WSL)
echo "127.0.0.1 PROJEKTNAME.local" | sudo tee -a /c/Windows/System32/drivers/etc/hosts

# Linux
echo "127.0.0.1 PROJEKTNAME.local" | sudo tee -a /etc/hosts
```

**Zugriff:** `http://PROJEKTNAME.local`

## 🔧 Praktische Tipps

### Port-Konflikte vermeiden

```bash
# Prüfe, was Port 80 verwendet
lsof -i :80

# Stoppe Apache/Nginx falls läuft
sudo systemctl stop apache2
sudo systemctl stop nginx
```

### Mehrere Projekte gleichzeitig

**Methode 1:** Ein Projekt pro Zeit (Port 80)
**Methode 2:** Traefik für alle Projekte (verschiedene Domains)

### Debugging

```bash
# Container-Status
docker ps

# Nginx-Logs
docker logs nginx-proxy-PROJEKTNAME

# Netzwerk prüfen
docker network ls
```

## 📂 Dateistruktur Beispiel

```
mein-projekt/
├── docker-compose.nginx.yml
├── nginx-proxy.conf
├── docker-start-nginx.sh
├── Dockerfile
├── index.html
└── ...
```

## 🎛️ Alternative: Docker-Compose Override

Für bestehende Projekte ohne Nginx:

#### `docker-compose.override.yml`
```yaml
version: '3.8'

services:
  nginx-proxy:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx-proxy.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - web

  web:
    networks:
      - default
```

## 🚀 Empfehlung

**Für Einzelprojekte:** Methode 1 (eigener Nginx)
**Für viele Projekte:** Methode 2 (Traefik)

Das fairharvest-Projekt ist ein perfektes Template - kopiere einfach die Dateien und passe die Namen an!