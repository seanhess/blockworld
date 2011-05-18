var Message = require("./Message")
var Tile = require("./Tile")

var Wall = module.exports = function(x, y) {
    Tile.call(this, Wall.Type)
    this.position(x,y)

    // generate the id. Must call the constructor
    this.source.wallId = Tile.tileId(x, y)
}

Wall.fromValue = function(value) {
    return Tile.fromValue(Wall, value)
}

Wall.Type = "wall"
Wall.ActionCreate = "create"

Wall.prototype = new Tile()

Wall.prototype.wallId = function() {
    return this.source.wallId
}



Wall.prototype.create = function(cb) {
    Tile.tiles().insert(this.toValue(), function(err) {
        cb(err == null)
    })
}

Wall.prototype.remove = function(cb) {
    Tile.tiles().remove({wallId: this.wallId()}, cb)
}

Wall.allWalls = function(cb) {
    Tile.allWithClass(Wall, cb)
}

Wall.MessageCreate = function(wall) {
    return new Message(Wall.Type, Wall.ActionCreate, wall)
}
