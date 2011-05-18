
var Message = require("./Message")
var Tile = require("./Tile")

var Bomb = module.exports = function(x, y, playerId) {
    Tile.call(this, Bomb.Type)
    this.position(x,y)
    this.playerId(playerId)
    
    // generate the id. Must call the constructor
    this.source.bombId = Tile.tileId(x, y)    
}

Bomb.fromValue = function(value) {
    return Tile.fromValue(Bomb, value)
}

Bomb.Type = "bomb"
Bomb.ActionCreate = "create"
Bomb.ActionDetonate = "destroy"

Bomb.Delay = 3000
Bomb.BlastSize = 1

Bomb.prototype = new Tile()

Bomb.prototype.bombId = function() {
    return this.source.bombId
}

Bomb.prototype.playerId = function(value) {
    if (value) this.source.playerId = value
    return this.source.playerId
}

Bomb.prototype.hitArea = function() {

    var query = {   
        x: {$gte: this.x()-1, $lte: this.x()+1},
        y: {$gte: this.y()-1, $lte: this.y()+1}
    }

    return query
}

Bomb.prototype.create = function(cb) {
    Tile.tiles().insert(this.toValue(), function(err) {
        cb(err == null)
    })
}

Bomb.prototype.remove = function(cb) {
    Tile.tiles().remove({bombId: this.bombId()})
}

Bomb.allBombs = function(cb) {
    Tile.allWithClass(Bomb, cb)
}





Bomb.MessageCreate = function(bomb) {
    return new Message(Bomb.Type, Bomb.ActionCreate, bomb)
}

Bomb.MessageDetonate = function(bomb) {
    return new Message(Bomb.Type, Bomb.ActionDetonate, bomb)
}

