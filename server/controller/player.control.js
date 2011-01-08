var sys = require("sys")
var Player = require("../model/Player")
var Message = require("../model/Message")

exports.create = function (app, client, data) {
    var nickname = data.id
    var player = new Player()
    player.nickname(nickname)
    client.send(new Message("player", "createdSelf", player))
    
    // DUMP STATE // 
    
    app.world().addPlayer(player)
    // client.send("state", player)
    // client.send("state", app.world())
    // app.sendOthers(client, new Message("player", "created", player))
}

// exports.movePlayer = function (data) {
//  getPlayerById(data.playerId).move(data.x, data.y)
//  
//  player.move()
// }

