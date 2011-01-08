var sys = require('sys')


exports.something = function(data) {
    // sys.puts("Something!")
}

exports.throwSomething = function(data) {
    throw new Error("You should catch this")
}