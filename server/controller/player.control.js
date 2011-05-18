var sys = require("sys")
var Player = require("../model/Player")
var Message = require("../model/Message")
var GameState = require("../model/GameState")
var Fault = require("../model/Fault")
var assert = require('assert')
var _ = require('underscore')

exports.observe = function(app, client, data) {

    // send the state
    client.send(app.state().allMessages())
    
}

exports.create = function (app, client, data) {
	assert.ok(data.nickname, "Missing nickname")
    var nickname = data.nickname
    var player = new Player(nickname)
    
    // DUMP STATE // 
    // sys.puts("PLAYER? " + GameState.verify(player))

    if (app.state().exists(player.uid())) 
        return client.send(new Fault(Fault.PlayerExists, "Player Exists: " + nickname))
    
    // send created self    
    client.send(new Player.MessageYou(player))
    
    // add the player
    app.state().add(player)
    
    // observe
    exports.observe(app, client, data)
    
    // announce to others
    app.sendOthers(client, new Player.MessageCreate(player))
}

exports.move = function (app, client, data) {
    
    // expects: data.x, data.y
    // expects: data.uid
        
    assert.ok(!_(data.x).isUndefined(), "Missing X")
    assert.ok(!_(data.y).isUndefined(), "Missing Y")    
    assert.ok(data.playerId, "Missing playerId")
    
    var player = app.state().fetch(data.playerId)
    
    assert.ok(player, "Could not find player " + data.uid)
    
    // must be called first, to update the state
    app.state().moveTo(player, data.x, data.y)
        
    // now update the object itself
    player.move(data.x, data.y)
    
    app.sendOthers(client, new Player.MessageMove(player))
}
