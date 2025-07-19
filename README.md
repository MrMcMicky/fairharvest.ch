# 🌾 Fair Harvest - Premium Organic Spices

Premium organic spices, rice, and coffee from India and Sri Lanka. Direct export to Switzerland with fair trade practices.

**Last Updated:** 19.07.2025  
**Status:** ✅ Production Ready - 100% Tests Passed

## 🚀 Quick Start

### Multi-Project Setup (Recommended)
```bash
# Access through shared proxy
http://localhost/fairharvest/
```

### Standalone Setup
```bash
# Development
./docker-start.sh dev
# Access: http://localhost:3001

# Production  
./docker-start.sh prod
# Access: http://localhost:3010
```

### Clean URLs Setup
```bash
# Nginx proxy
./docker-start-nginx.sh start
# Access: http://localhost/fairharvest/

# Traefik proxy
./docker-start-traefik.sh start  
# Access: http://fairharvest.local
```

## 🎨 Features

- ✅ **Premium Design:** Dark header with golden logo
- ✅ **Responsive:** Mobile-first approach
- ✅ **SEO Optimized:** Meta tags, favicon, structured data
- ✅ **Contact Form:** Functional contact form
- ✅ **Multi-Language Ready:** English base, extendable
- ✅ **Docker Ready:** Full containerization

## 🏗️ Project Structure

```
fairharvest-ch/
├── index.html              # Main website
├── style.css               # Custom styles
├── logo.png                # Fair Harvest logo
├── favicon.png             # Browser favicon
├── nginx.conf              # Nginx configuration
├── Dockerfile              # Container build
├── docker-compose.yml      # Standalone setup
├── docker-compose.nginx.yml # Nginx proxy setup
├── docker-compose.traefik.yml # Traefik proxy setup
├── docker-start.sh         # Main management script
├── docker-start-nginx.sh   # Nginx proxy script
├── docker-start-traefik.sh # Traefik proxy script
├── automated-test.js       # Automated test suite
├── package.json            # Node dependencies
├── test-screenshots/       # Test screenshots
├── DEVELOPMENT_WORKFLOW.md # Development standards
├── TEST_REPORT.md          # Manual test results
├── TEST_REPORT_AUTOMATED.md # Automated test results
├── PORT_ALLOCATION.md      # Port documentation
├── LOCAL_DOMAINS.md        # Local domain setup
└── LOCAL_REVERSE_PROXY_GUIDE.md # Proxy guide
```

## 🧪 Testing

**Automated Testing:** ✅ Fully Implemented with Puppeteer

All functionality thoroughly tested:
- ✅ Navigation & anchor links
- ✅ Buttons & interactions  
- ✅ Contact form
- ✅ Responsive design
- ✅ Asset loading
- ✅ Multi-project integration
- ✅ Performance metrics (< 3s load time)
- ✅ Mobile responsiveness
- ✅ Console error checking

**Test Reports:**
- `TEST_REPORT.md` - Manual test results
- `TEST_REPORT_AUTOMATED.md` - Automated test results
- `automated-test.js` - Test script (27 tests)

Run automated tests:
```bash
npm test
```

## 📱 URLs

**Multi-Project Setup:**
- Main: `http://localhost/fairharvest/`
- Status: `http://localhost/status`

**Standalone:**
- Development: `http://localhost:3001`
- Production: `http://localhost:3010`

**Clean URLs:**
- Nginx: `http://localhost/fairharvest/`
- Traefik: `http://fairharvest.local`

## 🔧 Development

Follow the standard workflow in `DEVELOPMENT_WORKFLOW.md`:
1. Make changes
2. Run full functionality tests
3. Update documentation
4. Git commit & push

## 🌐 Deployment

Ready for deployment on Ubuntu VPS with nginx proxy configuration.

## 📄 Documentation

- `DEVELOPMENT_WORKFLOW.md` - Development standards
- `PORT_ALLOCATION.md` - Port management
- `LOCAL_DOMAINS.md` - Local domain setup
- `LOCAL_REVERSE_PROXY_GUIDE.md` - Multi-project setup
- `TEST_REPORT.md` - Latest test results