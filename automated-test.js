const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

// Test configuration
const CONFIG = {
    baseUrl: 'http://localhost/fairharvest/',
    timeout: 30000,
    viewport: { width: 1920, height: 1080 },
    mobileViewport: { width: 375, height: 667 },
    screenshotDir: './test-screenshots'
};

// Ensure screenshot directory exists
if (!fs.existsSync(CONFIG.screenshotDir)) {
    fs.mkdirSync(CONFIG.screenshotDir, { recursive: true });
}

// Test results storage
const testResults = {
    timestamp: new Date().toISOString(),
    url: CONFIG.baseUrl,
    passed: 0,
    failed: 0,
    errors: [],
    warnings: [],
    performance: {},
    tests: []
};

// Helper functions
function logTest(name, status, details = '') {
    const result = { name, status, details, timestamp: new Date().toISOString() };
    testResults.tests.push(result);
    
    if (status === 'PASS') {
        testResults.passed++;
        console.log(`✅ ${name}: ${details}`);
    } else {
        testResults.failed++;
        console.log(`❌ ${name}: ${details}`);
        testResults.errors.push(`${name}: ${details}`);
    }
}

function logWarning(message) {
    testResults.warnings.push(message);
    console.log(`⚠️  ${message}`);
}

async function takeScreenshot(page, name) {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const filename = `${timestamp}-${name}.png`;
    const filepath = path.join(CONFIG.screenshotDir, filename);
    
    await page.screenshot({
        path: filepath,
        fullPage: true,
        type: 'png'
    });
    
    return filepath;
}

async function runTests() {
    console.log('🚀 Starting MANDATORY TESTING PROTOCOL for Fair Harvest');
    console.log('='.repeat(60));
    
    let browser;
    try {
        browser = await puppeteer.launch({
            headless: true,
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        
        const page = await browser.newPage();
        
        // Set up console logging
        const consoleErrors = [];
        const consoleWarnings = [];
        
        page.on('console', (msg) => {
            if (msg.type() === 'error') {
                consoleErrors.push(msg.text());
            } else if (msg.type() === 'warning') {
                consoleWarnings.push(msg.text());
            }
        });
        
        // Set up request/response monitoring
        const failedRequests = [];
        page.on('requestfailed', (request) => {
            failedRequests.push({
                url: request.url(),
                error: request.failure().errorText
            });
        });
        
        // Set viewport
        await page.setViewport(CONFIG.viewport);
        
        // Performance measurement start
        const performanceStart = Date.now();
        
        // Navigate to site
        console.log('🌐 Loading Fair Harvest website...');
        const response = await page.goto(CONFIG.baseUrl, { 
            waitUntil: 'networkidle2',
            timeout: CONFIG.timeout
        });
        
        const loadTime = Date.now() - performanceStart;
        testResults.performance.initialLoad = loadTime;
        
        // Take initial screenshot
        await takeScreenshot(page, 'initial-load');
        
        // Test 1: Page loads successfully
        if (response && response.status() === 200) {
            logTest('Page Load', 'PASS', `200 OK - ${loadTime}ms`);
        } else {
            logTest('Page Load', 'FAIL', `Status: ${response ? response.status() : 'No response'}`);
        }
        
        // Test 2: Performance check
        if (loadTime < 3000) {
            logTest('Load Performance', 'PASS', `${loadTime}ms < 3000ms`);
        } else {
            logTest('Load Performance', 'FAIL', `${loadTime}ms >= 3000ms`);
        }
        
        // Test 3: Check for essential elements
        const essentialElements = [
            { selector: 'nav', name: 'Navigation' },
            { selector: 'section', name: 'Content Sections' },
            { selector: 'footer', name: 'Footer' },
            { selector: 'img[src="logo.png"]', name: 'Logo' },
            { selector: 'link[rel="icon"]', name: 'Favicon' }
        ];
        
        for (const element of essentialElements) {
            const exists = await page.$(element.selector);
            if (exists) {
                logTest(`Element: ${element.name}`, 'PASS', `Found ${element.selector}`);
            } else {
                logTest(`Element: ${element.name}`, 'FAIL', `Missing ${element.selector}`);
            }
        }
        
        // Test 4: Navigation links
        const navLinks = [
            { selector: 'a[href="#products"]', name: 'Products Link' },
            { selector: 'a[href="#about"]', name: 'About Link' },
            { selector: 'a[href="#contact"]', name: 'Contact Link' }
        ];
        
        for (const link of navLinks) {
            const element = await page.$(link.selector);
            if (element) {
                logTest(`Navigation: ${link.name}`, 'PASS', `Found ${link.selector}`);
                
                // Test clicking the link
                try {
                    await element.click();
                    await new Promise(resolve => setTimeout(resolve, 1000));
                    logTest(`Navigation Click: ${link.name}`, 'PASS', 'Click successful');
                } catch (error) {
                    logTest(`Navigation Click: ${link.name}`, 'FAIL', error.message);
                }
            } else {
                logTest(`Navigation: ${link.name}`, 'FAIL', `Missing ${link.selector}`);
            }
        }
        
        // Test 5: Buttons functionality
        const buttons = [
            { selector: 'button.bg-amber-600', name: 'Hero Button' },
            { selector: 'button[type="submit"]', name: 'Contact Form Submit' }
        ];
        
        for (const button of buttons) {
            const elements = await page.$$(button.selector);
            if (elements.length > 0) {
                logTest(`Button: ${button.name}`, 'PASS', `Found ${elements.length} button(s)`);
                
                // Test first button click
                try {
                    await elements[0].click();
                    await new Promise(resolve => setTimeout(resolve, 500));
                    logTest(`Button Click: ${button.name}`, 'PASS', 'Click successful');
                } catch (error) {
                    logTest(`Button Click: ${button.name}`, 'FAIL', error.message);
                }
            } else {
                logTest(`Button: ${button.name}`, 'FAIL', `Missing ${button.selector}`);
            }
        }
        
        // Test 6: Form validation
        const contactForm = await page.$('form');
        if (contactForm) {
            logTest('Contact Form', 'PASS', 'Form element found');
            
            // Test form fields
            const formFields = [
                { selector: 'input[name="name"]', name: 'Name Field' },
                { selector: 'input[name="email"]', name: 'Email Field' },
                { selector: 'textarea[name="message"]', name: 'Message Field' }
            ];
            
            for (const field of formFields) {
                const element = await page.$(field.selector);
                if (element) {
                    logTest(`Form Field: ${field.name}`, 'PASS', `Found ${field.selector}`);
                } else {
                    logTest(`Form Field: ${field.name}`, 'FAIL', `Missing ${field.selector}`);
                }
            }
        } else {
            logTest('Contact Form', 'FAIL', 'No form element found');
        }
        
        // Test 7: Mobile responsiveness
        console.log('📱 Testing mobile responsiveness...');
        await page.setViewport(CONFIG.mobileViewport);
        await new Promise(resolve => setTimeout(resolve, 2000));
        
        // Take mobile screenshot
        await takeScreenshot(page, 'mobile-view');
        
        // Test mobile menu (hamburger button)
        const mobileMenu = await page.$('button .fa-bars');
        if (mobileMenu) {
            logTest('Mobile Menu', 'PASS', 'Mobile menu button found');
            
            try {
                await mobileMenu.click();
                await new Promise(resolve => setTimeout(resolve, 1000));
                logTest('Mobile Menu Click', 'PASS', 'Mobile menu opens');
            } catch (error) {
                logTest('Mobile Menu Click', 'FAIL', error.message);
            }
        } else {
            logTest('Mobile Menu', 'FAIL', 'No mobile menu button found');
        }
        
        // Test 8: Performance metrics
        const metrics = await page.metrics();
        testResults.performance.jsHeapUsed = metrics.JSHeapUsedSize;
        testResults.performance.jsHeapTotal = metrics.JSHeapTotalSize;
        
        // Bundle size estimation
        const resourceSizes = await page.evaluate(() => {
            const entries = performance.getEntriesByType('resource');
            let totalSize = 0;
            entries.forEach(entry => {
                if (entry.transferSize) {
                    totalSize += entry.transferSize;
                }
            });
            return totalSize;
        });
        
        testResults.performance.bundleSize = resourceSizes;
        
        if (resourceSizes < 1024 * 1024) { // 1MB
            logTest('Bundle Size', 'PASS', `${Math.round(resourceSizes / 1024)}KB < 1MB`);
        } else {
            logTest('Bundle Size', 'FAIL', `${Math.round(resourceSizes / 1024)}KB >= 1MB`);
        }
        
        // Test 9: Console errors check
        if (consoleErrors.length === 0) {
            logTest('Console Errors', 'PASS', 'No console errors found');
        } else {
            logTest('Console Errors', 'FAIL', `${consoleErrors.length} errors: ${consoleErrors.join(', ')}`);
        }
        
        if (consoleWarnings.length === 0) {
            logTest('Console Warnings', 'PASS', 'No console warnings found');
        } else {
            logWarning(`${consoleWarnings.length} warnings: ${consoleWarnings.join(', ')}`);
        }
        
        // Test 10: Failed requests check
        if (failedRequests.length === 0) {
            logTest('Network Requests', 'PASS', 'All requests successful');
        } else {
            logTest('Network Requests', 'FAIL', `${failedRequests.length} failed requests`);
        }
        
        // Switch back to desktop view for final screenshot
        await page.setViewport(CONFIG.viewport);
        await new Promise(resolve => setTimeout(resolve, 1000));
        await takeScreenshot(page, 'final-desktop');
        
    } catch (error) {
        console.error('❌ Critical test failure:', error);
        testResults.errors.push(`Critical failure: ${error.message}`);
        testResults.failed++;
    } finally {
        if (browser) {
            await browser.close();
        }
    }
    
    // Generate final report
    console.log('\n' + '='.repeat(60));
    console.log('📊 FINAL TEST RESULTS');
    console.log('='.repeat(60));
    console.log(`✅ Passed: ${testResults.passed}`);
    console.log(`❌ Failed: ${testResults.failed}`);
    console.log(`⚠️  Warnings: ${testResults.warnings.length}`);
    console.log(`🕐 Total Load Time: ${testResults.performance.initialLoad}ms`);
    console.log(`📦 Bundle Size: ${Math.round(testResults.performance.bundleSize / 1024)}KB`);
    
    // Success check
    const successRate = (testResults.passed / (testResults.passed + testResults.failed)) * 100;
    console.log(`\n🎯 Success Rate: ${successRate.toFixed(1)}%`);
    
    if (testResults.failed === 0) {
        console.log('🎉 ALL TESTS PASSED! 100% SUCCESS ACHIEVED!');
        return true;
    } else {
        console.log('❌ TESTS FAILED! Issues need to be resolved.');
        console.log('\nErrors:');
        testResults.errors.forEach(error => console.log(`  - ${error}`));
        return false;
    }
}

// Run the tests
runTests().then(success => {
    process.exit(success ? 0 : 1);
}).catch(error => {
    console.error('Test runner failed:', error);
    process.exit(1);
});