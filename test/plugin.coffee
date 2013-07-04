symfio = require "symfio"
plugin = require ".."
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

    container.use plugin

    container.use (bower, logger) ->
      sandbox = sinon.sandbox.create()

      sandbox.stub process, "chdir"

      installation = on: sandbox.stub()
      installation.on.withArgs("end").yields()

      sandbox.stub bower.commands, "install"
      bower.commands.install.returns installation

      sandbox.stub logger, "info"

    container.load().should.notify callback

  afterEach ->
    sandbox.restore()

  it "should pipe bower output", (callback) ->
    container.call(plugin).then ->
      container.get "logger"
    .then (logger) ->
      installation.on.should.have.been.calledWith "data"

      listener = installation.on.withArgs("data").firstCall.args[1]
      listener "bower\n"

      logger.info.should.have.been.calledOnce
      logger.info.should.have.been.calledWith "bower"
    .should.notify callback
