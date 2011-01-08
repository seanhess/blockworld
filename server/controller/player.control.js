var sys = require("sys")
var Player = require("../model/Player")
var Message = require("../model/Message")
var GameState = require("../model/GameState")
var Fault = require("../model/Fault")
var assert = require('assert')



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
    
    // send the state
    client.send(app.state().allMessages())
    
    // announce to others
    app.sendOthers(client, new Player.MessageCreate(player))
}

exports.move = function (app, client, data) {
    
    // expects: data.x, data.y
    // expects: data.uid
    
    assert.ok(data.x, "Missing X")
    assert.ok(data.y, "Missing Y")    
    assert.ok(data.uid, "Missing uid")
    
    var player = app.state().fetch(data.uid)
    
    assert.ok(player, "Could not find player " + data.uid)
    
    player.position(data.x, data.y)
    
    app.sendOthers(client, new Player.MessageMove(player))
    
}
