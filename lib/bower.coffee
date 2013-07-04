path = require "path"
w = require "when"


module.exports = (container) ->
  container.unless "components", []

  container.unless "componentsDirectory",
    (publicDirectory, applicationDirectory) ->
      if publicDirectory
        path.join publicDirectory, "bower_components"
      else
        path.join applicationDirectory, "bower_components"

  container.set "bower", (componentsDirectory) ->
    bower = require "bower"
    bower.config.directory = path.basename componentsDirectory
    bower


  container.call (logger, componentsDirectory, components, bower) ->
    deffered = w.defer()

    oldCwd = process.cwd()
    process.chdir path.dirname componentsDirectory

    emitter = bower.commands.install components

    emitter.on "data", (data) ->
      logger.info data.trim().replace /\033\[[0-9;]*m/g, ""

    emitter.on "warn", (data) ->
      logger.warn data.trim().replace /\033\[[0-9;]*m/g, ""

    emitter.on "error", ->

    emitter.on "end", ->
      process.chdir oldCwd
      deffered.resolve()

    deffered.promise
