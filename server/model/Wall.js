var Message = require("./Message")
var Tile = require("./Tile")

var Wall = module.exports = function(x, y) {
    Tile.call(this)
    this.position(x,y)
}

// extend Tile
//Wall.prototype = new Tile()

Wall.prototype.toMessage = function() {
    return new Wall.MessageCreate(this)
}

Wall.prototype.type = function() {
    return Wall.Type
}

Wall.Type = "wall"
Wall.ActionCreate = "create"

Wall.MessageCreate = function(wall) {
    return new Message(Wall.Type, Wall.ActionCreate, wall)
}
