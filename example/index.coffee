symfio = require "symfio"
nodefn = require "when/node/function"
fs = require "fs.extra"


module.exports = container = symfio "example", __dirname

container.set "publicDirectory", __dirname
container.set "components", ["jquery"]

module.exports.promise = container.injectAll [
  require "symfio-contrib-winston"
  require "symfio-contrib-express"
  require "symfio-contrib-assets"

  ->
    nodefn.call(fs.remove, "#{__dirname}/bower_components").then ->
      container.inject require ".."
]


if require.main is module
  container.get("listener").then (listener) ->
    listener.listen()
