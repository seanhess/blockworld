var sys = require("sys")
var Message = require("../model/Message")
var Fault = require("../model/Fault")
var assert = require('assert')
var Wall = require("../model/Wall")
var _ = require("underscore")

// Block Data Format / Map Data Format


// Add a wall tile?
exports.addWall = function (app, client, data) {
    
    assert.ok(!_(data.x).isUndefined(), "Missing X")
    assert.ok(!_(data.y).isUndefined(), "Missing Y")    
    
    var wall = new Wall(data.x, data.y)
    
    // add the player
    app.state().add(wall)
    
    app.sendOthers(client, new Wall.MessageAddWall(wall))
    
}