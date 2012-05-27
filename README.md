# This is experimental code for Titainum Mobile.

These files are in Resources/rvp directory in Titanium Mobile project.

## Usage for Node

	npm install -g coffee-script
    npm install
    coffee test

## Usage for Titanium

1. Create new Titanium Mobile project.

2. Get module.
    git submodule add git@github.com:kaz080/sandbox Resources/rvp

3. Run coffee compiler.
    coffee -wc Resources/

4. Replace app.js to app.coffee.
    view = require("rvp/view")
    resource = require("rvp/resource")

    feedView = view.createFeedView
      title: "Feed"
    feedView.create()
    feedView.window.open();

    feed = resource.createFeed
      url: "http://rss.stagram.tk/feed.php?id=287939&username=kaz080&rss"
    feedView.setFeed feed

5. Run debugger.
