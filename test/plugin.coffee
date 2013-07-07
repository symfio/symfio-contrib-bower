plugin = require ".."
suite = require "symfio-suite"


describe "contrib-bower()", ->
  it = suite.plugin [
    plugin

    (container) ->
      container.set "publicDirectory", __dirname

      container.set "installation", (sandbox) ->
        installation = on: sandbox.stub()
        installation.on.withArgs("end").yields()
        installation

      container.set "bower", (installation, sandbox) ->
        bower = commands: install: sandbox.stub()
        bower.commands.install.returns installation
        bower

      container.inject (sandbox) ->
        sandbox.stub process, "chdir"
  ]

  describe "container.unless components", ->
    it "should be empty", (components) ->
      components.should.have.length 0

  describe "container.unless componentsDirectory", ->
    it "should define", (componentsDirectory) ->
      componentsDirectory.should.equal "#{__dirname}/bower_components"

  describe "container.set bower", ->
    it "should configure componentsDirectory", (container) ->
      container.set "componentsDirectory", "/noop"

      container.inject(plugin).then ->
        container.get "bower"
      .then (bower) ->
        bower.config.directory.should.equal "noop"

  it "should run installation and pipe bower output",
    (container, logger, installation) ->
      container.set "components", ["jquery"]

      container.inject (sandbox) ->
        sandbox.stub container, "set"
      .then ->
        container.inject plugin
      .then ->
        installation.on.should.have.been.calledWith "data"

        listener = installation.on.withArgs("data").firstCall.args[1]
        listener "bower\n"

        logger.info.should.have.been.calledOnce
        logger.info.should.have.been.calledWith "bower"
