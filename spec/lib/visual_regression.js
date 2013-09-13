phantomcss.init({
    libraryRoot: '../helpers/PhantomCSS',
    screenshotRoot: '../screenshots',
    failedComparisonsRoot: '../screenshots/failures',

    // If failedComparisonsRoot is not defined failure images can still 
    // be found alongside the original and new images

    addLabelToFailedImage: false, // Don't add label to generated failure image

    onFail: function(test){ console.log(test.filename, test.mismatch); },
    onPass: function(){ console.log(test.filename); },
    onTimeout: function(){ console.log(test.filename); },
    onComplete: function(allTests, noOfFails, noOfErrors){
        allTests.forEach(function(test){
            if(test.fail){
                console.log(test.filename, test.mismatch);
            }
        });
    },
    fileNameGetter: function(root,filename){ 
        // globally override output filename
        // files must exist under root
        // and use the .diff convention
        var name = root+'/somewhere/'+filename;
        if(fs.isFile(name+'.png')){
            return name+'.diff.png';
        } else {
            return name+'.png';
        }
    }
});

phantomcss.turnOffAnimations(); // turn off CSS transitions and jQuery animations

/*
    Initialise CasperJs
*/
 
phantom.casperPath = 'CasperJs';
phantom.injectJs(phantom.casperPath + '/bin/bootstrap.js');
phantom.injectJs('jquery.js');
 
var casper = require('casper').create({
    viewportSize: {
        width: 1027,
        height: 800
    }
});
 
/*
    Require and initialise PhantomCSS module
*/
 
var phantomcss = require('../helpers/phantomcss.js');
 
phantomcss.init({
    screenshotRoot: './screenshots',
    failedComparisonsRoot: './failures'
});
 
/*
    The test scenario
*/
 
var url = 'http://www.mattsnider.com'; // replace with your URL
 
casper.
    start(url).
    // screenshot the initial page load
    then(function() {
        phantomcss.screenshot('<SELECTOR_TO_SCREENSHOT>', '<LABEL_SCREENSHOT>');
    }).
    then(function() {
        // do something
    }).
    // second screenshot
    then(function() {
        phantomcss.screenshot('<SELECTOR_TO_SCREENSHOT>', '<LABEL_SCREENSHOT>');
    });
 
/*
    End tests and compare screenshots
*/
 
casper.
    then(function now_check_the_screenshots() {
        phantomcss.compareAll();
    }).
    run(function end_it() {
        console.log('\nTHE END.');
        phantom.exit(phantomcss.getExitStatus());
    });