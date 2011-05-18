// Abstract Base class

var Stateable = require("./Stateable")

var Tile = module.exports = function() {
    Stateable.call(this)
}

Tile.prototype = new Stateable()

Tile.prototype.position = function(x, y) {
    this.source.x = x
    this.source.y = y
    if (!this.source.uid) // don't overwrite it if someone has already set it
        this.source.uid = this.type() + "_" + x + "|" + y
}

Tile.prototype.x = function() {
    return this.source.x
}

Tile.prototype.y = function() {
    return this.source.y
}

Tile.Type = "Tile"


// Wall.Type = "map"
// Wall.ActionCreate = "addWall"
// 
// Wall.MessageCreate = function(wall) {
//     return new Message(Wall.Type, Wall.ActionCreate, wall)
// }
