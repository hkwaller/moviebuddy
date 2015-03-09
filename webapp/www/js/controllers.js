app.controller('MainCtrl', function($scope, $resource) {
    
    var Product = $resource('http://127.0.0.1:3000/api/list');

    Product.query(function(results) {
        $scope.movies = results;
        console.log($scope.movies);
    })
    
    $scope.refresh = function() {
        $scope.$broadcast('scroll.refreshComplete');
    };
    
})