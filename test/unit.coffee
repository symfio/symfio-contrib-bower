symfio = require "symfio"
plugin = require "../lib/bower"
suite = require "symfio-suite"
bower = require "bower"
fs = require "fs"


describe "contrib-bower plugin", ->
  wrapper = suite.sandbox symfio, ->
    @installation = on: @sandbox.stub()

    @sandbox.stub process, "chdir"
    @sandbox.stub fs, "writeFile"
    @sandbox.stub bower.commands, "install"

    fs.writeFile.yields null
    @installation.on.withArgs("end").yields()
    bower.commands.install.returns @installation

    @container.set "public directory", __dirname
    @container.set "silent", false

  it "should pipe bower output", wrapper (callback) ->
    @container.set "components", ["jquery"]

    @sandbox.stub console, "log"

    plugin @container, =>
      @expect(@installation.on).to.have.been.calledWith "data"

      listener = @installation.on.withArgs("data").firstCall.args[1]
      listener "bower"

      @expect(console.log).to.have.been.calledOnce
      @expect(console.log).to.have.been.calledWith "bower"

      console.log.restore()
      callback()

  it "should not install components if no components is provided",
    wrapper (callback) ->
      plugin @container, =>
        @expect(bower.commands.install).to.not.have.been.called
        callback()
