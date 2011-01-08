var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")
var Wall = require("../model/Wall")
var Bomb = require("../model/Bomb")
var Message = require("../model/Message")
var _ = require("underscore")

exports.addWall = function (assert) {
    helpers.setup(function(app, client) {
        
        helpers.client(function(secondClient) {
            client.send(new Wall.MessageAddWall({x:2, y:2}))
            helpers.gather(secondClient, function(err, messages) {
                assert.ifError(err)
                        
                var message = _(messages).detect(function(message) {
                    return message.type == Wall.Type && message.action == Wall.ActionAddWall
                })
            
                assert.ok(message, "didn't receive Wall.ActionAddWall")
                assert.equal(message.data.x, 2, "Wall x wasn't correct")
                assert.equal(message.data.y, 2, "Wall y wasn't correct")
                assert.ok(message.data.uid.match(Wall.Type), "Wall didn't match type " + message.data.uid)
            
                assert.finish()
            })
        })
    })
}

exports.addBomb = function (assert) {
    helpers.setup(function(app, client) {
        helpers.client(function(secondClient) {
            client.send(new Bomb.MessageAddBomb({x:2, y:2}))
            helpers.gather(secondClient, function(err, messages) {
                assert.ifError(err)
                                        
                var message = _(messages).detect(function(message) {
                    return message.type == Bomb.Type && message.action == Bomb.ActionAddBomb
                })
            
                assert.ok(message, "didn't receive Bomb.ActionAddBomb")
                assert.equal(message.data.x, 2, "Bomb x wasn't correct")
                assert.equal(message.data.y, 2, "Bomb y wasn't correct")
            
                assert.finish()
            })
        })
    })
}
