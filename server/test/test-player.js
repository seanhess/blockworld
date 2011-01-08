var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")
var Player = require("../model/Player")
var Message = require("../model/Message")

exports.playerCreate = function (assert) {
    helpers.setup(function(app, client) {
        
        var nickname = "fake-test-nickname"
        helpers.sendAndMap(client, new Message("player", "create", {nickname:nickname}), function(err, messages, map) {
            assert.ifError(err)
            assert.ok(map['player.you'], "Don't have player - you")
            assert.ok(map['player.added'], "Didn't get player.added")
            
            helpers.sendAndMap(client, new Message("player", "create", {nickname:nickname + "2"}), function(err, messages, map) {
                assert.ok(map['player.you'], "Don't have player - you")                
                assert.equal(messages.length, 3, "Didn't get all the messages")
                assert.finish()
            })
        })
    })
}


exports.playerMove = function (assert) {
    helpers.setup(function(app, client) {
        
        var nickname = "fake-test-nickname"
        helpers.sendAndMap(client, new Message("player", "create", {nickname:nickname}), function(err, messages, map) {
            assert.ifError(err)
            assert.finish()
        })
    })
}





