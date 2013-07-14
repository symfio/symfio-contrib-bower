symfio = require "symfio"
nodefn = require "when/node/function"
fs = require "fs.extra"
w = require "when"


module.exports = container = symfio "example", __dirname

container.set "publicDirectory", __dirname
container.set "components", ["jquery"]

module.exports.promise = container.injectAll([
  require "symfio-contrib-winston"
  require "symfio-contrib-express"
  require "symfio-contrib-assets"

  ->
    nodefn.call(fs.remove, "#{__dirname}/bower_components").then ->
      container.inject require ".."
]).then ->
  container.get ["servePublicDirectory", "installBowerComponents"]
.spread (servePublicDirectory, installBowerComponents) ->
  w.all [
    servePublicDirectory()
    installBowerComponents()
  ]


if require.main is module
  module.exports.promise.then ->
    container.get "startExpressServer"
  .then (startExpressServer) ->
    startExpressServer()
