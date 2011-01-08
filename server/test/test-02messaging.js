var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")

exports.faults = function(assert) {   
    helpers.appAndClient(function(app, client) {           
        var data = {key:"value"}
        client.send("test.ping", data)
        client.onMessage(function(route, pongData) {
            assert.ok(route, "No route was sent back from the server")
            assert.equal(route, "pong")
            assert.ok(pongData, "No message was sent back from the server")
            assert.equal(pongData.key, "value", "incorrect data sent back")
            assert.finish()
        })
    })
}
