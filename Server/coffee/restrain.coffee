#$ = require "jquery"

this.restrainHTML = (restrain_json) ->
  [
    restrainExampleHTML(restrain_json),
    restrainFigureHTML(restrain_json)
  ]

restrainExampleHTML = (restrain_json)->
  ids = restrainIds restrain_json
  a = $ "<a></a>"
  a.addClass "list-group-item"
  for id in ids
    a.append restrainImgHTML id
  a

restrainImgHTML = (id) ->
  "<img src='http://cdn233.my-card.in/ygopro/pics/thumbnail/#{id}.jpg'>"

restrainIds = (restrain_json) ->
  type = restrain_json.type
  if type == 'card'
    return Array(restrain_json.condition.number).fill restrain_json.id
  else if type == 'set'
    ids = restrain_json.set.ids.slice 0
    number = restrain_json.condition.number
    if number < ids.length
      return ids.slice 0, number
    else if numbers <= ids.length * 2
      return ids.times(2).slice 0, number
    else
      return ids.times(3).slice 0, number

restrainFigureHTML = (restrain_json) ->
  a = $ "<a></a>"
  a.addClass "list-group-item disabled"
  a.append restrainTypeHTML restrain_json
  a.append restrainRangeHTML restrain_json.range
  a.append restrainConditionHTML restrain_json.condition, restrain_json.type
  a

restrainConditionHTML = (condition_json, type)->
  operator = condition_json.operator
  number = condition_json.number
  " <code>#{operator}</code> <kbd class='#{type}'>#{number}</kbd>"

restrainRangeHTML = (range_json)->
  if range_json == "all"
    ""
  else
    " <kbd class=\"#{range_json}\">#{range_json}</kbd>"

restrainTypeHTML = (restrain_json) ->
  type = restrain_json.type
  name = restrain_json.name['zh-CN']
  "<kbd class='#{type}'>#{name}</kbd>"

###
      <div class="row">
        <div class="col-md-4">
            <div class="bs-example">
                <img src="http://cdn233.my-card.in/ygopro/pics/thumbnail/60473572.jpg">
                <img src="http://cdn233.my-card.in/ygopro/pics/thumbnail/33256280.jpg">
                <img src="http://cdn233.my-card.in/ygopro/pics/thumbnail/7868571.jpg">
                <img src="http://cdn233.my-card.in/ygopro/pics/thumbnail/69351984.jpg">
                <img src="http://cdn233.my-card.in/ygopro/pics/thumbnail/18716735.jpg">
            </div>
            <figure class="highlight">
                <kbd class="set">炼装</kbd> <code>>=</code> <kbd class="set">5</kbd>
            </figure>
        </div>
    </div>
###

Array.prototype.times = (times) ->
  answer = []
  for item in this
    Array.prototype.push.apply answer, Array(times).fill(item)
  answer

this.help = (index)->
  jq = restrainHTML ex[index].restrain
  $('div.row:last').append jq