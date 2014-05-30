angular.module("app.controllers", [])
.controller "MenuCtrl", ($scope, $state, Style, $window) ->
  if $window.localStorage.convict
    $scope.convict = {
      name: $window.localStorage.convict
    }
  $scope.$watch 'convict.name', (c)->
    $window.localStorage.convict = c
  $scope.Style = Style
  return
.controller "LevelCtrl", ($scope, $stateParams, Style, db, $timeout) ->
  $scope.style = Style.getByName($stateParams.style)
  $scope.level = $stateParams.level
  $scope.dateOptions = {
    dateFormat: "yy-mm-dd"
  }
  $scope.training = {
    date: new Date()
    sets: 1
    times: 1
  }
  $scope.saved = false
  $scope.save = ()->
    date = $scope.training.date
    style = $scope.style.name
    level = $scope.level
    data = {
      style: style
      level: level
      sets: $scope.training.sets
      times: $scope.training.times
    }
    $scope.saved = true
    $timeout ->
      $scope.saved = false
    , 1000
    db.update_or_create(date, data)
  null
.controller "StyleCtrl", ($scope, $stateParams, Style) ->
  $scope.style = Style.getByName($stateParams.style)
  null
.controller "RecordCtrl", ($scope, TrainingRecord) ->
  hasMore = true
  map = (d) ->
    emit d._id
  $scope.loadMore = ->
    if !hasMore
      $scope.$broadcast('scroll.infiniteScrollComplete')
      return false
    if $scope.records
      id = $scope.records[$scope.records.length - 1].id
      TrainingRecord.query(map, limit: 2, include_docs: true, descending: true, endkey: id).then (records)->
        if records.rows[1]
          $scope.records.push records.rows[1]
          $scope.$broadcast('scroll.infiniteScrollComplete')
        else
          hasMore = false
    else
      TrainingRecord.query(map, limit: 2, include_docs: true, descending: true).then (records)->
        $scope.records = records.rows
        $scope.$broadcast('scroll.infiniteScrollComplete')
  $scope.$on 'stateChangeSuccess', ->
    $scope.loadMore()

  $scope.delete = (record, i) ->
    TrainingRecord.remove record
    $scope.records.splice(i, 1)
  null
