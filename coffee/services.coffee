angular.module "app.services", []
.factory "TrainingRecord", (pouchdb) ->
  pouchdb.create("TrainingRecord")
.factory "Style", ->
  getByName: (name) ->
    for style in this.data
      if style.name == name
        return style
  data: [
    {
      id: 'push-up'
      name: "俯卧撑"
      level: [
        "墙壁俯卧撑"
        "上斜俯卧撑"
        "膝盖俯卧撑"
        "半俯卧撑"
        "标准俯卧撑"
        "窄距俯卧撑"
        "偏重俯卧撑"
        "单臂半俯卧撑"
        "杠杆俯卧撑"
        "单臂俯卧撑"
      ]
    }
    {
      id: 'full-squat'
      name: "深蹲"
      level: [
        "肩倒立深蹲"
        "折刀深蹲"
        "支撑深蹲"
        "半深蹲"
        "标准深蹲"
        "窄距深蹲"
        "偏重深蹲"
        "单腿半深蹲"
        "单腿辅助深蹲"
        "单腿深蹲"
      ]
    }
    {
      id: "pull-up"
      name: "引体向上"
      level: [
        "垂直引体向上"
        "水平引体向上"
        "折刀引体向上"
        "半引体向上"
        "标准引体向上"
        "窄距引体向上"
        "偏重引体向上"
        "单臂半引体向上"
        "单臂辅助引体向上"
        "单臂引体向上"
      ]
    }
    {
      id: "leg-lift"
      name: "举腿"
      level: [
        "坐姿屈膝举腿"
        "平卧抬膝举腿"
        "平卧屈举腿"
        "平卧蛙举腿"
        "平卧直举腿"
        "悬垂屈膝举腿"
        "悬垂屈举腿"
        "悬垂蛙举腿"
        "悬垂半举腿"
        "悬垂直举腿"
      ]
    }
    {
      id: "bridge"
      name: "桥"
      level: [
        "短桥"
        "直桥"
        "高低桥"
        "顶桥"
        "半桥"
        "标准桥"
        "下行桥"
        "上行桥"
        "合桥"
        "铁板桥"
      ]
    }
    {
      id: "handstand"
      name: "倒立撑"
      level: [
        "靠墙顶立"
        "乌鸦式"
        "靠墙倒立"
        "半倒立撑"
        "标准倒立撑"
        "窄距倒立撑"
        "偏重倒立撑"
        "单臂半倒立撑"
        "杠杆倒立撑"
        "单臂倒立撑"
      ]
    }
  ]
.factory "db", (TrainingRecord)->
  db = TrainingRecord
  return {
    dateFormat: (date)->
      if date instanceof Date
        date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate()
      else
        date
    create: (date, data)->
      date = this.dateFormat(date)
      db.put({
        _id: date
        data: data
      })
    update_or_create: (date, data, image)->
      date = this.dateFormat(date)
      db.get(date).then (d)->
        if !(d.data instanceof Array)
          d.data = []
        exists = false
        for k, v of d.data
          if d.data[k].style == data.style && d.data[k].level == data.level
            d.data[k].sets = data.sets
            d.data[k].times = data.times
            exists = true
            break
        if !exists
          d.data.push data
        d.image = image if image
        db.put({
          _id: date
          _rev: d._rev
          data: d.data
          image: d.image
        })
      , (err)->
        db.put({
          _id: date
          data: [data]
          image: image
        })
      .catch (error)->
        console.log error
    get: (date, cb)->
      db.get(date, cb)
  }
