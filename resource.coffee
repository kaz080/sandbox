#

if Ti? # Titanium
  log = Ti.API.debug
  yql = exec: Ti.Yahoo.yql
else # Node
  log = console.log
  yql = require "yql"

class Event
  source: null # a Proxy
  type: ""
  listener: null
  constructor: (@type, @source, @listener) ->

class Proxy
  listeners: {}
  debug: (message) ->
    log message + " " + JSON.stringify @listeners
  addEventListener: (type, callback) ->
    @listeners[type] = [] if @listeners[type] is undefined
    @listeners[type].push callback
    @debug "Added"
  removeEventListener: (type, callback) ->
    if @listeners[type] is undefined
      @debug "No type: " + type
      return
    index = @listeners[type].indexOf callback
    @listeners[type] = @listeners[type].splice index, 1
    @debug "Removed"
  fireEvent: (type, option) ->
    if @listeners[type] is undefined
      @debug "No listener: " + type
      return
    event = new Event type, this
    for key, value of option
      event[key] = value
    for listener in @listeners[type]
      event.listener = listener
      listener event if listener?

extractImage = (html) ->
  matches = html.match /img src="([^"]+)"/
  if matches.length < 2
  	return ""
  matches[1]

class Feed extends Proxy
  url: ""
  items: []
  page: 1
  constructor: (prop) ->
    for key, value of prop
      @[key] = value
  fireEvent: ->
    super
  update: ->
    #url = "#{ @url }&page=#{ @page }";
    url = @url
    query = "SELECT * FROM feed WHERE url='#{ url }'"
    log query
    yql.exec query, (d) =>
      items = d.data?.item
      items ?= d.query?.results?.item
      for item in items
        try
          entry =
            link: item.link ? item.link
            title: item.title ? item.title
            description: item.description ? item.description
            guid: item.guid?.content ? item.guid?.content
            image: item.content?.url ? item.content?.url
            thumbnail: item.thumbnail?.url ? item.thumbnail?.url
          if not entry.image?
            url = extractImage entry.description
            entry.image = url
            entry.thumbnail = url
        catch e
          log e.message
          log JSON.stringify item, null, 2
          return
        @items.push entry
        log JSON.stringify @items, null, 2
      # TODO: How to call super method?
      @fireEvent "updated", {data: @items}
      @page++

exports.createFeed = (prop) ->
  new Feed prop
