var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var GameTimer = require("../model/GameTimer")
var App = require("../App")
var Message = require("../model/Message")

exports.ticks = function(assert) {   
    var timer = new GameTimer()
    
    var tickIndex = GameTimer.currentTickIndex()
    assert.ok(tickIndex > 0, "Current Tick was undefined")
    assert.equal(tickIndex % GameTimer.MsPerTick, 0, "Current Tick didn't round")
    
    assert.finish()
}

exports.schedule = function(assert) {   
    var timer = new GameTimer()
    timer.start()
    
    var start = 1
    
    timer.scheduleAhead(100, function() {
        start += 1
        timer.scheduleAhead(100, function() {
            start += 1
            timer.scheduleAhead(100, function() {
                start += 1
            })
        })
    })    
    
    function finish() {
        assert.equal(start, 4, "Start didn't hit all the schedules " + start)
        assert.finish()
    }
    
    setTimeout(finish, 305)
}

