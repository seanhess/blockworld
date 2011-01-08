function Fault(type, message) {
    this.fault = type
    this.message = message
}

Fault.JsonParsingError = 'json'
Fault.InvalidType = 'invalid.type'
Fault.InvalidMethod = 'invalid.method'
Fault.InvalidData = 'invalid.data'
Fault.ControllerFault = 'bad.controller'


module.exports = Fault