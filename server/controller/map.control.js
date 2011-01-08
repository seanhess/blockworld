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
    
    // add the wall
    app.state().add(wall)
    
    // send it out
    app.sendOthers(client, new Wall.MessageAddWall(wall))
}

exports.addBomb = function (app, client, data) {

    assert.ok(!_(data.x).isUndefined(), "Missing X")
    assert.ok(!_(data.y).isUndefined(), "Missing Y")    
    
    var bomb = new Bomb(data.x, data.y)
    
    // add the bomb
    app.state().add(bomb)
    
    // send it out
    app.sendOthers(client, new Bomb.MessageAddBomb(bomb))
    
    // schedule it for detonation
    app.timer().schedule(x, function() {
        app.sendAll(new Bomb.MessageDetonateBomb(bomb))
    })
}