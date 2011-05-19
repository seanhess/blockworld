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

var bombs = require('../controller/bomb.control')
var walls = require('../controller/wall.control')

exports.addBomb = function (assert) {

    helpers.setup(function(app, client) {
        helpers.client(function(secondClient) {
            client.send(new Player.MessageCreate({nickname:"nick"}))

            helpers.gather(client, function(err, messages) {
                assert.ifError(err)
                Bomb.Delay = 300
                client.send(new Bomb.MessageCreate({x:2, y:2}))

                helpers.gather(secondClient, function(err, messages) {
                    assert.ifError(err)

                    var message = _(messages).detect(function(message) {
                        return message.type == Bomb.Type && message.action == Bomb.ActionCreate
                    })

                    assert.ok(message, "didn't receive Bomb.ActionCreate")
                    assert.equal(message.data.x, 2, "Bomb x wasn't correct")
                    assert.equal(message.data.y, 2, "Bomb y wasn't correct")


                    client.onMessage(function(message) {                          
                        assert.ok(message, "Didn't receive Bomb.ActionDetonate")
                        assert.finish()
                    })
                })
            })            
        })
    })                                        
}

exports.hits = function(assert) {
    
    helpers.simple(function(app, client, socket, timer) {

        var wall = new Wall(10, 10)
        walls.create(app, client, wall.toValue())
        
        Bomb.Delay = 300 // enough time to hit it
        
        var bomb = new Bomb(09, 09)    
        bombs.create(app, client, bomb.toValue())
        
        timer.start()
        
        var hitWall = false
        var hitBomb = false
        var finished = false
        
        socket.broadcast = function(message) {
            
            if (message.data.wallId == wall.wallId()) hitWall = true
            if (message.data.bombId == bomb.bombId()) hitBomb = true

            if (hitWall && hitBomb) {
                assert.ok(!finished, "Finished twice!")
                finished = true
                bombAgain()
            }
        }
        
        
        
        function bombAgain() {
            var bomb = new Bomb(11, 11)
            bombs.create(app, client, bomb.toValue())     
            
            socket.broadcast = function(message) {

                assert.ok(message.data.bombId, "Possibly didn't clear old tiles")
                assert.equal(message.data.bombId, bomb.bombId(), "Possibly didn't clear old tiles")
                
                timer.stop()
                
                assert.finish()
            }   
        }
        
    })
}


// exports.addBomb(assert)