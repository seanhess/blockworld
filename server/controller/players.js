var sys = require("sys")
var Player = require("../model/Player")

exports.create = function (app, client, data) {
    var player = new Player()
    app.world().addPlayer(player)
    client.send("self.created", player)
    client.send("state", app.world())
    app.sendOthers(client, "player.created", player)
}

// exports.movePlayer = function (data) {
//  getPlayerById(data.playerId).move(data.x, data.y)
//  
//  player.move()
// }

