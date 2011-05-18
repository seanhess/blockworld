var sys = require("sys")
var Message = require("../model/Message")
var Fault = require("../model/Fault")
var assert = require('assert')
var Wall = require("../model/Wall")
var Bomb = require("../model/Bomb")
var _ = require("underscore")


// Add a wall tile
exports.create = function (app, client, data) {

    var wall = new Wall(data.x, data.y)
    
    assert.ok(!_(wall.x()).isUndefined(), "Missing X")
    assert.ok(!_(wall.y()).isUndefined(), "Missing Y")    
    
    // add the wall
    wall.create(function(success) {
    
    })
    
    // send it out immediately
    app.sendOthers(client, new Wall.MessageCreate(wall))
}