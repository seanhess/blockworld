// Stateable items must have:
// .uid()
// .toMessage()

var assert = require('assert')
var _ = require("underscore")


var GameState = module.exports = function() {
    this.everything = {}
}

GameState.verify = function(item) {
    if (!_(item.uid).isFunction() || !item.uid()) return false
    if (!_(item.toMessage).isFunction() || !item.toMessage()) return false
    return true
}

GameState.prototype.allMessages = function() {
    var messages = []
    for (var uid in this.everything) {
        messages.push(this.everything[uid].toMessage())
    }
    return messages
}

GameState.prototype.add = function(item) {
    assert.ok(!this.exists(item.uid()))
    this.everything[item.uid()] = item
}

GameState.prototype.remove = function(item) {
    delete this.everything[item.uid()]
}

GameState.prototype.exists = function(uid) {
    return (!!this.everything[uid])
}

GameState.prototype.fetch = function(uid) {
    return this.everything[uid]
}


// Then build any other indexes you need as you go along

