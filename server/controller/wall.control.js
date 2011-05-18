var sys = require("sys")
var Message = require("../model/Message")
var Fault = require("../model/Fault")
var assert = require('assert')
var Wall = require("../model/Wall")
var Bomb = require("../model/Bomb")
var _ = require("underscore")


// Add a wall tile
exports.create = function (app, client, data) {
    
    assert.ok(!_(data.x).isUndefined(), "Missing X")
    assert.ok(!_(data.y).isUndefined(), "Missing Y")    
    
    var wall = new Wall(data.x, data.y)

    console.log("ADDING WALL", data, wall.toValue())
    
    // add the wall
    app.state().add(wall, true)
    
    // send it out
    app.sendOthers(client, new Wall.MessageCreate(wall))
}