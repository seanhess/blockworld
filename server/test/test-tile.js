var Player = require("../model/Player")
var Wall = require("../model/Wall")
var Tile = require('../model/Tile')

exports.sources = function(assert) {

    var tile = new Tile()
    assert.ok(tile.source, "Constructor did not create source")

    var player = new Player("nick", 10, 10)
    assert.equal(player.x(), 10)
    assert.equal(player.y(), 10)
    assert.ok(player.uid())
    
    var wall = new Wall(5, 5)
    assert.notEqual(player.source, wall.source, "Sources are shared between objects")
    assert.ok(wall.uid())
    assert.notEqual(player.uid(), wall.uid(), "Uids are the same for the wall")
    assert.finish()
    
}