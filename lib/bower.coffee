module.exports = (container) ->
  container.require "path"

  container.unless "components", []

  container.unless "componentsDirectory", (publicDirectory, path) ->
    path.join publicDirectory, "bower_components"

  container.set "bower", (componentsDirectory, logger, path) ->
    logger.debug "require module", name: "express"
    bower = require "bower"
    bower.config.directory = path.basename componentsDirectory
    bower

  container.set "installBowerComponents",
    (logger, componentsDirectory, components, bower, w, path) ->
      ->
        return if components.length is 0

        deffered = w.defer()

        oldCwd = process.cwd()
        process.chdir path.dirname componentsDirectory

        emitter = bower.commands.install components

        emitter.on "data", (data) ->
          logger.info data.trim()

        emitter.on "warn", (data) ->
          logger.warn data.trim()

        emitter.on "error", ->

        emitter.on "end", ->
          process.chdir oldCwd
          deffered.resolve()

        deffered.promise
