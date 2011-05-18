var sys = require("sys")
var Player = require("../model/Player")
var Wall = require("../model/Wall")
var Message = require("../model/Message")
var GameState = require("../model/GameState")
var Fault = require("../model/Fault")
var assert = require('assert')
var _ = require('underscore')

exports.observe = function(app, client, data) {

    var you = new Player(data.nickname)
    
    var messages = []
    
        
        
    players(function() {
        walls(function() {
            send()
        })
    })
    
    function players(cb) {
        Player.allPlayers(function(err, players) {
            if (err) return cb(err)
            
            players.forEach(function(player) {
                if(you.playerId() != player.playerId())
                    messages.push(new Player.MessageCreate(player))
            })
            
            cb()
        })
    }
    
    function walls(cb) {
        Wall.allWalls(function(err, walls) {
            if (err) return cb(err)

            walls.forEach(function(wall) {
                messages.push(new Wall.MessageCreate(wall))
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
            
    // create it first (this isn't timely)
    player.create(function(success) {

        if (!success)
            return client.send(new Fault(Fault.PlayerExists, "Player Exists: " + nickname))
            
        
        // send created self    
        client.send(new Player.MessageYou(player))
        
        // observe
        exports.observe(app, client, data)
        
        // announce to others
        app.sendAll(new Player.MessageCreate(player))
        
    })    
}

exports.move = function (app, client, data) {
    
    // expects: data.x, data.y
    // expects: data.uid
    
    var player = Player.fromValue(data)    
        
    assert.ok(!_(player.x()).isUndefined(), "Missing X")
    assert.ok(!_(player.y()).isUndefined(), "Missing Y")    
    assert.ok(player.playerId(), "Missing playerId")
    
    Player.moveTo(player.playerId(), player.x(), player.y(), function(err) {
        // if something goes wrong, report it
        if (err) {
            client.send(Fault.Error, err)
        }
    })
    
    // send immediately (this is timely)

    app.sendOthers(client, new Player.MessageMove(player))
}
