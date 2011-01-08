var sys = require("sys")
var Player = require("../model/Player")
var Message = require("../model/Message")
var GameState = require("../model/GameState")
var Fault = require("../model/Fault")

exports.create = function (app, client, data) {
    var nickname = data.id
    var player = new Player()
    player.nickname(nickname)
    
    // DUMP STATE // 
    // sys.puts("PLAYER? " + GameState.verify(player))

    if (app.state().exists(player.uid())) 
        return client.send(new Fault(Fault.PlayerExists, "Player Exists: " + nickname))
    
    // send created self    
    client.send(new Message("player", "you", player))
    
    // add the player
    app.state().add(player)
    
    // send the state
    client.send(app.state().allMessages())
    
    // announce to others
    app.sendOthers(client, player.toMessage())
}