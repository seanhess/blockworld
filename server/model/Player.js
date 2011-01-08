
// var World = require("../controller/World.js")

var sys = require('sys')

var SpawnRaduis = 10

function getRandomSpawnLocation () {
 return {x:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis), y:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis)}
}

var Player = module.exports = function(id) {
    sys.puts("New Player")
    this.id = id
    this.position = getRandomSpawnLocation()
    // World.movePlayer(0, 0, this.position.x, this.position.y, this)
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
    // World.movePlayer(this.position.x, this.position.y, newX, newY, this)
    this.position = {x:newX, y:newY}
}

Player.SpawnRaduis = SpawnRaduis