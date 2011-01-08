var App = require("../App")

var Client = module.exports = function(app, stream) {

    this.sendMessage = function(route, data) {
        app.sendMessageToStream(stream, route, data)
    }
    
    this.sendFault = function(type, message) {
        app.sendFaultToStream(stream, type, message)
    }
    
}