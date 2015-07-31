'use strict'

angular.module 'mrktplaatsApp'
.config ($stateProvider) ->
  $stateProvider.state 'categories',
    url: '/'
    templateUrl: 'app/categories/categories.html'
    controller: 'CategoriesCtrl'
  .state 'categories.search',
    url: 'search'
    templateUrl: 'app/categories/search.html'
