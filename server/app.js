var sys = require('sys')

var net = require('net')
var path = require('path')


var Fault = require('./model/Fault')
var PacketParser = require('./model/PacketParser')
var sys = require("sys")

var streamerer = require("./streamerer.js")

var App = module.exports = function() {
    
    var localPort
    
    var server = net.createServer(function(stream) {
		streamerer.add(stream)
        // METHODS TO SEND
        function send(obj) {
            var payload = JSON.stringify(obj).replace(/<<</g,"<x<").replace(/>>>/g,">x>")
            App.puts(" <<< " + payload)
            stream.write(App.OpenDelimiter + payload + App.CloseDelimiter)
        }

        function message(type, data) {
            data = data || ""
            send({route:type, data:data})
        }

        function fault(type, message) {
            send({fault:new Fault(type, message)})
        }

        // RECEIVE
        stream.setEncoding('utf8')

        stream.on('connect',function() {
            message('hello')
        })
        
        stream.on('end', function() {
            App.puts("Stream End")
        })
        
        stream.on('timeout', function() {
            App.puts("Stream timeout")
        })
        
        // stream.on('drain', function() {
        //     App.puts("Drai")
        // })
        
        stream.on('error', function(err) {
            App.puts("SERVER ERROR " + err)
        })
        
        stream.on('close', function(err) {
            App.puts("Stream Close " + err)
        })


        // ROUTING
        var packetParser = new PacketParser()

        packetParser.onPacket(function(packet) {
            
            App.puts("SERVER PACKET " + packet)

            // parse
            try {
                var message = JSON.parse(packet)            
            }
            catch (err) {
                return fault(Fault.JsonParsingError, "Could not parse: " + packet + " with error " + err)
            }

            var route = message.route
            
            if(!route) return fault(Fault.MissingRoute, "Missing Route: " + packet)
            
            var data = message.data

            var split = route.split(".")

            try {
                var modulePath = path.join(__dirname, 'controller', split[0])
                var module = require(modulePath) 
            }
            catch (err) {
                return fault(Fault.InvalidRoute, "Invalid Route - Couldn't find module: " + route + " " + modulePath)
            }

            if (!split[1]) 
                return fault(Fault.InvalidRoute, "Invalid Route - Couldn't split route: " + route)

            var method = module[split[1]]
            
            if (!method)
                return fault(Fault.InvalidMethod, "Bad Method " + route)
                
            if (!data)
                return fault(Fault.InvalidData, "No Data")                

            try {
                method(this, data)
            }
            catch (err) {
                return fault(Fault.BadController, "Bad Controller " + route + " with Error " + err)
            }
        })

        stream.on('data',function(data) {
            App.puts(" >>> " + data)
            var result = packetParser.addData(data)
            
            if (!result) return fault(Fault.MissingDelimiters, "Missing delimiters: " + packetParser.data())
        })

        stream.on('end',function() {
            message('goodbye')
            stream.end()
        })
    })
    
    server.on('close', function() {
        // App.puts("Closed " + localPort)
    })

    this.start = function(port, cb) {
        localPort = port
        // App.puts("Open " + localPort)
        server.listen(localPort, 'localhost', cb)
    }
    
    this.close = function() {
        // App.puts("Close " + localPort)
        server.close()
    }
}

App.OpenDelimiter = "<<<"
App.CloseDelimiter = ">>>"
App.DefaultPort = 3000

App.puts = sys.puts
App.log = sys.log

if (module == require.main) {
    var app = new App()
    App.puts("App Start Main - " + App.DefaultPort)
    app.start(App.DefaultPort)
}
