suite = require "symfio-suite"


describe "contrib-bower()", ->
  it = suite.plugin (container) ->
    container.inject ["suite/container"], require ".."

    container.set "publicDirectory", "/"
    container.set "componentsDirectory", "/components"

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

  describe "container.unless components", ->
    it "should be empty", (unlessed) ->
      factory = unlessed "components"
      factory().should.eventually.have.length 0

  describe "container.unless componentsDirectory", ->
    it "should define", (unlessed) ->
      factory = unlessed "componentsDirectory"
      factory().should.eventually.equal "/bower_components"

  describe "container.set bower", ->
    # speedup test
    require "bower"

    it "should configure componentsDirectory", (setted) ->
      factory = setted "bower"
      factory().then (bower) ->
        bower.config.directory.should.equal "components"

  describe "container.set installBowerComponents", ->
    it "should run installation and pipe bower output",
      (setted, installation, logger) ->
        factory = setted "installBowerComponents"
        factory.dependencies.components = ["jquery"]
        factory().then (installBowerComponents) ->
          installBowerComponents()
          installation.on.should.have.been.calledWith "data"

          listener = installation.on.withArgs("data").firstCall.args[1]
          listener "bower\n"

          logger.info.should.have.been.calledOnce
          logger.info.should.have.been.calledWith "bower"
