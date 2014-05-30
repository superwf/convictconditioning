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

.controller "LevelCtrl", ($scope, $stateParams, Style, db, $timeout, TrainingRecord, $location) ->
  ionic.onGesture "dragleft", ->
    console.log 'left'
    $location.path("#/app/home")
  , jQuery('ion-view.level').get(0)
  $scope.style = Style.getByName($stateParams.style)
  $scope.level = $stateParams.level
  $scope.dateOptions = {
    dateFormat: "yy-mm-dd"
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
    console.log data
    return
    $timeout ->
      $scope.saved = false
    , 1000
    db.update_or_create(date, data, $scope.image)
    $scope.saved = true
    #navigator.notification.vibrate(100)

  # if this level data exists, get it
  $scope.training = {
    date: new Date()
    sets: 1
    times: 1
  }
  $scope.image = null
  TrainingRecord.get db.dateFormat(new Date()), (error, d)->
    if d && d.data
      for st in d.data
        if st.style == $scope.style.name && st.level == $scope.level
          $scope.$apply ->
            $scope.training.sets = st.sets
            $scope.training.times = st.times
            $scope.image = d.image if d.image
          break

  # take picture
  $scope.getPicture = ->
    navigator.camera.getPicture (imageURI)->
      $scope.image = imageURI
      db.get $scope.training.date, (error, d) ->
        if d
          db.put({
            _id: d.id
            _rev: d._rev
            data: d.data
            image: imageURI
          })
        else
          db.put({
            _id: date
            data: []
            image: imageURI
          })
    , (error)->
      $scope.error = error
    ,quality: 50, destinationType: Camera.DestinationType.FILE_URI

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
      navigator.notification.vibrate(100)
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

