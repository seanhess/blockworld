
var World = require("../controller/World.js")



var spawnRaduis = 10

function getRandomSpawnLocation () {
	return [Math.floor(Math.random() * ((spawnRaduis * 2) + 1) - spawnRaduis), Math.floor(Math.random() * ((spawnRaduis * 2) + 1) - spawnRaduis)]
}

function Player (id) {
	this.id = id
	this.position = getRandomSpawnLocation()
	World.movePlayer(0, 0, this.position[0], this.position[1], this)
}

Player.prototype.setId = function (name) {
	this.id = name
	return this.id
}

Player.prototype.getId = function () {
	return this.id
}

Player.prototype.getPosition = function () {
	return this.position
}

Player.prototype.move = function (newX, newY) {
	World.movePlayer(this.position[0], this.position[1], newX, newY, this)
	this.position = [newX, newY]
}



module.exports = Player