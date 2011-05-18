var Message = require("./Message")
var Tile = require("./Tile")

var Wall = module.exports = function(x, y) {
    Tile.call(this, Wall.Type)
    this.position(x,y)

    // generate the id. Must call the constructor
    this.source.wallId = Tile.tileId(x, y)
}

Wall.fromValue = function(value) {
    var wall = new Wall()
    wall.source = value
    return wall
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

Wall.allWalls = function(cb) {
    Tile.tiles().find({type:Wall.Type}).toArray(function(err, walls) {
        if (err) return cb(err)
        cb(null, walls.map(function(doc) {
            return Wall.fromValue(doc)
        }))
    })
}

Wall.MessageCreate = function(wall) {
    return new Message(Wall.Type, Wall.ActionCreate, wall)
}
