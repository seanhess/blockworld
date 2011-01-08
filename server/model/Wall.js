var Message = require("./Message")


var Wall = module.exports = function(x, y) {
    this.source = {uid:x + "|" + y, x:x, y:y}
}

Wall.prototype.toValue = function() {
    return this.source
}

Wall.prototype.uid = function() {
    return this.source.uid
}

Wall.prototype.type = function() {
    return Wall.Type
}

Wall.prototype.toMessage = function() {
    return new Wall.MessageAddWall(this)
}

Wall.prototype.x = function() {
    return this.source.x
}

Wall.prototype.y = function() {
    return this.source.y
}

Wall.Type = "map"
Wall.ActionAddWall = "addWall"

Wall.MessageAddWall = function(wall) {
    return new Message(Wall.Type, Wall.ActionAddWall, wall)
}
