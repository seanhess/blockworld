
var Message = require("./Message")
var Tile = require("./Tile")

var Bomb = module.exports = function(x, y) {
    this.position(x,y)
}

// extend Tile
Bomb.prototype = new Tile()

Bomb.prototype.toMessage = function() {
    return new Bomb.MessageAddBomb(this)
}

Bomb.prototype.type = function() {
    return Bomb.Type
}

Bomb.Type = "map"
Bomb.ActionAddBomb = "addBomb"

Bomb.Delay = 1500

Bomb.MessageAddBomb = function(bomb) {
    return new Message(Bomb.Type, Bomb.ActionAddBomb, bomb)
}

