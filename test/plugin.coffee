suite = require "symfio-suite"


describe "contrib-bower()", ->
  it = suite.plugin [
    (container, containerStub) ->
      require("..") containerStub

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
    it "should be empty", (containerStub) ->
      containerStub.unless.get("components").should.have.length 0

  describe "container.unless componentsDirectory", ->
    it "should define", (containerStub) ->
      factory = containerStub.unless.get "componentsDirectory"
      factory("/").should.equal "/bower_components"

  describe "container.set bower", ->
    # speedup test
    require "bower"

    it "should configure componentsDirectory", (containerStub) ->
      factory = containerStub.set.get "bower"
      bower = factory("/noop")
      bower.config.directory.should.equal "noop"

  it "should run installation and pipe bower output",
    (containerStub, logger, bower, installation) ->
      factory = containerStub.inject.get 0

      factory(logger, "/", ["jquery"], bower).then ->
        installation.on.should.have.been.calledWith "data"

        listener = installation.on.withArgs("data").firstCall.args[1]
        listener "bower\n"

        logger.info.should.have.been.calledOnce
        logger.info.should.have.been.calledWith "bower"
