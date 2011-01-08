
// var World = require("../controller/World.js")

var sys = require('sys')

var Player = module.exports = function(id) {
    this.id = Player.generatePlayerId()
    this.position = Player.getRandomSpawnLocation()
}

Player.prototype.id = function (id) {
    return (id) ? this.id = id : this.id
}

Player.prototype.position = function () {
    return this.position
}

Player.prototype.move = function(newX, newY) {
    this.position = {x:newX, y:newY}
}

Player.getRandomSpawnLocation = function() {
    return {x:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis), y:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis)}
}

Player.generatePlayerId = function() {
	return Math.floor(Math.random() * 10000000)
}

var SpawnRaduis = Player.SpawnRaduis = 10