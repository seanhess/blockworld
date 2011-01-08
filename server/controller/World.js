var sys = require('sys')
var Cell = require("../model/Cell")
var CellObject = require("../model/CellObject")

var Cells = []


// Returns all players, bombs, in a range
// @x1: the top left point
// @y1: the top left point
// @x2: the lower right point
// @y2: the lower right point
exports.getLayout = function(data, cb){
    // Invalid input checks
    if(!data)
        return cb ({"error":"missing parameters"}, null)
    if(data.x1>data.x2)
        return cb ({"error":"invalid x parameters"}, null)
    if(data.y1>data.y2)
        return cb ({"error":"invalid y parameters"}, null)
    
    var result = []
    
    // Get data in section of world
    for(var x = data.x1; x<=data.x2; x++){
        if (!Cells[x]){
            Cells[x] = []
            continue
        }
        for (var y = data.y1; y<=data.y2; y++){
            if(!Cell[x][y]) 
                continue
            var cell = Cells[x][y]
            cell.x = x
            cell.y = y
            result.push(cell)
        }
    }
    return cb (null, result)
}

// *player
// x1
// y1
// x2
// y2
exports.movePlayer = function(data, cb){
    Cells[data.x1][data.y1].removePlayer(data.player.id)
    Cells[data.x2][data.y2].addPlayer(data.player)
}

// data.type: supposed to be 'bomb' or 'wall'
// data.attributes: contains '{"player":player, "duration":"5"}' among other things
exports.setObject = function(data, cb){
    var cell = Cells[x][y]
    if(!cell)
        cell = new Cell(x, y)
    cell.objects.push(new CellObject(data))
}
