
// var World = require("../controller/World.js")

var Message = require("./Message")
var sys = require('sys')

var Player = module.exports = function(nickname, position) {
    this._nickname = nickname
    this._position = position || Player.getRandomSpawnLocation()
}

Player.prototype.uid = function () {
    return "Player_" + this._nickname
}

Player.prototype.type = function() {
    return "Player"
}

Player.prototype.toMessage = function() {
    return new Message("player", "added", this)
}


Player.prototype.toValue = function() {
    return {
        position:this._position,
        nickname:this._nickname,
        uid:this.uid()
    }
}

Player.prototype.nickname = function(nick) {
    return (nick) ? this._nickname = nick : this._nickname
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