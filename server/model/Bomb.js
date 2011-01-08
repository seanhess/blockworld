var Message = require("./Message")

// TODO: Inheritance

var Bomb = module.exports = function(x, y) {
    this.source = {x:x, y:y}
    this.source.uid = Bomb.Type + "_" + x + "|" + y
}

Bomb.prototype.toValue = function() {
    return this.source
}

Bomb.prototype.uid = function() {
    return this.source.uid
}

Bomb.prototype.type = function() {
    return Bomb.Type
}

Bomb.prototype.toMessage = function() {
    return new Bomb.MessageAddBomb(this)
}

Bomb.prototype.x = function() {
    return this.source.x
}

Bomb.prototype.y = function() {
    return this.source.y
}

Bomb.Type = "map"
Bomb.ActionAddBomb = "addBomb"

Bomb.Delay = 1500

Bomb.MessageAddBomb = function(Bomb) {
    return new Message(Bomb.Type, Bomb.ActionAddBomb, Bomb)
}
