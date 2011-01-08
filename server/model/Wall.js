var Message = require("./Message")
var Tile = require("./Tile")

var Wall = module.exports = function(x, y) {
    this.position(x,y)
}

// extend Tile
Wall.prototype = new Tile()

Wall.prototype.toMessage = function() {
    return new Wall.MessageAddWall(this)
}

Wall.prototype.type = function() {
    return Wall.Type
}

Wall.Type = "map"
Wall.ActionAddWall = "addWall"

Wall.MessageAddWall = function(wall) {
    return new Message(Wall.Type, Wall.ActionAddWall, wall)
}
