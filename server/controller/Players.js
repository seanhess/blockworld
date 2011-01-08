var sys = require("sys")
var Player = require("../model/Player")

var Players = {}

function generatePlayerId () {
	return Math.floor(Math.random() * 10000000)
}

function getRandomPlayerId () {
	var newPlayerId
	while (Players[newPlayerId = generatePlayerId(newPlayerId)]) {}
	return newPlayerId
}

function getPlayerById (playerId) {
	return Players[playerId]
}

exports.createPlayer = function (app, client, data) {
    // client.send("createdPlayer", )
    var newPlayerId = getRandomPlayerId()
    var player = new Player(newPlayerId)
    Players[newPlayerId] = player
    client.send("self.created", player)
    sys.puts("APPP " + sys.inspect(app))
    app.sendOthers(client, "player.created", player)
}

exports.movePlayer = function (data) {
	getPlayerById(data.playerId).move(data.x, data.y)
	
	player.move()
}