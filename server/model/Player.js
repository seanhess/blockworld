
var Message = require("./Message")
var Tile = require("./Tile")

var Player = module.exports = function(nickname, x, y) {
    Tile.call(this, Player.Type)

    this.nickname(nickname)    
	this.position(x || 0, y || 0) // default to 0
}

Player.fromValue = function(doc) {
    return Tile.fromValue(Player, doc)
}

Player.Type = "player"


Player.prototype = new Tile()

Player.prototype.nickname = function(nick) {

	if(nick) {
		this.source.nickname = nick
        this.source.playerId = nick
	} 
    
    return this.source.nickname
}

Player.prototype.playerId = function() {
    return this.source.playerId
}

Player.prototype.create = function(cb) {
    Tile.tiles().insert(this.toValue(), function(err) {
        if (err) console.log("ERR", err.toString())
        cb(err == null)
    })
}

Player.prototype.remove = function(cb) {
    Tile.tiles().remove({type: Player.Type, playerId: this.playerId()}, cb)
}


Player.getRandomSpawnLocation = function() {
    return {x:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis), y:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis)}
}

Player.prototype.spawn = function() {
    
    // Add the spawn location to the current position for extra randomness

    var point = Player.getRandomSpawnLocation()
    this.position(point.x + this.x(), point.y + this.y())
}

Player.allPlayers = function(cb) {
    Tile.allWithClass(Player, cb)
}

Player.moveTo = function(playerId, x, y, cb) {
    Tile.tiles().update({type: Player.Type, playerId:playerId}, {$set: {x: x, y: y}}, cb)
}

Player.findPlayer = function(playerId, cb) {
    Tile.tiles().findOne({type: Player.Type, playerId:playerId}, function(err, player) {
        cb(null, player)
    })
}




// Messages




Player.ActionCreate = "create"
Player.ActionYou = "you"
Player.ActionMove = "move"
Player.ActionDestroy = "destroy"
Player.ActionWorld = "world"

Player.MessageCreate = function(player) {
    return new Message(Player.Type, Player.ActionCreate, player) // needs: {nickname:nickname}
}

Player.MessageYou = function(player) {
    return new Message(Player.Type, Player.ActionYou, player) // needs: {nickname:nickname}
}

Player.MessageMove = function(player) {
    return new Message(Player.Type, Player.ActionMove, player) // needs: {nickname:nickname}
}

Player.MessageDestroy = function(player) {
    return new Message(Player.Type, Player.ActionDestroy, player) 
}

Player.MessageWorld = function(tiles) {
    return new Message(Player.Type, Player.ActionWorld, {tiles:tiles})
}


var SpawnRaduis = Player.SpawnRaduis = 10

