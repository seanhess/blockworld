var sys = require('sys')
var Message = require("../model/Message")


exports.something = function(app, client, data) {
    // sys.puts("Something!")
}

exports.ping = function(app, client, data) {
    client.send(new Message("pong", "default", data))
}

exports.throwSomething = function(data) {
    throw new Error("You should catch this")
}