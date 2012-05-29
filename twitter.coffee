###
Prepare env.json, such as:
{
	"auth": "username:password"
}
or,
{
	"twitter_consumer_key": "",
	"twitter_consumer_secret": "",
	"twitter_access_token": "",
	"twitter_access_token_secret": ""
}
Usage:
  coffee twitter soundcloud
###

fs = require "fs"
https = require "https"
url = require "url"
colors = require "colors"

# Create URL
env = JSON.parse fs.readFileSync "env.json"
params =
  track: "spotify"
params.track = process.argv[2] if process.argv.length > 2
query = (for key, value of params
  comp = encodeURIComponent value
  key + "=" + comp).join "&"
streamURL = "https://stream.twitter.com/1/statuses/filter.json?" + query
console.log streamURL

# Create request
if config.auth?
  option = url.parse streamURL
  option.auth = env.auth
  req = https.get option
else
  OAuth = require("oauth").OAuth
  oa = new OAuth(
    "https://twitter.com/oauth/request_token"
    "https://twitter.com/oauth/access_token"
    env.twitter_consumer_key
    env.twitter_consumer_secret
    "1.0A", "http://localhost:3000/oauth/callback", "HMAC-SHA1"
  )
  req = oa.get(
    streamURL
    env.twitter_access_token
    env.twitter_access_token_secret
  )

# Handle request
req.on "error", (e) ->
  console.log e
req.on "response", (res) ->
  buffer = ""
  res.setEncoding "utf8"
  console.log "header: " + JSON.stringify res.headers
  console.log()
  res.on "error", (e) ->
    console.log e
  res.on "data", (chunk) =>
    return if chunk.length is 0
    try
      tweet = JSON.parse(buffer + chunk)
      console.log tweet.text
      console.log tweet.created_at.green
      console.log()
      buffer = ""
    catch e
      console.log e
      # chunk is not enough
      buffer += chunk
      console.log buffer
req.end()
