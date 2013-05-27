
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("receiveSMS", function(request, response) {
    console.log("Received a new text: " + request.params.From);
    var smsManager = require('cloud/smsManager.js')();
    smsManager.RouteMessage(request,response);
});

Parse.Cloud.define("sendSMS", function(request, response){
   console.log("Sending a new text");
    var Twilio = require('twilio');
    Twilio.initialize('your app id', 'your auth token');

    Twilio.sendSMS({
        From: request.params.from,
        To: request.params.to,
        Body: request.params.message
    }, {
        success: function(httpResponse) {
            console.log(httpResponse);
            response.success("SMS sent!");
        },
        error: function(httpResponse) {
            console.error(httpResponse);
            response.error("Uh oh, something went wrong with error: " + httpResponse);
        }
    });
});

Parse.Cloud.afterSave("SMS", function(request, response){
   // Send a push notification to the iOS app once a new object has been saved
    //only send a push notification if the createdAt and updatedAt times are the same

    var updatedAt = request.object.updatedAt;
    var createdAt = request.object.createdAt;

    if(updatedAt === createdAt){
        console.log('sending a push notification');
        var bodyText = request.object.get('body');

        var pushQuery = new Parse.Query(Parse.Installation);
        pushQuery.equalTo('deviceType', 'ios');


        Parse.Push.send({
            where: pushQuery, // Set our installation query
            data: {
                alert: "New Tip with message: " + bodyText
            }
        }, {
            success: function(){
                // push was good
            },
            error: function(error){
              throw "Push failed with error code:" + error.code + " message:" + error.message;
            }
        });
    }
    else{
        console.log('Not sending push because save occurred on iPad');
    }

});

Parse.Cloud.define("findSMSbySmsId", function(request, response){
    var smsMgr = require('cloud/smsManager.js')();
    smsMgr.getTipsterFromSmsSid(request.params.SmsSid, function(sms, error){
        if(!error){
            if(typeof(sms) !== 'undefined'){
                response.success(sms);
            }
            else{
                response.success('No Sms found for id:' + request.params.SmsSid);
            }
        }
        else{
            response.error(error.message);
        }
    });
});

Parse.Cloud.define("updateSMSWithLocation", function(request, response){
    var smsMgr = require('cloud/smsManager.js')();
    smsMgr.getTipsterFromSmsSid(request.params.smsId, function(sms, error){
        if(!error){
            smsMgr.updateTipWithLocation(sms, request.params.body, function(sms, error){
                if(!error){
                    response.success(sms);
                }
                else{
                    response.error(error.message);
                }
            });
        }
        else{
            response.error(error.message);
        }
    });
});