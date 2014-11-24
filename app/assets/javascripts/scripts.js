var resultsPlaceholder = document.getElementById('results'),
    playingCssClass = 'playing',
    audioObject = null;
	

var fetchTracks = function (albumId, callback) {
    $.ajax({
        url: 'https://api.spotify.com/v1/albums/' + albumId,
        success: function (response) {
            callback(response);
        }
    });
};

// var searchArtist = function (query, that) {
//     $.ajax({
//         url: 'https://api.spotify.com/v1/search',
//         data: {
//             q: query,
//             type: 'artist'
//         },
//         success: function (response) {
//             if artist_api_response["artists"]["items"] === [] {
//                 $("#search-error-msg").html("this artist does not exist")
//             }
//             else that.unbind('submit').submit()
//         }
//     });
// };

$(function(){
   var results = $('.cover')
    results.on('click', function(e) {
        // debugger;        
        var target = e.target;
        if (target !== null && target.classList.contains('cover')) {
            if (target.classList.contains(playingCssClass)) {
                audioObject.pause();

            } else {
                if (audioObject) {
                    audioObject.pause();
                }
                fetchTracks(target.getAttribute('data-album-id'), function(data) {            
                    audioObject = new Audio(data.tracks.items[0].preview_url);
                    audioObject.play();
                    target.classList.add(playingCssClass);
                    audioObject.addEventListener('ended', function() {
                        target.classList.remove(playingCssClass);
                    });
                    audioObject.addEventListener('pause', function() {
                        target.classList.remove(playingCssClass);
                   });
                });
            }
        }
    });
    // $("#search-form").submit(function (e) {
    //     e.preventDefault();
    //     var that = this
    //     searchArtist($("#query").value, that);
    // }, false)   ;
});





