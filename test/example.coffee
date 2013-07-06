suite = require "symfio-suite"


describe "contrib-bower example", ->
  it = suite.example require "../example"

  describe "GET /bower_components/jquery/component.json", ->
    it "should respond with installed components", (request) ->
      request.get("/bower_components/jquery/component.json").then (res) ->
        res.should.have.status 200
        res.text.should.include "jquery"
