exports.handler = function(event, ctx, cb){
  var 
    my_response = {};
    if(event.currentIntent.slots.campus_str){
        // we have the city already awesome keep going
    }else{
        //we need to ask for (elicit) a city
        my_response.statusCode = 200;
        my_response.body = {
            "dialogAction": {
                "type": "ElicitSlot",
                "message": {
                    "contentType": "PlainText",
                    "content": "Tell me what is the name of the city where the campus is located, thanks"
                },
                "intentName": "IFSPWeather",
                "slots": {
                    "campus_str": null
                },
                "slotToElicit" : "campus_str"
            }
        };
        return cb(null, my_response.body);
    }
    var
        campus_str = event.currentIntent.slots.campus_str,
        AWS = require("aws-sdk"),
        DDB = new AWS.DynamoDB({
            apiVersion: "2012-08-10",
            region: "us-east-1"
        }),
        lookup_name_str = campus_str.toUpperCase(),
        params = {
            TableName: "weather",
            KeyConditionExpression: "city = :v1",
            ExpressionAttributeValues: {
                ":v1":{
                    "S": lookup_name_str
                }
            },
            ProjectionExpression: "temperatura"
        }; 
    
    console.log(params);
    DDB.query(params, function(err, data){
        if(err){
            throw err;
        }
        
        if(data.Items && data.Items[0] && data.Items[0].temperatura){
            console.log("city weather found");
            console.log(data.Items[0]);
            my_response.statusCode = 200;
            my_response.body = {
                "sessionAttributes": {
                    "temp_str": data.Items[0].temperatura.N,
                    "campus_str": event.currentIntent.slots.campus_str
                },
                "dialogAction":{
                    "type": "Close",
                    "fulfillmentState": "Fulfilled",
                    "message": {
                        "contentType": "PlainText",
                        "content": data.Items[0].temperatura.N
                    }
                }
            };
        }else{
            console.log("city weather not found for " + lookup_name_str);
            my_response.statusCode = 200;
            my_response.body = {
                "dialogAction": {
                    "type": "ElicitSlot",
                    "message": {
                        "contentType": "PlainText",
                        "content": "Please try another city, we couldn't find any campus in that city"
                    },
                    "intentName": "IFSPWeather",
                    "slots": {
                        "campus_str": null
                    },
                    "slotToElicit" : "campus_str"
                }
            }
        }
        return cb(null, my_response.body);
    });
};
