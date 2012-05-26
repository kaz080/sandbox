
if console is undefined
  console = {}
  console.log = Ti.API.debug

App = {}
do ->
  # Load Modules
  view = require("view")
  resource = require("resource")

  # Create initial instances
  App.feedView = view.createFeedView
    title: "Feed"
  App.feedView.create()
  
  # Create initial event routing

  # Show up initial UI
  App.feedView.window.open();

  # Do Test
  feed = resource.createFeed
    url: "http://pinterest.com/kaz080/feed.rss"
    #url: "http://rss.stagram.tk/feed.php?id=287939&username=kaz080&rss"
  App.feedView.setFeed feed
