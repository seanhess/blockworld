var sys = require("sys")
var Player = require("../model/Player")
var Wall = require("../model/Wall")
var Tile = require("../model/Tile")
var Bomb = require("../model/Bomb")
var Message = require("../model/Message")
var Fault = require("../model/Fault")
var assert = require('assert')
var _ = require('underscore')
var traffic = require("../utils/traffic")

exports.observe = function(app, client, data) {

    var you = new Player(data.nickname)
    
    var messages = []
        
    attach(Player.allPlayers, Player, function() {
        attach(Wall.allWalls, Wall, function() {
            send()
        })
    })
    
    function attach(findMethod, Class, cb) {
        findMethod.call(Class, function(err, objects) {
            if (err) return cb(err)

            objects.forEach(function(object) {
                if (object instanceof Player && you.playerId() == object.playerId()) return
                messages.push(new Class.MessageCreate(object))
            })
            
            cb()
        })    
    }
    
    function send() {
        // send the state
        client.send(messages)
    }
    
}

exports.create = function (app, client, data) {
	assert.ok(data.nickname, "Missing nickname")
    var nickname = data.nickname
    var player = new Player(nickname)
            
    // create it first (this isn't time-sensitive, so just go)
    

    
    safeSpawn(function() {
        player.create(function(success) {

            if (!success)
                return client.send(new Fault(Fault.PlayerExists, "Player Exists: " + nickname))
                
            // send created self    
            client.send(new Player.MessageYou(player))
            app.setClientPlayer(client, player)
            
            // observe
            exports.observe(app, client, data)
            
            // announce to others
            app.sendAll(new Player.MessageCreate(player))
        })       
    })
    
    
    
    
    // keep looking for a good spawn location 
    function safeSpawn(cb) {
        
        player.spawn()
        
        Tile.isOccupied(player.x(), player.y(), function(err, occupied) {

            if (occupied) {
                traffic.log("UNSAFE SPAWN")
                return safeSpawn(cb)
            }
            
            cb()
        })
    }    
    
 
}

exports.leave = function(app, client, data) {
    
    var player = Player.fromValue(data)
    
    // clear x and y so the clients don't think it is accurate
    player.clearPosition()
    
    // remove from the game state
    player.remove(function() {})
    
    app.sendAll(new Player.MessageDestroy(player))
    
}

exports.move = function (app, client, data) {
    
    // expects: data.x, data.y
    // expects: data.uid
    
    var player = Player.fromValue(data)    
        
    assert.ok(!_(player.x()).isUndefined(), "Missing X")
    assert.ok(!_(player.y()).isUndefined(), "Missing Y")
    assert.ok(player.playerId(), "Missing playerId")
    
    Tile.isOccupied(player.x(), player.y(), function(err, occupied) {

        // If the Tile is occupied, find out where they used to be and move them back
        if (occupied) {
            return Player.findPlayer(player.playerId(), function(err, player) {
                if (player) 
                    app.sendAll(new Player.MessageMove(player))
            })
        }
            
        // Otherwise, update the server
        Player.moveTo(player.playerId(), player.x(), player.y(), function(err) {
            // send immediately (this is timely)
            app.sendOthers(client, new Player.MessageMove(player))            
        })
    })
    

    
}
