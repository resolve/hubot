# Description:
#   Checks a Resolve website and tells you what server it's on
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot tell me about <domain> # e.g. resolvedigital.com (no HTTP at front)
#
# Author:
#   djones

module.exports = (robot) ->
  robot.respond /tell me about (.*)/i, (msg) ->
    resolveHosting msg, msg.match[1], (domain) ->
      msg.send domain

resolveHosting = (msg, domain, cb) ->
  dns = require('dns')
  dns.resolve domain, (err, addr, ttl, cname) ->
    if err == null
      msg.http("http://#{addr}/").get() (err, res, body) ->
        if res.statusCode == 200
          server = body.match(/<title>(.+?)<\/title>/)[1]
          cb "#{domain} is hosted with Engine Yard on the #{server}"
        else
          cb "#{domain} is hosted with Heroku"
    else
      cb "#{domain} is invalid."