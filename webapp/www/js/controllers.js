app.controller('MainCtrl', function($scope, $resource, toaster) {
    
    var Movie = $resource('http://localhost:3000/api/movies');
    
    function getMovies() {
         Movie.query(function(results) {
            $scope.movies = results;
        });
    }
    
    getMovies();
    
    $scope.refresh = function() {
        getMovies();
        $scope.$broadcast('scroll.refreshComplete');
    };
    
    $scope.$on('ws:new_movie', function(_, movie) {
        $scope.$apply(function() {
            $scope.movies.unshift(movie);
            toaster.success({title: "Ny film", body:"Film " + movie.title + " ble lagt til"});

        })
    });
    
    $scope.$on('ws:delete_movie', function(_, movie) {
        $scope.$apply(function() {
            angular.forEach($scope.movies, function(val, key) {
                if (val._id === movie._id) {
                    $scope.movies.splice($scope.movies.indexOf(val), 1);
                    toaster.pop({type: 'error', title: "Ta bort", body:"Film " + movie.title + " er tatt bort"});
                    return;
                }
            })
        })
    });
    
    $scope.delete = function(movie, index) {   
       Movie.remove({id: movie._id}, function() {
        for (var i = 0; i < $scope.movies.length; i++) {
            if (movie._id === $scope.movies[i]._id) {
                $scope.movies.splice(i, 1);
            }
        }
       });
    }
    
    $scope.add = function() {
        var movie = new Movie();
        movie.title = "test";
        movie.director = "test";
        movie.rating = "9.5";
        movie.date = new Date();
        movie.poster = "http://www.impawards.com/2003/posters/identity_xlg.jpg";
        
        movie.$save();
    }
    
})