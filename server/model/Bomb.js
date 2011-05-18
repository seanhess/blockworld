
var Message = require("./Message")
var Tile = require("./Tile")

var Bomb = module.exports = function(x, y) {
    Tile.call(this)
    this.position(x,y)
}

// extend Tile
Bomb.prototype = new Tile()

Bomb.prototype.toMessage = function() {
    return new Bomb.MessageCreate(this)
}

Bomb.prototype.type = function() {
    return Bomb.Type
}

Bomb.Type = "bomb"
Bomb.ActionCreate = "create"
Bomb.ActionDetonate = "detonate"

Bomb.Delay = 1500

Bomb.MessageCreate = function(bomb) {
    return new Message(Bomb.Type, Bomb.ActionCreate, bomb)
}

Bomb.MessageDetonateBomb = function(bomb) {
    return new Message(Bomb.Type, Bomb.ActionDetonate, bomb)
}

