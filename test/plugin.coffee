suite = require "symfio-suite"


describe "contrib-bower()", ->
  it = suite.plugin [
    require ".."

    (container) ->
      container.set "publicDirectory", __dirname
      container.set "components", ["jquery"]

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

  it "should pipe bower output", (logger, installation) ->
    installation.on.should.have.been.calledWith "data"

    listener = installation.on.withArgs("data").firstCall.args[1]
    listener "bower\n"

    logger.info.should.have.been.calledOnce
    logger.info.should.have.been.calledWith "bower"
