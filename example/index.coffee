symfio = require "symfio"
fs = require "fs.extra"

module.exports = container = symfio "example", __dirname
container.set "public directory", __dirname
container.set "components", ["jquery"]

loader = container.get "loader"
loader.use require "symfio-contrib-express"
loader.use require "symfio-contrib-assets"
loader.use require "../lib/bower"

loader.use (container, callback) ->
  unloader = container.get "unloader"

  unloader.register (callback) ->
    fs.remove "#{__dirname}/.components", ->
      fs.remove "#{__dirname}/components", ->
        callback()

  callback()

loader.load() if require.main is module
