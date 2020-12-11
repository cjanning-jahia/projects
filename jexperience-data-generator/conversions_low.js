const fs = require("fs");

const csv = require("neat-csv");
const puppeteer = require("puppeteer");

async function getBrowser() {
    const browser = await puppeteer.launch({
        headless: true,
        devtools: false
    });
    return browser;
}

(async () => {

    let siteUrls = fs.readFileSync("conversion-urls-low.csv");
    siteUrls = await csv(siteUrls);

    //let latLongPairs = fs.readFileSync("cities-lat-lon.csv");
    //latLongPairs = await csv(latLongPairs);

    var runSize = 40; //process.argv[2];
    var formSubmitGoal = runSize * .05; //keep conversion around 1%
    var formCount = 0;
    for (let i = 0; i < runSize; i++) {
        //Randomly select URL and visit
        const randomUrl = siteUrls[Math.floor(Math.random() * siteUrls.length)];
        const url = randomUrl.URL;

        const browser = await getBrowser();
        const page = await browser.newPage();
        /*
        page.setExtraHTTPHeaders({ referer: 'https://social.com/' });
        var url2 = "https://browserleaks.com/geo";
        const context = browser.defaultBrowserContext()
        await context.overridePermissions(`${url}`, ['geolocation'])
        var lat, lon;
        for (let j = 0; j < latLongPairs.length; j++) {
            var randPair = Math.floor(Math.random() * latLongPairs.length);
            lat = latLongPairs[randPair].Latitude;
            lon = latLongPairs[randPair].Longitude;
        }
        await page.setGeolocation({latitude:parseFloat(lat), longitude:parseFloat(lon)})
         */
        await page.goto(url,  {"waitUntil" : "networkidle0"});
        if (formCount <= formSubmitGoal) {
            await page.focus('input[name=text-input_0_1]');
            await page.$eval('input[name=text-input_0_1]', el => el.value = 'test@test.com');
            await page.click('button.btn.btn-sm.btn-primary');
            formCount++;
            console.log('Form submitted(' + (formCount) + ')-' + page.url());
        }
        await browser.close();
        console.log('' + (i+1) + '/' + runSize + '-' + page.url());
    }
})();