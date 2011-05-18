var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")
var Player = require("../model/Player")
var Message = require("../model/Message")
var _ = require("underscore")

exports.playerCreate = function (assert) {
    helpers.setup(function(app, client) {
        
        var nickname = "fake-test-nickname"

        client.send(new Player.MessageCreate({nickname:nickname}))
        helpers.gather(client, function(err, messages) {
            assert.ifError(err)
                        
            assert.ok(_(messages).any(function(message) {
                return message.type == Player.Type && message.action == Player.ActionYou
            }), "didn't receive player.you")
        
            assert.ok(_(messages).any(function(message) {
                return message.type == Player.Type && message.action == Player.ActionCreate
            }), "didn't receive Player.ActionCreate")

            client.send(new Player.MessageCreate({nickname:nickname + "2"}))
            helpers.gather(client, function(err, messages) {
                assert.ifError(err)
                
                assert.equal(messages.length, 3, "Didn't get all the messages. May mean you accidentally sent your user twice")
                assert.finish()
            })
        })
    })
}


exports.playerMove = function (assert) {
    helpers.setup(function(app, client) {
        
        // Create Two Clients
        var nickname = "fake-test-nickname"
        client.send(new Player.MessageCreate({nickname:nickname}))
        helpers.gather(client, function(err, messages) {
            assert.ifError(err)
            
            helpers.client(function(secondClient) {
                var nick2 = nickname + "2"
                secondClient.send(new Player.MessageCreate({nickname:nick2}))
                helpers.gather(secondClient, function(err, messages) {
                    assert.ifError(err)
                    
                    var playerData = _(messages).detect(function(message) {
                        return (message.action == Player.ActionYou)
                    }).data
                    
                    assert.ok(playerData, "Couldn't find the second player")
                    
                    var player = Player.fromValue(playerData)
                    player.position(1, 1)                    
                    
                    secondClient.send(new Player.MessageMove(player))
                    
                    helpers.gather(client, function(err, messages) {
                        assert.ifError(err)
                        
                        var message = _(messages).detect(function(message) {
                            return (message.type == Player.Type && message.action == Player.ActionMove)
                        })
                        
                        assert.ok(message, "Didn't get moved message back")
                        assert.equal(message.data.x, 1, "X didn't match new coordinates")
                        
                        assert.finish()
                    })
                })
            })
        })
    })
}




