var sys = require("sys")
var Message = require("../model/Message")
var Fault = require("../model/Fault")
var assert = require('assert')
var Wall = require("../model/Wall")
var Bomb = require("../model/Bomb")
var _ = require("underscore")

exports.create = function (app, client, data) {

    assert.ok(!_(data.x).isUndefined(), "Missing X")
    assert.ok(!_(data.y).isUndefined(), "Missing Y")    
    
    var bomb = new Bomb(data.x, data.y)
    
    // add the bomb
    app.state().add(bomb)
    
    // send it out
    app.sendOthers(client, new Bomb.MessageCreate(bomb))
    
    // schedule it for detonation
    app.timer().scheduleAhead(Bomb.Delay, function() {
        
        // var playersHit = bomb.hitTest(app.state(), Player.Type)
        // var wallsHit = bomb.hitTest(app.state(), Wall.Type)
        //         
        // var messages = [new Bomb.MessageDetonate].concat()
        
        app.sendAll(new Bomb.MessageDetonate(bomb))
        
        // check for hits! 
        // calculate surrouding tiles
        
    })
}