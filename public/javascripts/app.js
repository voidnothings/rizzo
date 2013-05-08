
angular.module('StyleSheetApp', []).
    config(['$routeProvider', function($routeProvider) {
    $routeProvider.
        when('/components', {templateUrl: 'partials/components.html',   controller: StyleSheetCtrl}).
        otherwise({redirectTo: '/components'});
}]);
