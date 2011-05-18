// Tiles 

var assert = require('assert')

var mongo = require('mongo')
var db = mongo.db("localhost", 27017, "bb")
db.collection('tiles')


var Tile = module.exports = function(type) {
    this.source = {} // make sure you call Tile.call(this)!
    this.type(type)
}

Tile.fromValue = function(Class, value) {
    var obj = new Class()
    obj.source = value
    return obj
}

Tile.prototype.tiles = Tile.tiles = function() {
    return db.tiles
}

Tile.prototype.type = function(value) {
    if (value) this.source.type = value
    return this.source.type
}

Tile.prototype.position = function(x, y) {
    this.source.x = x
    this.source.y = y
}

Tile.prototype.x = function () {
    return this.source.x
}

Tile.prototype.y = function () {
    return this.source.y
}    

Tile.prototype.toValue = function() {
    return this.source
}

Tile.tileId = function(x, y) {
    return x + "|" + y
}

Tile.clearAll = function() {
    db.tiles.remove({})
}

Tile.allWithClass = function(Class, cb) {
    Tile.tiles().find({type:Class.Type}).toArray(function(err, tiles) {
        if (err) return cb(err)
        cb(null, tiles.map(function(tile) {
            return Class.fromValue.call(Class, tile)
        }))
    })    
}

Tile.tilesInRange = function(range, cb) {
    
    // can't return classes with circular dependency
    Tile.tiles().find(range).toArray(cb)
}



