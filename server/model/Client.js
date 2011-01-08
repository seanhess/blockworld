
// Test Client. Connects to server

var net = require("net")
var app = require("../app")
var sys = require('sys')
var packetParser = require('./PacketParser')

function Client() {
    
    var stream = new net.Stream()
    var onMessage, onError, onFault
    
    var packetParser = new PacketParser()
    packetParser.onPacket(function(packet) {
        var message = JSON.parse(packet)

        if (message.fault && onFault) {
            onFault(message.fault.type, message.fault.message)
        }
        else if (onMessage) {
            onMessage(message.route, message.data)                            
        }
    })
            
    stream.on('data', function(data) {
        packetParser.addData(data)
    })
    
    stream.on('error', function(err) {
        if (onError) onError(err)
    })
    
    this.connect = function(cb) {
        stream.connect(app.port)
        stream.on('connect', function() {
            cb()
        })
    }
    
    this.onError = function(cb) {
        onError = cb
    }
    
    this.onMessage = function(cb) {
        onMessage = cb
    }    
    
    this.onFault = function(cb) {
        onFault = cb
    }
    
    this.close = function() {
        stream.close()
    }
    
    this.send = function(route, data) {
        var payload = JSON.stringify({route:route, data:data})
        stream.write(payload, "utf8")
    }
    
    this.sendRaw = function(data) {
        stream.write(data, "utf8")
    }
    
}

module.exports = Client