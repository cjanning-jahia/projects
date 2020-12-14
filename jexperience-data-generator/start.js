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

    let views = fs.readFileSync("views.csv");
    views = await csv(views);
    let conversions = fs.readFileSync("conversions.csv");
    conversions = await csv(conversions);
    let storyline = fs.readFileSync("storyline.csv");
    storyline = await csv(storyline);

    let allPageViews = 200; //This will be the total views for the day

    //Randomize page views across all pages
    console.info('Creating ' + allPageViews + ' page views...');
    for (let i = 0; i < allPageViews; i++) {
        //Randomly select URL and visit
        const randomUrl = views[Math.floor(Math.random() * views.length)];

        const url = randomUrl.URL;
        const browser = await getBrowser();
        const page = await browser.newPage();
        await page.goto(url);
        await browser.close();

        console.info('View:' + (i+1) + '/' + allPageViews + '-' + url);
    }

    //Create higher page views for target storyline
    let highPageView = Math.round(allPageViews * .20);
    console.info('Creating ' + highPageView + ' higher page views...');
    for (let i = 0; i < highPageView; i++) {
        //Randomly select URL and visit
        const randomUrl = storyline[Math.floor(Math.random() * storyline.length)];

        const url = randomUrl.URL;
        const browser = await getBrowser();
        const page = await browser.newPage();
        await page.goto(url);
        await browser.close();

        console.info('View:' + (i+1) + '/' + highPageView + '-' + url);
    }

    //Generate normal conversion rate across all but target storyline
    let normConvCount = Math.round(allPageViews * .15);
    console.info('Creating ' + normConvCount + ' conversions(all)...');
    for (let i = 0; i < normConvCount; i++) {
        //Randomly select URL and visit
        const randomUrl = conversions[Math.floor(Math.random() * conversions.length)];

        const url = randomUrl.URL;
        const browser = await getBrowser();
        const page = await browser.newPage();
        await page.goto(url);
        await browser.close();
        //Submit a form
        console.info('Conversion(all):' + (i+1) + '/' + normConvCount + '-' + url);
    }

    //Generate normal conversion rate across all but target storyline
    let lowConvCount = Math.round(allPageViews * .05);
    console.info('Creating ' + lowConvCount + ' conversions(storyline)...');
    for (let i = 0; i < lowConvCount; i++) {
        //Randomly select URL and visit
        const randomUrl = storyline[Math.floor(Math.random() * storyline.length)];

        const url = randomUrl.URL.replace("views","conversions");
        const browser = await getBrowser();
        const page = await browser.newPage();
        await page.goto(url);
        await browser.close();

        console.info('Conversion(storyline):' + (i+1) + '/' + lowConvCount + '-' + url);
    }

    console.info("Finished data generation");
})();