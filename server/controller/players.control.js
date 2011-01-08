var sys = require("sys")
var Player = require("../model/Player")
var Message = require("../model/Message")

exports.create = function (app, client, data) {
    var player = new Player()
    app.world().addPlayer(player)
    client.send(new Message("player", "self", player))
    // client.send("state", player)
    // client.send("state", app.world())
    // app.sendOthers(client, new Message("player", "created", player))
}

// exports.movePlayer = function (data) {
//  getPlayerById(data.playerId).move(data.x, data.y)
//  
//  player.move()
// }

