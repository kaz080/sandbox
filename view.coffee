
if Ti? # Titanium
  log = Ti.API.debug
  yql = exec: Ti.Yahoo.yql
else # Node
  log = console.log
  yql = require "yql"

# Scrollable container window of fullscreen views.
class FeedScrollableView
  window: null
  title: "FeedView"
  feed: null
  scrollable: null
  full: false
  constructor: (prop) ->
    for key, value of prop
      @[key] = value
  create: ->
    @window = Ti.UI.createWindow
      title: @title
    @scrollable = Ti.UI.createScrollableView
      #showPagingControl: true
      top: 0
      left: 0
      right: 0
      bottom: 0
    @window.add @scrollable
    @window.addEventListener "click", (e) =>
      if @full
        #Ti.UI.iPhone.showStatusBar()
        @full = false
      else
        #Ti.UI.iPhone.hideStatusBar()
        @full = true
    @scrollable.addEventListener "scroll", (e) =>
      log "scroll " + e.currentPage
      return if not @feed?
      if e.currentPage + 1 >= @feed.items.length
        log "Next update."
        @feed.addEventListener "updated", @update
        @feed.update()
    @window
  setFeed: (feed) =>
    @feed = feed
    @feed.addEventListener "updated", @update
    @feed.update()
  update: (e) =>
    e.source.removeEventListener "updated", @update
    # update feed item view
    pages = if @scrollable.views? then @scrollable.views.length else 0
    log "update: start " + pages + " to " + @feed.items.length
    for page in [pages...@feed.items.length]
      item = @feed.items[page]
      log page + ": " + item.image
      imageView = Ti.UI.createImageView
        image: item.image
        height: Ti.UI.FILL
        width: Ti.UI.FILL
        canScale: true
      @scrollable.addView imageView
    log "update: end."

class FeedTableView
  window: null
  title: "FeedView"
  feed: null
  constructor: (prop) ->
    for key, value of prop
      @[key] = value
  create: ->
    @window = Ti.UI.createWindow
      title: @title
    @table = Ti.UI.createTableView
      height: "auto"
      minRowHeight: 40
    @window.add @table
    @window
  setFeed: (feed) =>
    @feed = feed
    @feed.addEventListener "updated", @update
    @feed.update()
  update: (e) =>
    e.source.removeEventListener "updated", @update
    # update feed item view
    data = for item in @feed.items
      log item.title
      label = Ti.UI.createLabel
        text: item.title
        height: "auto"
        width: "auto"
        left: 10
        right: 50
        top: 10
        bottom: 10
      row = Ti.UI.createTableViewRow
        height: "auto"
      row.add label
      row
    @table.setData data

exports.createFeedView = (prop) ->
  new FeedScrollableView prop
