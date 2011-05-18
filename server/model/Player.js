
var Message = require("./Message")
var Tile = require("./Tile")

var Player = module.exports = function(nickname, x, y) {
    this.source = {}
    this.type(Player.Type) // required!
    this.nickname(nickname)    
	this.position(x, y)
    
    if (!x || !y) {
        var position = Player.getRandomSpawnLocation()
        this.source.x = position.x
        this.source.y = position.y
    }
}

Player.fromValue = function(doc) {
    var player = new Player()
    player.source = doc
    return player
}

Player.Type = "player"
Player.ActionCreate = "create"
Player.ActionYou = "you"
Player.ActionMove = "move"

Tile.MixinTo(Player)

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
    this.tiles().insert(this.source, function(err) {
        cb(err == null)
    })
}


//Player.idAvailable = function(playerId, cb) {
//
//    // slow, careful check to make sure the id is available
//    
//    this.tiles().count({_id:playerId}, function(err, count) {
//        if (err) return cb(err)
//        cb(null, (count == 0))
//    })
//    
//}


Player.getRandomSpawnLocation = function() {
    return {x:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis), y:Math.floor(Math.random() * ((SpawnRaduis * 2) + 1) - SpawnRaduis)}
}

Player.allPlayers = function(cb) {
    this.tiles().find({type:Player.Type}).toArray(function(err, players) {
        if (err) return cb(err)
        cb(null, players.map(function(doc) {
            return Player.fromValue(doc)
        }))
    })
}

Player.clearAll = function() {
    this.tiles().remove({type:Player.Type})
}

Player.moveTo = function(playerId, x, y, cb) {
    this.tiles().update({playerId:playerId}, {$set: {x: x, y: y}}, cb)
}



// Messages





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

