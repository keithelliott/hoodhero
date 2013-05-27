var Twilio_AccountSid,
    Twilio_AuthToken,
    Twilio = require('twilio');



module.exports = function smsManager(){
    Twilio_AccountSid = 'your account id';
    Twilio_AuthToken = 'your auth token';
    Twilio.initialize(Twilio_AccountSid, Twilio_AuthToken);
    return exports;
};

function sendSMS(request, message){
    Twilio.sendSMS({
        From: request.To,
        To: request.From,
        Body: message
    }, {
        success: function(httpResponse) {
            console.log(httpResponse);
        },
        error: function(httpResponse) {
            console.error(httpResponse);
        }
    });
}

exports.sendSMS =  sendSMS;

exports.saveInitialTip =  function saveInitialTip(params){
    var SMS = Parse.Object.extend("SMS");
    var sms = new SMS();

    sms.set("From", params.From);
    sms.set("body", params.Body);
    sms.set("to", params.To);
    sms.set("AccountSid", params.AccountSid);
    sms.set('SmsSid', params.SmsSid);

    sms.save({
        success: function(httpResponse) {
            // The object was saved successfully.
            console.log(httpResponse);
        },
        error: function(sms, error) {
            // The save failed.
            // error is a Parse.Error with an error code and description.
            console.log("Error: " + error.code + " " + error.message);
        }
    });
};

exports.getTipsterFromSmsSid = function(smsId, callback){
    console.log("smsId:" + smsId);
    var SMS = Parse.Object.extend("SMS");
    var query = new Parse.Query(SMS);
    query.equalTo("SmsSid", smsId);
    query.first({
        success: function(sms) {
            callback(sms);
        },
        error: function(error) {
            callback(sms,error);
        }
    });
};

exports.updateTipWithLocation = function updateTipWithLocation(sms, body, callback){
   sms.set('location',body);
   sms.save({
       success: function(sms) {
           // The object was saved successfully.
           console.log(sms);
           callback(sms);
       },
       error: function(sms, error) {
           // The save failed.
           // error is a Parse.Error with an error code and description.
           console.error("Error: " + error.code + " " + error.message);
           callback(sms,error);
       }
   });
};

exports.doesTipsterExistForSmsId = function doesTipsterExistForSmsId(smsId, callback){
    var SMS = Parse.Object.extend("SMS");
    var query = new Parse.Query(SMS);
    query.equalTo("SmsSid", smsId);
    query.count({
        success: function(number){
            callback(number);
        },
        error: function(error){
            callback(0, error);
        }
    });
};

function saveSMS(request){
    console.log('saving sms');
    var SMS = Parse.Object.extend("SMS");
    var sms = new SMS();
    sms.set("From", request.params.From);
    sms.set("body", request.params.Body);
    sms.set("to", request.params.To);
    sms.set("AccountSid", request.params.AccountSid);
    sms.set('SmsSid', request.params.SmsSid);
    sms.save();

    return sms;
}

function determineNextAction(params){
    var sms = params.sms;
    var smsCount = params.count;
    console.log('determine next action for sms:' + sms.SmsSid);
    var SmsSid = sms.get('SmsSid');
    console.log('SmsSid:' + SmsSid);
    var toR = sms.get('to');
    var fromR = sms.get('From');

    if(smsCount == 0){
        smsManager.sendSMS({'To':toR, 'From': fromR }, 'Where is this happening?');
        //response.success('sending followup request sms');
    }
    else if(smsCount >= 1){
        sms.set("location", request.params.Body);
        sms.save();
        smsManager.sendSMS({'To':toR, 'From': fromR }, 'Thank you for the tip');
       // response.success('sending followup thank you sms');
    }
}

exports.RouteMessage = function RouteMessage(request, response){
    var smsCount, sms;
    var SMS = Parse.Object.extend("SMS");
    var query = new Parse.Query(SMS);
    var result = query.count().then(function(count){
        smsCount = count;
        return request;
    }).then(saveSMS).then(function(obj){
            sms = obj;
            return sms;
        }).then(function(sms){
        console.log('determine next action for sms:' + sms.SmsSid);
        var SmsSid = sms.get('SmsSid');
        console.log('SmsSid:' + SmsSid);
        var toR = sms.get('to');
        var fromR = sms.get('From');

        if(smsCount == 0){
            sendSMS({'To':toR, 'From': fromR }, 'Where is this happening?');
            response.success('sending followup request sms');
        }
        else if(smsCount >= 1){
            sms.set("location", request.params.Body);
            sms.save();
            sendSMS({'To':toR, 'From': fromR }, 'Thank you for the tip');
            response.success('sending followup thank you sms');
        }
    });
};