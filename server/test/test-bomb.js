var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")
var Bomb = require("../model/Bomb")
var Player = require("../model/Player")
var Wall = require("../model/Wall")
var Message = require("../model/Message")
var _ = require("underscore")

var GameState = require('../model/GameState')

var bombs = require('../controller/bomb.control')
var walls = require('../controller/wall.control')

exports.addBomb = function (assert) {

    helpers.setup(function(app, client) {
        helpers.client(function(secondClient) {
            client.send(new Player.MessageCreate({nickname:"nick"}))

            helpers.gather(client, function(err, messages) {
                assert.ifError(err)
                Bomb.Delay = 200
                client.send(new Bomb.MessageCreate({x:2, y:2}))

                helpers.gather(secondClient, function(err, messages) {
                    assert.ifError(err)

                    var message = _(messages).detect(function(message) {
                        return message.type == Bomb.Type && message.action == Bomb.ActionCreate
                    })

                    assert.ok(message, "didn't receive Bomb.ActionCreate")
                    assert.equal(message.data.x, 2, "Bomb x wasn't correct")
                    assert.equal(message.data.y, 2, "Bomb y wasn't correct")


                    helpers.gather(client, function(err, messages) {
                        assert.ifError(err)
                        
                        var message = _(messages).detect(function(message) {
                            return message.type == Bomb.Type && message.action == Bomb.ActionDetonate
                        })
                        
                        assert.ok(message, "Didn't receive Bomb.ActionDetonate")
                          
                        assert.finish()
                    })
                })
            })            
        })
    })                                        
}

exports.hits = function(assert) {
    
    var app = new App()
    var client = {
        send: function() {},
        broadcast: function() {}
    }
    
    var bomb = new Bomb(10, 10)
        
    bombs.create(app, client, bomb.toValue())

    var wall = new Wall(10, 11)
    walls.create(app, client, wall.toValue())
    
//    assert.ok(bomb.hitArea().indexOf(function(item) {
//        return (item.x == 10 && item.y == 11)
//    } > -1), "Bomb hit area incorrect")
//    
//    var hits = app.state().hitObjects(bomb.hitArea()) 
//    console.log(hits)
//    
//    var index = hits.indexOf(function(item) {
//        return (item.uid() == wall.uid())
//    })
    
    assert.finish()
    
}


// exports.addBomb(assert)