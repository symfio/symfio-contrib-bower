suite = require "symfio-suite"


describe "contrib-bower example", ->
  wrapper = suite.http require "../example"

  describe "GET /components/jquery/component.json", ->
    it "should respond with installed components", wrapper (callback) ->
      test = @http.get "/components/jquery/component.json"
      test.res (res) =>
        @expect(res).to.have.status 200
        @expect(res.text).to.include "jquery"
        callback()
