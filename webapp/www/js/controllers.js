app.controller('MainCtrl', function($scope, $resource, $http, $window, $ionicModal, toaster) {
    
    var Movie = $resource('http://localhost:3000/api/movies');
    
    $http.post('/authenticate', {username: "hannes", password: "password"})
      .success(function (data, status, headers, config) {
        $window.sessionStorage.token = data.token;
      })
      .error(function (data, status, headers, config) {
        delete $window.sessionStorage.token;
      });
    
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
                    toaster.pop({type: 'error', title: "Slettet film", body:"Film " + movie.title + " er slettet"});
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
    
    $scope.add = function(newMovie) {
        
        var found = false;
        
        if (newMovie === undefined) {
            newMovie = movies[Math.floor((Math.random() * movies.length))];
        }
        
        for (var i = 0; i < $scope.movies.length; i++) {
            console.log($scope.movies[i].title === newMovie.title);
            if ($scope.movies[i].title === newMovie.title) {
                toaster.pop({type: 'error', title: "Finnes allerede", body:"Filmen " + $scope.movies[i].title + " finnes allerede, prøv på nytt"});
                found = true;
                $scope.closeModal();
                return;

            }
        }
        
        if (!found) {
            var movie = new Movie();
            movie.title = newMovie.title;
            movie.director = newMovie.director;
            movie.date = new Date();
            movie.poster = newMovie.poster;
            movie.rating = newMovie.rating;
            movie.$save();
            $scope.closeModal();
        }   
        
        found = false;   
    }
    
    $ionicModal.fromTemplateUrl('templates/add-modal.html', {
        scope: $scope,
        animation: 'slide-in-up'
      }).then(function(modal) {
        $scope.modal = modal;
      });
      $scope.openModal = function() {
        $scope.modal.show();
      };
      $scope.closeModal = function() {
        $scope.modal.hide();
      };
    
    var movies = [
        {"title":"Airplane!",
         "director":"Jim Abrahams",
         "rating":"7.7",
         "poster":"http://ia.media-imdb.com/images/M/MV5BNDU2MjE4MTcwNl5BMl5BanBnXkFtZTgwNDExOTMxMDE@._V1_SX214_AL_.jpg"
        },
        {"title":"Kingsman",
         "director":"Matthew Vaughn",
         "rating":"8.2",
         "poster":"http://ia.media-imdb.com/images/M/MV5BMTkxMjgwMDM4Ml5BMl5BanBnXkFtZTgwMTk3NTIwNDE@._V1_SY317_CR0,0,214,317_AL_.jpg"
        },
        {"title":"Taken",
         "director":"Pierre Morel",
         "rating":"7.9",
         "poster":"http://ia.media-imdb.com/images/M/MV5BMTM4NzQ0OTYyOF5BMl5BanBnXkFtZTcwMDkyNjQyMg@@._V1_SX214_AL_.jpg"
        },
        {"title":"The Dark Knight",
         "director":"Christopher Nolan",
         "rating":"9.0",
         "poster":"http://ia.media-imdb.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SY317_CR0,0,214,317_AL_.jpg"
        },
        {"title":"Kick-Ass",
         "director":"Matthew Vaughn",
         "rating":"7.7",
         "poster":"http://ia.media-imdb.com/images/M/MV5BMTMzNzEzMDYxM15BMl5BanBnXkFtZTcwMTc0NTMxMw@@._V1_SX214_AL_.jpg"
        },
        {"title":"Layer Cake",
         "director":"Matthew Vaughn",
         "rating":"7.4",
         "poster":"http://ia.media-imdb.com/images/M/MV5BMTI5MTE1OTAzOV5BMl5BanBnXkFtZTcwNDc2OTgyMQ@@._V1_SX214_AL_.jpg"
        },
        {"title":"Shoot 'Em Up",
         "director":"Michael Davis",
         "rating":"6.7",
         "poster":"http://ia.media-imdb.com/images/M/MV5BMjEwMDA1MDUwNl5BMl5BanBnXkFtZTcwMDQzMzM1MQ@@._V1_SY317_CR0,0,214,317_AL_.jpg"
        }
    ];
})