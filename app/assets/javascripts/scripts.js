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

$(function(){
   var results = $('.cover')
    results.on('click', function(e) {      
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
    // $("#search-form").bind("submit", function(e) {
    //     e.preventDefault();
    //     $.ajax({
    //         url: 'https://api.spotify.com/v1/search',
    //         method: 'get',
    //         data: {
    //             q: $("#query").val(),
    //             type: 'artist'
    //             },
    //         success: function (response) {
    //             if (response["artists"]["items"].length === 0) {
    //                 $("#search-error-msg").html("this artist does not exist")
    //                 }
    //             else {
    //                 $("#search-form").unbind('submit').submit()
    //                 }
    //             }
    //        });
    //     });
    // $(".search-query").bind("submit", function(e) {
    //     e.preventDefault();
    //     $.ajax({
    //         url: 'https://api.spotify.com/v1/search',
    //         method: 'get',
    //         data: {
    //             q: $(".search-query").val(),
    //             type: 'artist'
    //             },
    //         success: function (response) {
    //             if (response["artists"]["items"].length === 0) {
    //                 $(".search-error-msg").html("this artist does not exist")
    //                 }
    //             else {
    //                 $(".search-query").unbind('submit').submit()
    //                 }
    //             }
    //        });
    //     });
});

