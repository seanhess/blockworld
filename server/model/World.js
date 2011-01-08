

var World = module.exports = function() {
    this.players = {}
}

World.prototype.getPlayerById = function(id) {
    return this.players[id]
}

World.prototype.addPlayer = function(player) {
    this.players[player.id()] = player
}

// function getRandomPlayerId () {
//  var newPlayerId
//  while (Players[newPlayerId = generatePlayerId(newPlayerId)]) {}
//  return newPlayerId
// }