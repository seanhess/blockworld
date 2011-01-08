var sys = require('sys')

var x
var y
var players = {}
var objects = []

function Cell(x, y){
    this.x = x
    this.y = y
}

exports.removePlayer = function(playerId, cb){
    delete players[playerId]
}

exports.addPlayer = function(player, cb){
    players[player.id] = player
}