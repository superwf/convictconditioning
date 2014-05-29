angular.module("app.controllers", [])
.controller "MenuCtrl", ($scope, $state, Style) ->
  $scope.Style = Style

  return
.controller "LevelCtrl", ($scope, $stateParams, Style, db) ->
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
    db.update_or_create(date, data)
  null
.controller "StyleCtrl", ($scope, $stateParams, Style) ->
  $scope.style = Style.getByName($stateParams.style)
  null
.controller "RecordCtrl", ($scope, TrainingRecord) ->
  $scope.records = TrainingRecord

  $scope.delete = (record) ->
    TrainingRecord.remove record
  null
