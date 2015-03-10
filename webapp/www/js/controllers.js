app.controller('MainCtrl', function($scope, $resource) {
    
    var Movies = $resource('http://localhost:3000/api/movies');

    Movies.query(function(results) {
        $scope.movies = results;
    })
    
    $scope.refresh = function() {
        $scope.$broadcast('scroll.refreshComplete');
    };
    
})