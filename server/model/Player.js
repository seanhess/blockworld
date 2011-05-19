
var Message = require("./Message")
var Tile = require("./Tile")

var Player = module.exports = function(nickname, x, y) {
    Tile.call(this, Player.Type)

    this.nickname(nickname)    
	this.position(x, y)
    
    if (!x || !y) {
        var position = Player.getRandomSpawnLocation()
        this.source.x = position.x
        this.source.y = position.y
    }
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
    Tile.tiles().remove({playerId: this.playerId()}, cb)
}


Player.getRandomSpawnLocation = function() {
    return {x:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis), y:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis)}
}

Player.allPlayers = function(cb) {
    Tile.allWithClass(Player, cb)
}

Player.moveTo = function(playerId, x, y, cb) {
    Tile.tiles().update({playerId:playerId}, {$set: {x: x, y: y}}, cb)
}

Player.findPlayer = function(playerId, cb) {
    Tile.tiles().findOne({playerId:playerId}, function(err, player) {
        cb(null, player)
    })
}




// Messages




Player.ActionCreate = "create"
Player.ActionYou = "you"
Player.ActionMove = "move"
Player.ActionDestroy = "destroy"

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


var SpawnRaduis = Player.SpawnRaduis = 10

