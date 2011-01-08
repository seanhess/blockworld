var App = require("../App")
var Fault = require('./Fault')
var PacketParser = require('./PacketParser')
var sys = require('sys')

var Client = module.exports = function(app, stream) {
    var self = this
    var onMessage, onEnd
    
    stream.setEncoding('utf8')


    // PARSING PACKETS
    var packetParser = new PacketParser()
    
    stream.on('data',function(data) {
        sys.puts(" >>> " + data)
        packetParser.addData(data)
        // var result = packetParser.addData(data)
        
        // if (!result) return self.sendFault(Fault.MissingDelimiters, "Missing delimiters: " + packetParser.data())
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
		if(onEnd) onEnd()
        stream.end()
    })
    
    stream.on('timeout', function() {
        sys.puts("Stream timeout")
    })
    
    stream.on('error', function(err) {
        sys.puts("SERVER ERROR " + err)
    })
    
    stream.on('close', function(err) {
        sys.puts("Stream Close " + err)
    })    
    
    

    
    // stream.on('drain', function() {
    //     sys.puts("Drai")
    // })    

    // SENDING STUFF
    function send(obj) {
        var payload = JSON.stringify(obj)//.replace(/<<</g,"<x<").replace(/>>>/g,">x>")
        sys.puts(" <<< " + payload)
        stream.write(payload + "\n")        
    }

    this.send = function(route, data) {
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

	this.onEnd = function (cb) {
		onEnd = cb
	}
}