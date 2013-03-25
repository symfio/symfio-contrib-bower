crypto = require "crypto"
bower = require "bower"
async = require "async"
path = require "path"
fs = require "fs"


module.exports = (container, callback) ->
  applicationDirectory = container.get "application directory"
  publicDirectory = path.join applicationDirectory, "public"

  publicDirectory = container.get "public directory", publicDirectory
  components = container.get "components", []
  hashFile = path.join applicationDirectory, ".components"
  loader = container.get "loader"
  logger = container.get "logger"

  return callback() if components.length == 0

  logger.info "loading plugin", "contrib-bower"

  hash = crypto.createHash "sha256"

  for component in components
    hash.update component, "utf8"
    hash.update ":", "utf8"

  hashDigest = hash.digest "hex"

  async.series [
    (callback) ->
      componentsDirectory = path.join publicDirectory, "components"

      fs.stat componentsDirectory, (err, stat) ->
        return callback() if err or not stat.isDirectory()

        fs.readFile hashFile, "utf8", (err, previousHash) ->
          return callback previousHash if hashDigest == previousHash
          callback()

    (callback) ->
      cwd = process.cwd()
      process.chdir publicDirectory

      installation = bower.commands.install components

      unless container.get "silent"
        installation.on "data", (data) ->
          console.log data

      installation.on "end", ->
        process.chdir cwd
        callback()

    (callback) ->
      fs.writeFile hashFile, hashDigest, -> callback()

  ], -> callback()
