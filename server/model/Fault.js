var Fault = module.exports = function(type, message) {
    this.fault = type
    this.message = message
}

Fault.prototype.toString = function() {
    return this.fault + " " + this.message
}

Fault.JsonParsingError = 'json'
Fault.InvalidType = 'invalid.type'
Fault.InvalidMethod = 'invalid.method'
Fault.InvalidData = 'invalid.data'
Fault.ControllerFault = 'bad.controller'
