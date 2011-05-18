
var Message = require("./Message")
var Tile = require("./Tile")

var sys = require('sys')


var Player = module.exports = function(nickname, x, y) {
	this.nickname(nickname)
	this.position(x, y)
    
    if (!x || !y) {
        var position = Player.getRandomSpawnLocation()
        this.source.x = position.x
        this.source.y = position.y
    }
}

Player.prototype = new Tile()

Player.prototype.toMessage = function() {
    return new Player.MessageCreate(this)
}

Player.prototype.uid = function () {
    return this.source.uid;
}

Player.prototype.type = function() {
    return Player.Type
}

Player.prototype.toValue = function() {
    return this.source
}

Player.prototype.nickname = function(nick) {
	if(nick) {
		this.source.nickname = nick
		this.source.uid = this.type() + this.source.nickname
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


// Messages



Player.Type = "player"
Player.ActionCreate = "create"
Player.ActionYou = "you"
Player.ActionMove = "move"

Player.MessageCreate = function(player) {
    return new Message(Player.Type, Player.ActionCreate, player) // needs: {nickname:nickname}
}

Player.MessageYou = function(player) {
    return new Message(Player.Type, Player.ActionYou, player) // needs: {nickname:nickname}
}

Player.MessageMove = function(player) {
    return new Message(Player.Type, Player.ActionMove, player) // needs: {nickname:nickname}
}



var SpawnRaduis = Player.SpawnRaduis = 10

