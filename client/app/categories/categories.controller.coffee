'use strict'

angular.module 'mrktplaatsApp'
.controller 'CategoriesCtrl', ($scope, $state, $http, $q) ->
  $scope.master = {}
  $scope.catsLoaded = true
  $scope.categories = [{"name":"Antiek en Kunst","id":"1","url":"http://www.marktplaats.nl/c/antiek-en-kunst/c1.html"},{"name":"Audio, Tv en Foto","id":"31","url":"http://www.marktplaats.nl/c/audio-tv-en-foto/c31.html"},{"name":"Auto&apos;s","id":"91","url":"http://www.marktplaats.nl/c/auto-s/c91.html"},{"name":"Auto-onderdelen","id":"2600","url":"http://www.marktplaats.nl/c/auto-onderdelen/c2600.html"},{"name":"Auto diversen","id":"48","url":"http://www.marktplaats.nl/c/auto-diversen/c48.html"},{"name":"Boeken","id":"201","url":"http://www.marktplaats.nl/c/boeken/c201.html"},{"name":"Caravans en Kamperen","id":"289","url":"http://www.marktplaats.nl/c/caravans-en-kamperen/c289.html"},{"name":"Cd&apos;s en Dvd&apos;s","id":"1744","url":"http://www.marktplaats.nl/c/cd-s-en-dvd-s/c1744.html"},{"name":"Computers en Software","id":"322","url":"http://www.marktplaats.nl/c/computers-en-software/c322.html"},{"name":"Contacten en Berichten","id":"378","url":"http://www.marktplaats.nl/c/contacten-en-berichten/c378.html"},{"name":"Diensten en Vakmensen","id":"1098","url":"http://diensten-vakmensen.marktplaats.nl/c/diensten-en-vakmensen/c1098.html"},{"name":"Dieren en Toebehoren","id":"395","url":"http://www.marktplaats.nl/c/dieren-en-toebehoren/c395.html"},{"name":"Doe-het-zelf en Verbouw","id":"239","url":"http://www.marktplaats.nl/c/doe-het-zelf-en-verbouw/c239.html"},{"name":"Fietsen en Brommers","id":"445","url":"http://www.marktplaats.nl/c/fietsen-en-brommers/c445.html"},{"name":"Hobby en Vrije tijd","id":"1099","url":"http://www.marktplaats.nl/c/hobby-en-vrije-tijd/c1099.html"},{"name":"Huis en Inrichting","id":"504","url":"http://www.marktplaats.nl/c/huis-en-inrichting/c504.html"},{"name":"Huizen en Kamers","id":"1032","url":"http://www.marktplaats.nl/c/huizen-en-kamers/c1032.html"},{"name":"Kinderen en Baby&apos;s","id":"565","url":"http://www.marktplaats.nl/c/kinderen-en-baby-s/c565.html"},{"name":"Kleding | Dames","id":"621","url":"http://www.marktplaats.nl/c/kleding-dames/c621.html"},{"name":"Kleding | Heren","id":"1776","url":"http://www.marktplaats.nl/c/kleding-heren/c1776.html"},{"name":"Motoren","id":"678","url":"http://www.marktplaats.nl/c/motoren/c678.html"},{"name":"Muziek en Instrumenten","id":"728","url":"http://www.marktplaats.nl/c/muziek-en-instrumenten/c728.html"},{"name":"Postzegels en Munten","id":"1784","url":"http://www.marktplaats.nl/c/postzegels-en-munten/c1784.html"},{"name":"Sieraden en Tassen","id":"1826","url":"http://www.marktplaats.nl/c/sieraden-tassen-en-uiterlijk/c1826.html"},{"name":"Spelcomputers, Games","id":"356","url":"http://www.marktplaats.nl/c/spelcomputers-en-games/c356.html"},{"name":"Sport en Fitness","id":"784","url":"http://www.marktplaats.nl/c/sport-en-fitness/c784.html"},{"name":"Telecommunicatie","id":"820","url":"http://www.marktplaats.nl/c/telecommunicatie/c820.html"},{"name":"Tickets en Kaartjes","id":"1984","url":"http://www.marktplaats.nl/c/tickets-en-kaartjes/c1984.html"},{"name":"Tuin en Terras","id":"1847","url":"http://www.marktplaats.nl/c/tuin-en-terras/c1847.html"},{"name":"Vacatures","id":"167","url":"http://www.marktplaats.nl/c/vacatures/c167.html"},{"name":"Vakantie","id":"856","url":"http://www.marktplaats.nl/c/vakantie/c856.html"},{"name":"Verzamelen","id":"895","url":"http://www.marktplaats.nl/c/verzamelen/c895.html"},{"name":"Watersport en Boten","id":"976","url":"http://www.marktplaats.nl/c/watersport-en-boten/c976.html"},{"name":"Witgoed en Apparatuur","id":"537","url":"http://www.marktplaats.nl/c/witgoed-en-apparatuur/c537.html"},{"name":"Zakelijke goederen","id":"1085","url":"http://www.marktplaats.nl/c/zakelijke-goederen/c1085.html"},{"name":"Diversen","id":"428","url":"http://www.marktplaats.nl/c/diversen/c428.html"}]
  $scope.searching = false
  $scope.results = undefined
  $scope.selected = []

  $scope.catFromId = (id) ->
    _.findWhere($scope.categories, {id: id})

  $scope.selectAll = ->
    $scope.selected = $scope.categories.map (item) -> item.id
    return

  $scope.selectNone = ->
    $scope.selected = []
    return

  $scope.search = (form) ->
    console.info _.unique($scope.selected).length, $scope.selected.length
    $scope.searching = true
    $scope.master = angular.copy form

    $state.go('categories.search')
    $scope.results = {}

    $scope.selected.forEach (id) ->
      $scope.results[id] = {
        loaded: false
        ads: []
      }
      $scope.getResults id, form
      .then (results) ->
        $scope.results[id].loaded = true
        $scope.results[id].ads = results
        return
      return

    return

  $scope.reset = ->
    $scope.form = angular.copy $scope.master
    return

  $scope.noTerm = ->
    $scope.master == {}

  $scope.hasResults = ->
    $scope.results != undefined

  $scope.getResults = (id, form) ->
    deferred = $q.defer()
    $http.post '/search',
      category: id
      zipcode: form.zipcode
      term: form.term
      distance: form.distance
      priceFrom: form.from
      priceTo: form.to
    .success (data, status, headers, config) ->
      deferred.resolve data
      return
    .error (data) ->
      deferred.reject data
      return

    deferred.promise

  $scope.selectAll()
  $scope.reset()
  ###$http.get '/allcategories'
  .success (data) ->
    console.info data
    $scope.categories = data
    cat.selected = true for cat in $scope.categories
    $scope.catsLoaded = true
    return
  ###
  return
