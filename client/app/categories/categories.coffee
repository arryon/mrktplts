'use strict'

angular.module 'mrktplaatsApp'
.config ($stateProvider) ->
  $stateProvider.state 'categories',
    url: '/'
    templateUrl: 'app/categories/categories.html'
    controller: 'CategoriesCtrl'
  .state 'categories.search',
    url: 'search?term&category&zipcode&distance&from&to'
    templateUrl: 'app/categories/search.html'
    controller: 'SearchCtrl'
