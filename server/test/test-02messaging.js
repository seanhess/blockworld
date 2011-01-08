var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")
var Message = require("../model/Message")

exports.ping = function(assert) {   
    helpers.setup(function(app, client) {           
        client.send(new Message("test", "ping", {key:'value'}))
        client.onMessage(function(message) {
            assert.ok(message.type, "No type was sent back from the server")
            assert.equal(message.type, "pong")
            assert.ok(message.data, "No message was sent back from the server")
            assert.equal(message.data.key, "value", "incorrect data sent back")
            assert.finish()
        })
    })
}
