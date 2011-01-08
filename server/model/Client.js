var App = require("../App")
var Fault = require('./Fault')
var PacketParser = require('./PacketParser')
var sys = require('sys')
var log = require("../utils/log")

var Client = module.exports = function(app, stream) {
    var self = this
    var onMessage, onConnect
    
    stream.setEncoding('utf8')


    // PARSING PACKETS
    var packetParser = new PacketParser()
    
    stream.on('data',function(data) {
        log(" >>> " + data)
        var result = packetParser.addData(data)
        
        if (!result) return self.sendFault(Fault.MissingDelimiters, "Missing delimiters: " + packetParser.data())
    })
    
    packetParser.onPacket(function(packet) {

        try {
            var message = JSON.parse(packet)            
        }
        catch (err) {
            return self.sendFault(Fault.JsonParsingError, "Could not parse: " + packet + " with error " + err)
        }
        
        var route = message.route
        
        if(!route) return self.sendFault(Fault.MissingRoute, "Missing Route: " + packet)
        
        var data = message.data
        
        if (onMessage) 
            onMessage(route, data)
    })
    
    
    
    // ON EXIT
    stream.on('end',function() {
        message('goodbye')
        stream.end()
    })
    
    stream.on('timeout', function() {
        log("Stream timeout")
    })
    
    stream.on('error', function(err) {
        log("SERVER ERROR " + err)
    })
    
    stream.on('close', function(err) {
        log("Stream Close " + err)
    })    
    
    

    
    // stream.on('drain', function() {
    //     log("Drai")
    // })    

    // SENDING STUFF
    function send(obj) {
        var payload = JSON.stringify(obj).replace(/<<</g,"<x<").replace(/>>>/g,">x>")
        log(" <<< " + payload)
        stream.write(App.OpenDelimiter + payload + App.CloseDelimiter)        
    }

    this.sendMessage = function(route, data) {
        data = data || ""
        send({route:route, data:data})
    }
    
    this.sendFault = function(type, message) {
        send({fault:new Fault(type, message)})        
    }
    
    this.id = function() {
        return stream.fd
    }
    
    this.onMessage = function(cb) {
        onMessage = cb
    }
    
    this.onConnect = function(cb) {
        onConnect = cb
    }
}