var sys = require('sys')


exports.something = function(app, client, data) {
    // sys.puts("Something!")
}

exports.ping = function(app, client, data) {
    client.send("pong", data)
}

exports.throwSomething = function(data) {
    throw new Error("You should catch this")
}