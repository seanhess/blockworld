var Message = require("./Message")
var Tile = require("./Tile")

var Wall = module.exports = function(x, y) {
    this.source = {}
    this.position(x,y)

    // generate the id. Must call the constructor
    this.source.wallId = Tile.tileId(x, y)
}

Wall.Type = "wall"
Wall.ActionCreate = "create"

Tile.mixinTo(Wall)

Wall.prototype.wallId = function() {
    return this.source.wallId
}



Wall.prototype.create = function(cb) {
    this.tiles().insert(this.toValue(), function(err) {
        cb(err == null)
    })
}




Wall.MessageCreate = function(wall) {
    return new Message(Wall.Type, Wall.ActionCreate, wall)
}
