# This is experimental code for Titainum Mobile.

These files are in Resources/rvp directory in Titanium Mobile project.

    git submodule add git@github.com:kaz080/sandbox Resources/rvp

## Usage for Node

    npm install
    coffee test

## Usage for Titanium

app.coffee

    view = require("rvp/view")
    resource = require("rvp/resource")

    feedView = view.createFeedView
      title: "Feed"
    feedView.create()
    feedView.window.open();

    feed = resource.createFeed
      url: "http://rss.stagram.tk/feed.php?id=287939&username=kaz080&rss"
    feedView.setFeed feed
