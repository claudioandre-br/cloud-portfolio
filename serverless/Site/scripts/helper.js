/*
	Helper functions
*/


/*
	Ensuring data type is set up for CORS
*/
function g_ajaxer(url_str, params, ok_cb, fail_cb){
	$.ajax({
		url: url_str,
		type: "POST",
		data: JSON.stringify(params),
		crossDomain: true,
		contentType: "application/json",
		dataType: "json",
		success: ok_cb,
		error: fail_cb,
		timeout: 10000
	});
}
/**
 * g_loadTheCitiesIntoDropDown(
 * 
 * Just populates a list of cities
 *
 * @param JqueryObject $parent_drop_down_e
 * @param Function parent_cb
 * 
 * return via parent_cb //always true || fail hard
*/
function g_loadTheCitiesIntoDropDown($parent_drop_down_el, parent_cb){
	$.get("cities.md", function(campus_str){
		var
			html_str = '',
			city_arr = [],
			city_temp_arr = campus_str.split("\n");

		city_arr = city_temp_arr.map(function(item){
		  return item.split(",")[0];
		});
		html_str += '<option value="">' + 'Me Escolhe' + '</option>';
		for(var i_int = 0; i_int < city_arr.length; i_int += 1){
			html_str += '<option value="' + city_arr[i_int] + '">' + city_arr[i_int].toLowerCase() + '</option>';
		}

		$parent_drop_down_el.html(html_str);
		parent_cb(true);//done
		//and if this fails, fail hard here instead
	});
}
/**
 * g_loadTheCitiesIntoDropDown(
 * 
 * Takes a city and temperature and replies with text
 * It decides if it is too hot or too cold
 * Range of temps is currently set between
 * 20 and 79
 *
 * @param String campus_str
 * @param Number temp_int
 * 
 * @return String  //The temperature is 20 degree, 
 * 		//I think that is too cold for cats"
 */
function g_customizeResponse(campus_str, temp_int){
	var 
		message_str = "Temperatura em " + campus_str.toLowerCase() + " eh " + temp_int.toString() + " graus.";
		// message_str += "<br /><br />";

	if(temp_int > 30){
		message_str += " Eu acho que esta pelando.";
	}else if(temp_int <= 30 && temp_int > 20){
		message_str += " Acredito que esta gostoso por la.";
	}else if(temp_int <= 20 && temp_int >= 15){
		message_str += " Vixe, ta meio cOOl por la.";
	}else{
		message_str += " Parece que a deusa Hela resolvou se mudar pra la.";
	}
	return message_str;
}




