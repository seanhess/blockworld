var sys = require("sys")
var Message = require("../model/Message")
var Fault = require("../model/Fault")
var assert = require('assert')
var Wall = require("../model/Wall")
var Bomb = require("../model/Bomb")
var Player = require("../model/Player")
var Tile = require('../model/Tile')
var _ = require("underscore")

exports.create = function (app, client, data) {

    assert.ok(!_(data.x).isUndefined(), "Missing X")
    assert.ok(!_(data.y).isUndefined(), "Missing Y")    
    
    var bomb = new Bomb(data.x, data.y, data.playerId)
    
    // add the bomb
    bomb.create(function(success) {

        // send it out 
        app.sendAll(new Bomb.MessageCreate(bomb))    
    })
        
    // schedule it for detonation
    app.timer().scheduleAhead(Bomb.Delay, function() {
        Bomb.exists(bomb, function(exists) {
            if (!exists) return; // bomb has already detonated
            detonate(app, bomb)        
        })
    })
}

function detonate(app, bomb) {
    var range = bomb.hitArea()
    
    var docs = Tile.tilesInRange(range, function(err, tileDocs) {
    
        // Convert them. There's probably a better place for this

        var tiles = tileDocs.map(function(doc) {
            
            var Class = null
            
                 if (doc.type == Player.Type) Class = Player
            else if (doc.type == Bomb.Type) Class = Bomb
            else if (doc.type == Wall.Type) Class = Wall
            else throw new Error("missing type " + doc.type)
            
            return Class.fromValue.call(Class, doc)
            
        })

        tiles.forEach(function(tile) {
            destroyTile(app, tile)
        })      
    })       
}

// Called from within bomb.create
function destroyTile(app, tile) {
    
    // remove the bomb
    tile.remove(function() {})
    
    // send destroy message
    app.sendAll(new Message(tile.type(), "destroy", tile))
    
    // check for bomb chain reactions
    if (tile instanceof Bomb) {
        detonate(app, tile)
    }
}
