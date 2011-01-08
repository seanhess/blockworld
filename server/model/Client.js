
// Test Client. Connects to server

var net = require("net")
var sys = require('sys')
var packetParser = require('./PacketParser')
var App = require('../app')



var Client = module.exports = function() {
    
    var stream = new net.Stream()
    var onMessage, onError, onFault
    
    var packetParser = new PacketParser()
    packetParser.onPacket(function(packet) {
        // Client.puts("Data Packet " + packet)
        var message = JSON.parse(packet)

        if (message.fault && onFault) {
            onFault(message.fault.type, message.fault.message)
        }
        else if (onMessage) {
            onMessage(message.route, message.data)                            
        }
    })
            
    stream.on('data', function(data) {
        // Client.puts("Data IN " + data)
        packetParser.addData(data)
    })
    
    stream.on('error', function(err) {
        if (onError) onError(err)
    })
    
    this.connect = function(port, cb) {
        stream.connect(port)
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
    
    this.sendRouteData = function(route, data) {
        var payload = JSON.stringify({route:route, data:data})
        this.sendRaw(App.OpenDelimiter + payload + App.CloseDelimiter)
    }
    
    this.sendRaw = function(data) {
        Client.puts("Data OUT " + data)
        stream.write(data, "utf8")
    }
    
}

Client.puts = sys.puts
Client.log = sys.log