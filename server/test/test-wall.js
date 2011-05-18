var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")
var Wall = require("../model/Wall")
var Bomb = require("../model/Bomb")
var Player = require("../model/Player")
var Message = require("../model/Message")
var _ = require("underscore")

exports.addWall = function(assert) {
    
    helpers.setup(function(app, client) {
        
        helpers.client(function(secondClient) {
            client.send(new Player.MessageCreate({x:3, y:3, nickname:"hello"}))
            client.send(new Wall.MessageCreate({x:3, y:3}))
            // helpers.gather(secondClient, function(err, messages) {
            //     assert.ifError(err)
            //             
            //     var message = _(messages).detect(function(message) {
            //         return message.type == Wall.Type && message.action == Wall.ActionCreate
            //     })
            // 
            //     assert.ok(message, "didn't receive Wall.ActionCreate")
            //     assert.equal(message.data.x, 3, "Wall x wasn't correct")
            //     assert.equal(message.data.y, 3, "Wall y wasn't correct")
            //     assert.ok(message.data.uid.match(Wall.Type), "Wall didn't match type " + message.data.uid)
            // 
            //     assert.finish()
            // })
            assert.finish()
        })
    })
}