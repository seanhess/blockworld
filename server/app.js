var sys = require('sys')

var net = require('net')
var path = require('path')


var Fault = require('./model/Fault')
var Client = require("./model/Client")
var World = require("./model/World")
var sys = require("sys")

var App = module.exports = function() {
    
    var localPort
	var clients = {}
	var open = false
	
	var world = new World()
	
	this.world = function() {
	    return world
	}
	
	this.sendAll = function(route, data) {
		for(var clientId in clients) {
			clients[clientId].send(route, data)
		}
	}
	
	this.sendOthers = function(client, route, data) {
		for(var clientId in clients) {
		    if (clientId != client.id())
			    clients[clientId].send(route, data)
		}
	}

	this.addClient = function (client) {
		clients[client.id()] = client
	}
	
	this.removeClient = function (client) {
		delete clients[client.id()]
	}
    
    var self = this
    
    var server = new net.Server()
    
    server.on('connection', function(stream) {
        
        // self.resetTimeout()
        
        var client = new Client(self, stream)
		self.addClient(client)
		client.send("Hello")

        client.onMessage(function(route, data) {
            
            // self.resetTimeout()            
            
            var split = route.split(".")
        
            try {
                var modulePath = path.join(__dirname, 'controller', split[0])
                var module = require(modulePath) 
            }
            catch (err) {
                return client.sendFault(Fault.InvalidRoute, "Invalid Route - Couldn't find module: " + route + " " + modulePath)
            }

            if (!split[1]) 
                return client.sendFault(Fault.InvalidRoute, "Invalid Route - Couldn't split route: " + route)

            var method = module[split[1]]
            
            if (!method)
                return client.sendFault(Fault.InvalidMethod, "Bad Method " + route)
                
            if (!data)
                return client.sendFault(Fault.InvalidData, "No Data")                

            try {
                method(self, client, data)
            }
            catch (err) {
                sys.puts(err + "\n" + err.stack)
                return client.sendFault(Fault.BadController, "Controller Fault " + route)
            }
        })
		
		client.onEnd(function () {
			self.removeClient(client)
		})
		
    })
    
    server.on('close', function() {
        sys.puts("Closed " + localPort)
    })

    this.start = function(port, cb) {
        localPort = port
        sys.puts("Open " + localPort)
        server.listen(localPort, 'localhost', function() {
            open = true
            if (cb) cb()
        })
    }
    
    this.close = function() {
        sys.puts("Close " + localPort)
        server.close()
        open = false
    }
    

    // // Auto Close the stupid thing
    // var interval
    // 
    // this.resetTimeout = function() {
    //     if (interval) this.timeout()
    // }
    // 
    // this.timeout = function() {
    //     if (interval) clearTimeout(interval)
    //     function onTimeout() {
    //         sys.puts("Timeout Close " + localPort + " "+ open)
    //         if (open) self.close()
    //     }
    //     interval = setTimeout(onTimeout, 100)
    // }
}

// App.OpenDelimiter = "<<<"
// App.CloseDelimiter = ">>>"
App.DefaultPort = 3000

if (module == require.main) {
    var app = new App()
    sys.puts("App Start Main - " + App.DefaultPort)
    app.start(App.DefaultPort)
}
