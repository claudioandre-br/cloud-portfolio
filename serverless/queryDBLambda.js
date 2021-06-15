function handler(event, context, callback){
    var 
        AWS = require("aws-sdk"),
        DDB = new AWS.DynamoDB({
            apiVersion: "2012-08-10",
            region: "us-east-1"
        }),
        
        campus_str = event.campus_str.toUpperCase(),
        data = {
            campus_str: campus_str,
            temp_int_str: 72
        },
        response = {},
        params = {
            TableName: "weather",
            KeyConditionExpression: "city = :v1",
            ExpressionAttributeValues: {
                ":v1":{
                    S: campus_str
                }
            }
        };
    
   	DDB.query(params, function(err, data){
       var
       		item = {},
           	response = {
            	statusCode: 200,
            	headers: {},
            	body: null
        	};
        if(err){
            response.statusCode = 500;
            console.log(err);
            response.body = err;
        }else{
            // console.log(data.Items[0]);
            var data = data.Items[0];
            if(data && data.temperatura){
                console.log(data.city.S + " and " + data.temperatura.N);
            	item = {
                    temp_int:Number(data.temperatura.N),
                    campus_str: data.city.S
            	};
            }else{
                item = {
                	campus_str: event.campus_str
                  //when we don't return a temp, the client can say city not found
            	};
            }
        }
        response = item;
       // console.log(response);
        callback(null, response);
    });
}
exports.handler = handler;
