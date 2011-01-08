var sys = require('sys')
var Player = require ('Player')


// All the users
var Players = []


exports.create = function(data, cb){
    // Create a player
    var player = new Player()
    player.setName(data.name)
    
    
    Players.push(player)
    cb userId
}