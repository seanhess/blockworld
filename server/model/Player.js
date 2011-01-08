
// var World = require("../controller/World.js")

var Message = require("./Message")
var sys = require('sys')

var Player = module.exports = function(id) {
    this._id = Player.generatePlayerId()
    this._position = Player.getRandomSpawnLocation()
}

Player.prototype.toValue = function() {
    return {
        id:this._id, 
        position:this._position
    }
}

Player.prototype.id = function (id) {
    return (id) ? this._id = id : this._id
}

Player.prototype.position = function () {
    return this._position
}

Player.prototype.move = function(newX, newY) {
    this._position = {x:newX, y:newY}
}



Player.getRandomSpawnLocation = function() {
    return {x:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis), y:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis)}
}

Player.generatePlayerId = function() {
	return Math.floor(Math.random() * 10000000)
}


var SpawnRaduis = Player.SpawnRaduis = 10