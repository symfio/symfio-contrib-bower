symfio = require "symfio"
sinon = require "sinon"
chai = require "chai"


describe "contrib-bower plugin", ->
  chai.use require "chai-as-promised"
  chai.use require "sinon-chai"
  chai.should()

  installation = null
  container = null
  sandbox = null

  beforeEach (callback) ->
    container = symfio "test", __dirname

    container.set "publicDirectory", __dirname
    container.set "components", ["jquery"]

    container.injectAll([
      require ".."

      (bower, logger) ->
        sandbox = sinon.sandbox.create()

        sandbox.stub process, "chdir"

        installation = on: sandbox.stub()
        installation.on.withArgs("end").yields()

        sandbox.stub bower.commands, "install"
        bower.commands.install.returns installation

        sandbox.stub logger, "info"

    ]).should.notify callback

  afterEach ->
    sandbox.restore()

  it "should pipe bower output", (callback) ->
    container.get("logger").then (logger) ->
      installation.on.should.have.been.calledWith "data"

      listener = installation.on.withArgs("data").firstCall.args[1]
      listener "bower\n"

      logger.info.should.have.been.calledOnce
      logger.info.should.have.been.calledWith "bower"
    .should.notify callback
