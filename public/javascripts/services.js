angular.module('StyleSheetAppServices', ['ngResource']).

    factory('Thingy', function($resource) {
        return $resource('components.json', {}, {
            query: {method:'GET', params:{}, isArray:true}
        });

    });