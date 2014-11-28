// this is great.  this function might more appropriately be titles
// setLikeButtonHandler ... or something to indicate that its
// not actually creating a like, but is setting event handlers
// on a button.

$(function(){


	createLike();



})




function createLike(){
	var $artist_name = $("#artist-name").text();
	var $image_url = $("#artist-image").attr("src");
	var artist_url = document.URL
	var $user_id = parseInt($(".btn-default").attr("id"));

	$(".btn-default").on("click", function(){
		$.ajax({
			url: "/likes",
			method: "post",
			dataType: "json",
			data: {image_url: $image_url, artist_name: $artist_name, artist_url: artist_url, user_id: $user_id},
			success: function(data){
				console.log(data.message)
				$(".btn-default").addClass("btn-success").removeClass("btn-default");
				$(".btn-success").text("Liked!");
			}
		})

	})

}