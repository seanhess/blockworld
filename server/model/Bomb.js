
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

Bomb.prototype.hitArea = function() {
    var points = []
    
    var x = this.x()
    var y = this.y()
    
    // manual for now
    for (var x = this.x()-Bomb.BlastSize; x < this.x()+Bomb.BlastSize; x++) {
        for (var y = this.y()-Bomb.BlastSize; y < this.y()+Bomb.BlastSize; y++) {
            points.push({x:x, y:y})    
        }
    }    
    
    return points
}

Bomb.Type = "bomb"
Bomb.ActionCreate = "create"
Bomb.ActionDetonate = "destroy"

Bomb.Delay = 3000
Bomb.BlastSize = 1

Bomb.MessageCreate = function(bomb) {
    return new Message(Bomb.Type, Bomb.ActionCreate, bomb)
}

Bomb.MessageDetonate = function(bomb) {
    return new Message(Bomb.Type, Bomb.ActionDetonate, bomb)
}

