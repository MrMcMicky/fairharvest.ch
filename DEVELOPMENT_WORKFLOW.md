# 🚀 Standard Development Workflow

**Last Updated:** 19.07.2025  
**Automated Testing:** ✅ Verfügbar via `npm test`

## Nach jeder Änderung OBLIGATORISCH:

### 1. 🧪 **Vollständige Funktions-Tests**

#### Automatisierte Tests (EMPFOHLEN):
```bash
npm test  # Führt 27 Tests aus mit Puppeteer
```

#### Manuelle Tests:
- [ ] Alle Buttons testen (Hover, Click, Funktionalität)
- [ ] Alle Links testen (Navigation, Anchor-Links)
- [ ] Formulare testen (Eingabe, Validierung, Submit)
- [ ] Mobile Navigation testen
- [ ] Responsive Design testen (Desktop, Tablet, Mobile)
- [ ] Browser-Kompatibilität testen (Chrome, Firefox, Safari, Edge)

### 2. 📱 **MCPs & Browser-Tests**
- [ ] WebFetch für Live-Tests verwenden
- [ ] Screenshots für Dokumentation erstellen
- [ ] Verschiedene Bildschirmgrößen testen
- [ ] Performance-Check (Ladezeiten, Ressourcen)

### 3. 🔍 **Technische Validierung**
- [ ] HTML-Validierung
- [ ] CSS-Validierung
- [ ] JavaScript-Fehler prüfen (Console)
- [ ] Favicon und Meta-Tags testen
- [ ] SEO-Elemente validieren

### 4. 📚 **Dokumentation**
- [ ] README.md aktualisieren
- [ ] Changelog erstellen/aktualisieren
- [ ] API-Dokumentation (falls nötig)
- [ ] Deployment-Anleitung prüfen

### 5. 🔄 **Git-Workflow**
- [ ] Staging-Area prüfen (`git status`)
- [ ] Commit mit aussagekräftiger Message
- [ ] Push zu Remote-Repository
- [ ] Tags für Releases (falls nötig)

### 6. 🎯 **Erst dann Rückmeldung**
- [ ] Alle Tests bestanden ✅
- [ ] Dokumentation aktualisiert ✅
- [ ] Git commit/push erfolgt ✅
- [ ] User über Fertigstellung informieren ✅

## 🛠️ **Benötigte Tools:**
- Browser-Testing: `curl`, `WebFetch`, `Puppeteer`
- Screenshots: System-Screenshots, Automated via Puppeteer
- Validation: HTML/CSS Validators
- Git: Standard Git-Commands
- Testing: Node.js, npm, Puppeteer

## 📋 **Checkliste-Template:**
```
✅ Funktions-Tests bestanden
✅ Browser-Tests erfolgreich  
✅ Mobile-Tests OK
✅ Dokumentation aktualisiert
✅ Git commit/push durchgeführt
✅ Bereit für User-Feedback
```

## 🚨 **Nie ohne vollständige Tests ausliefern!**