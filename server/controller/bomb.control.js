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
    
    var bomb = new Bomb(data.x, data.y, data.playerId)
    
    // add the wall
    bomb.create(function(success) {
    
    })
    
    // send it out immediately
    app.sendOthers(client, new Bomb.MessageCreate(bomb))
    
    // schedule it for detonation
    app.timer().scheduleAhead(Bomb.Delay, function() {
    
        exports.detonate(app, client, bomb.toValue())
        
    })
}

exports.detonate = function(app, client, bomb) {
    
    // remove the bomb
    var bomb = Bomb.fromValue(bomb)
    bomb.remove(function() {})
    
    // send the destroy message
    app.sendAll(new Bomb.MessageDetonate(bomb))
}
