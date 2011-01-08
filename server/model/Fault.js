function Fault(type, message) {
    this.type = type
    this.message = message
}

Fault.JsonParsingError = 'json'
Fault.InvalidRoute = 'invalid.route'
Fault.InvalidData = 'invalid.data'
Fault.BadController = 'bad.controller'

module.exports = Fault