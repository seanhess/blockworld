function Fault(type, message) {
    this.type = type
    this.message = message
}

Fault.JsonParsingError = 'json'
Fault.InvalidRoute = 'invalid.route'
Fault.InvalidData = 'invalid.data'
Fault.InvalidMethod = 'invalid.method'
Fault.BadController = 'bad.controller'
Fault.MissingDelimiters = 'missing.delimiters'
Fault.MissingRoute = 'missing.route'


module.exports = Fault