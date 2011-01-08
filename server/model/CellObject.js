var sys = require('sys')

var type = ''
var attributes = {}

function CellObject(data){
    this.type = data.type
    this.attributes = data.attributes
}