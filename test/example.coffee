chai = require "chai"
w = require "when"


describe "contrib-bower example", ->
  chai.use require "chai-as-promised"
  chai.use require "chai-http"
  chai.should()

  container = require "../example"
  container.set "env", "test"

  before (callback) ->
    @timeout 0
    container.promise.should.notify callback

  describe "GET /bower_components/jquery/component.json", ->
    it "should respond with installed components", (callback) ->
      container.get("app").then (app) ->
        url = "/bower_components/jquery/component.json"

        deferred = w.defer()
        chai.request(app).get(url).res deferred.resolve
        deferred.promise
      .then (res) ->
        res.should.have.status 200
        res.text.should.include "jquery"
      .should.notify callback
