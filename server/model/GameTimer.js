var assert = require('assert')
var sys = require("sys")


var GameTimer = module.exports = function() {
    this.schedule = new GameTimer.Schedule()
}

GameTimer.prototype.start = function() {
    assert.ok(!this.interval, "Tried to start game timer twice")
    var self = this
    this.interval = setInterval(function() {
        
        /// This is the big tick /// 
        var tickIndex = GameTimer.currentTickIndex()
        
        var scheduledActions = self.schedule.actionsForTick(tickIndex)
        
        for (var i in scheduledActions) {
            var action = scheduledActions[i]
            action()
        }
        
    }, GameTimer.MsPerTick)
}

GameTimer.prototype.stop = function() {
    clearInterval(this.interval)
    this.interval = null
}


// Schedule something x milliseconds into the future
// This isn't particularly accurate, but it is easy and fast
// and probably won't matter

GameTimer.prototype.scheduleAhead = function(ms, action) {
    
    // could cause problems later
    assert.ok(action, "Action was not defined")
    
    // schedule it ahead on a tick
    var currentTime = (new Date()).getTime()
    var scheduledTime = currentTime + ms
    var scheduledTickIndex = GameTimer.msToTickIndex(scheduledTime)
    this.schedule.add(scheduledTickIndex, action)
}

// 1000 should be 10 ticks
GameTimer.msToTickIndex = function(ms) {    
    return (ms - ms % GameTimer.MsPerTick)
}

GameTimer.currentTickIndex = function() {
    var ms = (new Date()).getTime()
    return GameTimer.msToTickIndex(ms)
}

GameTimer.MsPerTick = 100







GameTimer.Schedule = function() {
    this.actions = {}
}

GameTimer.Schedule.prototype.add = function(tickIndex, action) {
    if (!this.actions[tickIndex]) this.actions[tickIndex] = []
    this.actions[tickIndex].push(action)
}

GameTimer.Schedule.prototype.removeAllForTick = function(tickIndex) {
    delete this.actions[tickIndex]
}

GameTimer.Schedule.prototype.actionsForTick = function(tickIndex) {
    return this.actions[tickIndex]
}