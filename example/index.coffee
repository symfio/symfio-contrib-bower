symfio = require "symfio"
nodefn = require "when/node/function"
fs = require "fs.extra"

module.exports = container = symfio "example", __dirname

container.set "publicDirectory", __dirname
container.set "components", ["jquery"]

container.use ->
  nodefn.call fs.remove, "#{__dirname}/bower_components"

container.use require "symfio-contrib-winston"
container.use require "symfio-contrib-express"
container.use require "symfio-contrib-assets"
container.use require ".."

container.load() if require.main is module
