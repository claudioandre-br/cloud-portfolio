function handler(event, context, callback){    
     var 
         campus_str = event.campus_str,
         response = {
             campus_str: campus_str,
             temp_int: 74
         };
     console.log(response);
     callback(null, response);
 }
 exports.handler = handler;
