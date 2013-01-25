
function StyleSheetCtrl($scope, Thingy) {
    $scope.sections = Thingy.query();

    $scope.thing = 'Hello';

}

//StyleSheetCtrl.$inject = ['$scope', 'Components'];
