const fs = require("fs");

const csv = require("neat-csv");
const puppeteer = require("puppeteer");

async function getBrowser() {
    const browser = await puppeteer.launch({
        headless: true,
        devtools: true
    });
    return browser;
}

(async () => {

    let siteUrls = fs.readFileSync("site-urls.csv");
    siteUrls = await csv(siteUrls);

    let latLongPairs = fs.readFileSync("cities-lat-lon.csv");
    latLongPairs = await csv(latLongPairs);

    var runSize = 75; //process.argv[2];

    for (let i = 0; i < runSize; i++) {
        //Randomly select URL and visit
        //var randUrl = Math.floor(Math.random() * siteUrls.length);
        //const url = siteUrls[randUrl].URL;

        const randomUrl = siteUrls[Math.floor(Math.random() * siteUrls.length)];
        const url = randomUrl.URL;

        const browser = await getBrowser();
        const page = await browser.newPage();

        //page.setExtraHTTPHeaders({ referer: 'https://social.com/' });
        //var url2 = "https://browserleaks.com/geo";
        //const context = browser.defaultBrowserContext()
        /*
        await context.overridePermissions(`${url}`, ['geolocation'])
        var lat, lon;
        for (let j = 0; j < latLongPairs.length; j++) {
            var randPair = Math.floor(Math.random() * latLongPairs.length);
            lat = latLongPairs[randPair].Latitude;
            lon = latLongPairs[randPair].Longitude;
        }
        await page.setGeolocation({latitude:parseFloat(lat), longitude:parseFloat(lon)})
         */

        await page.goto(url);

        await browser.close();
        console.log('' + (i+1) + '/' + runSize + '-' + url);
    }
})();