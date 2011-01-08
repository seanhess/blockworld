var App = require("../App")
var Fault = require('./Fault')
var PacketParser = require('./PacketParser')
var sys = require('sys')
var Message = require('./Message')
var traffic = require("../utils/traffic")
var _ = require("underscore")

var Client = module.exports = function(app, stream) {
    var onMessage, onEnd
    var self = this
    var packetParser = new PacketParser()
    stream.setEncoding('utf8')


    
    stream.on('data',function(data) {
        traffic.log(" >>> " + data)
        packetParser.addData(data)
    })
    
    stream.on('end',function() {
		if(onEnd) onEnd()
        stream.end()
    })
    
    stream.on('timeout', function() {
        traffic.log("Stream timeout")
    })
    
    stream.on('error', function(err) {
        traffic.log("Stream Error " + err)
    })
    
    stream.on('close', function(err) {
        // traffic.log("Stream Close " + err)
    })    
    
    // stream.on('drain', function() {
    //     traffic.log("Drai")
    // })    
    
    // PARSING PACKETS    
    packetParser.onPacket(function(packet) {

        try {
            var message = JSON.parse(packet)            
        }
        catch (err) {
            return self.send(new Fault(Fault.JsonParsingError, "Could not parse: " + packet + " with error " + err))
        }
        
        var type = message.type        
        var action = message.action
        var data = message.data
        
        if(!type) return self.send(new Fault(Fault.InvalidType, "Missing Type: " + packet))
        if(!action) return self.send(new Fault(Fault.InvalidMethod, "Missing Action: " + packet))
        if(!data) return self.send(new Fault(Fault.InvalidData, "Missing Data: " + packet))
        
        if (onMessage) 
            onMessage(new Message(type, action, data))
    })

    
    

    // SENDING STUFF
    this.send = function(objOrArray) {
        
        if (_(objOrArray).isArray()) {
            for (var i in objOrArray) {
                this.send(objOrArray[i])
            }            
        }
        
        else {
            // var payload = (obj.toJSON) ? obj.toJSON() : JSON.stringify(obj)
            var payload = JSON.stringify((objOrArray.toValue) ? objOrArray.toValue() : objOrArray)
            traffic.log(" <<< " + payload)
            stream.write(payload + "\n")        
        }
    }
    
    this.id = function() {
        return stream.fd
    }
    
    this.onMessage = function(cb) {
        onMessage = cb
    }

	this.onEnd = function (cb) {
		onEnd = cb
	}
}