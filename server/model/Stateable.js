// Abstract Base class
// Need to implement .toMessage to work with GameState

var Stateable = module.exports = function() {
    this.source = {} 
}

Stateable.prototype.type = function() {
    throw new Error("Implement .type()")
}

Stateable.prototype.toValue = function() {
    return this.source
}

Stateable.prototype.uid = function(value) {
    if (value) this.source.uid = value
    return this.source.uid
}

Stateable.prototype.toMessage = function() {
    throw new Error("Implement .toMessage()")
}

