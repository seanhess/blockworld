
var Message = require("./Message")
var Tile = require("./Tile")

var Bomb = module.exports = function(x, y, playerId) {
    this.source = {}
    this.type(Bomb.Type)
    this.position(x,y)
    this.playerId(playerId)
    
    // generate the id. Must call the constructor
    this.source.bombId = Tile.tileId(x, y)    
}

Bomb.fromValue = function(value) {
    var bomb = new Bomb()
    bomb.source = value
    return bomb
}

Bomb.Type = "bomb"
Bomb.ActionCreate = "create"
Bomb.ActionDetonate = "destroy"

Bomb.Delay = 3000
Bomb.BlastSize = 1

Tile.mixinTo(Bomb)

Bomb.prototype.bombId = function() {
    return this.source.bombId
}

Bomb.prototype.playerId = function(value) {
    if (value) this.source.playerId = value
    return this.source.playerId
}

Bomb.prototype.hitArea = function() {

    var query = {   
        x: {$gte: this.x()-1, lte: this.x()+1},
        y: {$gte: this.y()-1, lte: this.y()+1}
    }

    return query
}

Bomb.prototype.create = function(cb) {
    this.tiles().insert(this.toValue(), function(err) {
        cb(err == null)
    })
}

Bomb.prototype.remove = function(cb) {
    this.tiles().remove({bombId: this.bombId()})
}

Bomb.allBombs = function(cb) {
    this.tiles().find({type:Bomb.Type}).toArray(function(err, bombs) {
        if (err) return cb(err)
        cb(null, bombs.map(function(doc) {
            return Bomb.fromValue(doc)
        }))
    })
}





Bomb.MessageCreate = function(bomb) {
    return new Message(Bomb.Type, Bomb.ActionCreate, bomb)
}

Bomb.MessageDetonate = function(bomb) {
    return new Message(Bomb.Type, Bomb.ActionDetonate, bomb)
}

