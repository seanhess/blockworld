// Stateable items must have:
// .uid()
// .toMessage()

var assert = require('assert')
var _ = require("underscore")

// models
var Wall = require('../model/Wall')
var Tile = require('../model/Tile')



var GameState = module.exports = function() {
    this.everything = {}
    this.tiles = {}
}

GameState.verify = function(item) {
    if (!_(item.uid).isFunction() || !item.uid()) return false
    if (!_(item.toMessage).isFunction() || !item.toMessage()) return false
    return true
}

GameState.prototype.allMessages = function() {
    var messages = []
    for (var uid in this.everything) {
        messages.push(this.everything[uid].toMessage())
    }
    return messages
}

GameState.prototype.add = function(item, persist) {
    assert.ok(!this.exists(item.uid()))
    this.everything[item.uid()] = item
    
    // keep track of where things are
    if (item instanceof Tile) {
        this.moveTo(item, item.x(), item.y())
    }

//    if (persist) {
//        var value = item.toValue()
//        value._id = item.uid()
//        value.type = item.type()
//        db.state.save(value)
//    }
}

GameState.prototype.remove = function(item, persist) {
    delete this.everything[item.uid()]
    
    if (persist) {
        db.state.remove({_id:item.uid()})
    }
}

GameState.prototype.moveTo = function(item, x, y) {
    
    // Clear the old spot, then update the tile index
    // Must be called before updating the object itself
    
    var oldId = Tile.tileId(item.x(), item.y())
    var newId = Tile.tileId(x, y) 
    
    delete this.tiles[oldId]
    this.tiles[newId] = item
    
}

GameState.prototype.exists = function(uid) {
    return (!!this.everything[uid])
}

GameState.prototype.fetch = function(uid) {
    return this.everything[uid]
}

GameState.prototype.hitObjects = function(hitArea) {

    var hit = []
    var self = this

    hitArea.forEach(function(point) {
        
        // probably not the best way, but I need to get the uids back
        
        var tileId = Tile.tileId(point.x, point.y)
        if (self.tiles[tileId]) 
            hit.push(self.tiles[tileId])
            
    })
    
    return hit
    
}

GameState.prototype.loadFromDb = function(cb) {
    return cb()
}


// Then build any other indexes you need as you go along

