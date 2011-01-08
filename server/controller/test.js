var Board = require("Board")
var Player = require("Player").Player

var board = new Board()

exports.something = function(data) {
    sys.puts("Something!")
}

exports.SomeClass = function() {
    this.name = "hello"
}

var bob = new exports.SomeClass()