# Test code for resource.
# npm install
# coffee test

resource = require "./resource"

feed = resource.createFeed
  url: "http://pinterest.com/kaz080/feed.rss"
  #url: "http://rss.stagram.tk/feed.php?id=287939&username=kaz080&rss"

feed.update()
