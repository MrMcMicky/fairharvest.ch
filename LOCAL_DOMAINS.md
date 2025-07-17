# Local Development Domains für Fair Harvest

## 🌐 Verfügbare Optionen

### Option 1: Traefik Reverse Proxy (empfohlen für mehrere Projekte)

```bash
# Starten
./docker-start-traefik.sh start

# Zugriff
http://fairharvest.local      # Fair Harvest Website
http://traefik.local:8080     # Traefik Dashboard
```

**Vorteile:**
- Schöne Domain-Namen
- Automatische Service-Discovery
- Dashboard für Übersicht
- Erweiterbar für weitere Projekte

**Nachteile:**
- Benötigt sudo für Hosts-File
- Komplexer Setup

### Option 2: Nginx Reverse Proxy (einfach)

```bash
# Starten
./docker-start-nginx.sh start

# Zugriff
http://localhost/fairharvest/  # Fair Harvest Website
http://localhost/status        # Status Page
http://localhost              # Auto-Redirect
```

**Vorteile:**
- Einfacher Setup
- Keine Hosts-File Änderungen
- Clean URLs mit Pfaden

**Nachteile:**
- Pfad-basiert statt Domain-basiert
- Weniger elegant

### Option 3: Standard Ports (aktuell)

```bash
# Starten
./docker-start.sh dev

# Zugriff
http://localhost:3001         # Fair Harvest Website
```

**Vorteile:**
- Einfachster Setup
- Keine Proxy-Konfiguration

**Nachteile:**
- Port-Nummern in URLs
- Potential für Port-Konflikte

## 🚀 Empfehlung

**Für ein einzelnes Projekt:** Nginx Proxy (`./docker-start-nginx.sh start`)
**Für mehrere Projekte:** Traefik Proxy (`./docker-start-traefik.sh start`)

## 📝 Manuelle Hosts-File Konfiguration

Falls du permanente lokale Domains ohne Traefik-Script möchtest:

### Windows (WSL)
```bash
# Bearbeite: C:\Windows\System32\drivers\etc\hosts
echo "127.0.0.1 fairharvest.local" | sudo tee -a /c/Windows/System32/drivers/etc/hosts
```

### Linux
```bash
# Bearbeite: /etc/hosts
echo "127.0.0.1 fairharvest.local" | sudo tee -a /etc/hosts
```

## 🔧 Troubleshooting

**Domain funktioniert nicht:**
- Warte 30 Sekunden für DNS-Propagation
- Teste mit `ping fairharvest.local`
- Überprüfe Hosts-File: `cat /etc/hosts`

**Port 80 bereits belegt:**
- Finde Service: `lsof -i :80`
- Stoppe andere Webserver (Apache, Nginx, etc.)

**Cache-Probleme:**
- Browser-Cache leeren
- DNS-Cache leeren: `sudo systemctl flush-dns` (Linux)