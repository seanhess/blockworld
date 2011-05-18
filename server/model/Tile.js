// Tiles 

var assert = require('assert')



var mongo = require('mongo')
var db = mongo.db("localhost", 27017, "bb")
db.collection('tiles')


exports.mixinTo = function(Class) {

    assert.ok(Class, "Missing class for Tile mixin")

    Class.prototype.tiles = Class.tiles = function() {
        return db.tiles
    }
    
    Class.prototype.type = function(value) {
        if (value) this.source.type = value
        return this.source.type
    }
    
    Class.prototype.position = function(x, y) {
        this.source.x = x
        this.source.y = y
    }
    
    Class.prototype.x = function () {
        return this.source.x
    }

    Class.prototype.y = function () {
        return this.source.y
    }    
    
    Class.prototype.toValue = function() {
        return this.source
    }
    
}

exports.tileId = function(x, y) {
    return x + "|" + y
}




