#$ = require "jquery"

this.restrain_html = (restrain_json) ->
  [
    restrain_example_html(restrain_json),
    restrain_figure_html(restrain_json)
  ]

restrain_example_html = (restrain_json)->
  ids = restrain_ids restrain_json
  a = $ "<a></a>"
  a.addClass "list-group-item"
  for id in ids
    a.append restrain_img_html id
  a

restrain_img_html = (id) ->
  "<img src='http://cdn233.my-card.in/ygopro/pics/thumbnail/#{id}.jpg'>"

restrain_ids = (restrain_json) ->
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

restrain_figure_html = (restrain_json) ->
  a = $ "<a></a>"
  a.addClass "list-group-item disabled"
  a.append restrain_type_html restrain_json
  a.append restrain_range_html restrain_json.range
  a.append restrain_condition_html restrain_json.condition, restrain_json.type
  a

restrain_condition_html = (condition_json, type)->
  operator = condition_json.operator
  number = condition_json.number
  " <code>#{operator}</code> <kbd class='#{type}'>#{number}</kbd>"

restrain_range_html = (range_json)->
  if range_json == "all"
    ""
  else
    " <kbd class=\"#{range_json}\">#{range_json}</kbd>"

restrain_type_html = (restrain_json) ->
  type = restrain_json.type
  name = restrain_json.name
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
  jq = restrain_html ex[index].restrain
  $('div.row:last').append jq