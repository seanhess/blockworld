
// var World = require("../controller/World.js")

var Message = require("./Message")
var sys = require('sys')

var Player = module.exports = function(nickname, x, y) {
    this.source = {x:x, y:y}
	this.nickname(nickname)
    
    if (!x || !y) {
        var position = Player.getRandomSpawnLocation()
        this.source.x = position.x
        this.source.y = position.y
    }
}

Player.prototype.uid = function () {
    return this.source.uid;
}

Player.prototype.type = function() {
    return "Player"
}

Player.prototype.toMessage = function() {
    return new Message("player", "create", this)
}

Player.prototype.toValue = function() {
    return this.source
}

Player.prototype.nickname = function(nick) {
	if(nick) {
		this.source.nickname = nick
		this.source.uid = "Player_" + this.source.nickname
	} else {
		return this.source.nickname
	}
}

Player.prototype.x = function () {
    return this.source.x
}

Player.prototype.y = function () {
    return this.source.y
}


Player.prototype.move = function(x, y) {
    this.source.x = x
    this.source.y = y
}




Player.getRandomSpawnLocation = function() {
    return {x:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis), y:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis)}
}

Player.generatePlayerId = function() {
	return Math.floor(Math.random() * 10000000)
}


var SpawnRaduis = Player.SpawnRaduis = 10
