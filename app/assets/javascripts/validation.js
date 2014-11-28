// SWEET CLIENT SIDE VALIDATIONS :)

$(function(){

	var $firstNameInput = $('#first-name');
	var $firstNameError = $('#first-name-error');
	var $lastNameInput = $('#last-name');
	var $lastNameError = $('#last-name-error');
	var $userNameInput = $('#username');
	var $userNameError = $('#username-error');

	$firstNameInput.on("keyup", function(e){
		var name = $(this).val();
		if (isValidFirstName(name)){
			$firstNameError.css('display', 'none');
		} else {
			$firstNameError.css('display', 'block');
		}
	})

	$lastNameInput.on("keyup", function(e){
		var lastname = $(this).val();
		if (isValidLastName(lastname)){
			$lastNameError.css('display', 'none');
		} else {
			$lastNameError.css('display', 'block');
		}
	})

	$userNameInput.on("keyup", function(e){
		var username = $(this).val();
		if (isValidUserName(username)){
			$userNameError.css('display', 'none');
		} else {
			$userNameError.css('display', 'block');
		}
	})

})



function validFirstName(){
}

function isValidFirstName(name){
	var nameRegex = /^[-a-z]+$/;
	if(nameRegex.test(name)){
		return true;
	} else {
		return false;
	}
};

function isValidLastName(name){
	var nameRegex = /^[-a-z]+$/;
	if(nameRegex.test(name)){
		return true;
	} else {
		return false;
	}
};

function isValidUserName(username){
	var nameRegex = /^[a-zA-Z0-9]+$/;
	if(nameRegex.test(username)){
		return true;
	} else {
		return false;
	}
};




