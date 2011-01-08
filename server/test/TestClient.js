
// Test TestClient. Connects to server

var net = require("net")
var sys = require('sys')
var packetParser = require('../model/PacketParser')
var App = require('../app')
var traffic = require("../utils/traffic")


var TestClient = module.exports = function() {
    
    var stream = new net.Stream()
    var onMessage, onError, onFault
    
    var packetParser = new PacketParser()
    packetParser.onPacket(function(packet) {
        // traffic.log("Data Packet " + packet)
        var message = JSON.parse(packet)

        if (message.fault) {
            if (onFault) onFault(message)
        }
        else if (onMessage) {
            onMessage(message)
        }
    })
            
    stream.on('data', function(data) {
        // traffic.log("Data IN " + data)
        packetParser.addData(data)
    })
    
    stream.on('error', function(err) {
        if (onError) onError(err)
        else throw err
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
    
    this.end = function() {
        stream.end()
    }
    
    this.send = function(message) {
        var payload = JSON.stringify(message)
        this.sendRaw(payload)
    }
    
    this.sendRaw = function(data) {
        // traffic.log("Data OUT (" + data+")")
        stream.write(data + "\n", "utf8")
    }
    
}