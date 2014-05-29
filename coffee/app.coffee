# Ionic App

# angular.module is a global place for creating, registering and retrieving Angular modules
# 'app' is the name of this angular module example (also set in a <body> attribute in index.html)
# the 2nd parameter is an array of 'requires'
# 'app.controllers' is found in controllers.js

# Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
# for form inputs)

# org.apache.cordova.statusbar required
angular.module("convictConditioning", [
  "ionic"
  "app.services"
  "app.controllers"
  "ui.date"
  "pouchdb"
]).run(($ionicPlatform, $window) ->
  $ionicPlatform.ready ->
    cordova.plugins.Keyboard.hideKeyboardAccessoryBar true  if $window.cordova and $window.cordova.plugins.Keyboard
    StatusBar.styleDefault() if $window.StatusBar
    return

  return
).config ($stateProvider, $urlRouterProvider) ->
  $stateProvider.state("app",
    url: "/app"
    abstract: true
    templateUrl: "views/menu.html"
    controller: "MenuCtrl"
  ).state("app.style",
    url: "/style/:style"
    views:
      menuContent:
        templateUrl: "views/style.html"
        controller: "StyleCtrl"
  ).state("app.level",
    url: "/level/:style/:level"
    views:
      menuContent:
        templateUrl: "views/level.html"
        controller: "LevelCtrl"
  ).state("app.record",
    url: "/record"
    views:
      menuContent:
        templateUrl: "views/record.html"
        controller: "RecordCtrl"
  ).state("app.home",
    url: "/home"
    views:
      menuContent:
        templateUrl: "views/home.html"
  ).state "app.single",
    url: "/playlists/:playlistId"
    views:
      menuContent:
        templateUrl: "views/playlist.html"
        controller: "PlaylistCtrl"

  
  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise "/app/home"
  return
