var sys = require("sys")
var Player = require("../model/Player.js")

var Players = []

function generatePlayerId () {
	return Math.floor(Math.random() * 10000000)
}

function getRandomPlayerId () {
	var newPlayerId
	while (Players[newPlayerId = generatePlayerId(newPlayerId)]) {
	}
	return newPlayerId
}

function getPlayerById (playerId) {
	return Players[playerId]
}

exports.createPlayer = function (data) {
	var newPlayerId = getRandomPlayerId()
	Players[newPlayerId] = new Player()
	return newPlayerId
}

exports.movePlayer = function (data) {
	getPlayerById(data.playerId).move(data.x, data.y)
}