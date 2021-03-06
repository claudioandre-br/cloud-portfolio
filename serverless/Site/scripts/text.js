/*
	Requires G_API_GATEWAY_URL_STR in the window object, 
	see readme and exercise guide
*/
var 
	$button = $("button"),
	$output = $("output"),
	$select = $("select");

/**
 * _askTheFakeBot
 *
 * This is a FAKE CLIENT chatbot
 * It does not hit a backend
 * "regardless of which city you pass",
 * it thinks it is 20 degrees
 * and is too cold for a cat.
 * 
 * @param String campus_str // austin
 * @return To Callback Via Custom Reponse Helper
 * 		//response_str
 */
function _askTheFakeBot(campus_str, cb){
	var 
		hard_coded_temp_int = 20,
		response_str = "";
	cb(g_customizeResponse(campus_str, hard_coded_temp_int));
}

/**
 * _askTheMockAPIBot
 *
 * This is a API chatbot
 * It DOES hit an API
 * If you have just wired up the api gateway mock
 * it will thinks everywhere is 69 degrees
 * and it is probably just right for your cat.
 * 
 * 
 * If you have just wired up the api gateway LAMBDA mock
 * it will thinks everywhere is 76 degrees
 * and it is probably too hot for your cat.
 * 
 * If you have just wired up the api gateway LAMBDA to
 * DynamoDB
 * then it will return a different temp per city.
 * and the message may change per city.
 * @param String campus_str // austin
 * @return To Callback Via Custom Reponse Helper
 * 		//response_str
 */
function _askTheAPIBot(campus_str, cb){
	console.log("Clamando na API: " + G_API_GATEWAY_URL_STR);
	var 
		params = {
			"campus_str": campus_str
		};
	g_ajaxer(G_API_GATEWAY_URL_STR, params, function(response){
		handleGatewayResponse(response, campus_str, cb);
	}, function(error){
		handleGatewayError(error, cb);
	});
}

function handleGatewayResponse(response, campus_str, cb){
	var 
		temp_int = response.temp_int;
	cb(g_customizeResponse(campus_str, temp_int));
}

function handleGatewayError(error, cb){
	cb("This failed:" + error.statusText);
}
/**
 * _askTheBot
 *
 * Proxy to the right bot
 *  
 * @param String campus_str // austin
 * @param Function //parent_cb
 */
function _pickABot(campus_str, cb){
	if(campus_str === ""){
		response_str = "Escolhe um campus, vai!";
		return cb(response_str);
	}
	if(G_API_GATEWAY_URL_STR === null){
		_askTheFakeBot(campus_str, cb);
	}else{
		_askTheAPIBot(campus_str, cb);
	}
}
/**
 * whatShouldMyPetDo
 * 
 * @param Submit Event from form
 * @return undefined //UI change on output
 * 
 */
function whatShouldMyPetDo(se){
	var 
		campus_str = "";
	se.preventDefault();
	if($button.prop("disabled") === true){
		return;
	}
	$output.attr("data-showing", "not_showing");
	$button.prop("disabled", "true");
	campus_str = $select.val();//they are already uppercase
	_pickABot(campus_str, function(response_str){
		$output.html(response_str);
		$output.attr("data-showing", "showing");
		$button.prop("disabled", false);
	});
}

//only start the app once we have all the cities
g_loadTheCitiesIntoDropDown($select, function(){
	$button.prop("disabled", false)
			.text("Chama o Bot");
});


//handlers
$(document).on("submit", whatShouldMyPetDo);
