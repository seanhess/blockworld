var sys = require('sys')

var net = require('net')
var path = require('path')


var Fault = require('./model/Fault')
var Client = require("./model/Client")
var World = require("./model/World")
var Message = require("./model/Message")
var sys = require("sys")
var traffic = require("./utils/traffic")

var App = module.exports = function() {
    
	var clients = {}
	var open = false
	
	var world = new World()
	
	this.world = function() {
	    return world
	}
	
	this.resetStateForTesting = function() {
	    // should only be called from testing
	    world = new World()
	    clients = {}
	}
	
	this.sendAll = function(message) {
		for(var clientId in clients) {
			clients[clientId].send(message)
		}
	}
	
	this.sendOthers = function(client, message) {
		for(var clientId in clients) {
		    if (clientId != client.id())
			    clients[clientId].send(message)
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
		client.send(new Message("Welcome"))

        client.onMessage(function(message) {
            
            try {
                var filename = message.type.toLowerCase() + ".control"
                var modulePath = path.join(__dirname, 'controller', filename)
                var module = require(modulePath) 
            }
            catch (err) {
                return client.send(new Fault(Fault.InvalidType, "Invalid Type - Couldn't find module: " + message + " " + modulePath))
            }

            var method = module[message.action]
            
            if (!method)
                return client.send(new Fault(Fault.InvalidMethod, "Invalid Method " + message))
                
            if (!message.data)
                return client.send(new Fault(Fault.InvalidData, "No Data"))   

            try {
                method(self, client, message.data)
            }
            catch (err) {
                traffic.log(err + "\n" + err.stack)
                return client.send(new Fault(Fault.ControllerFault, "Controller Fault " + message))
            }
        })
		
		client.onEnd(function () {
			self.removeClient(client)
		})
		
    })
    
    server.on('close', function() {
        // traffic.log("Closed ")
    })

    this.start = function(port, cb) {
        // traffic.log("Open ")
        server.listen(port, 'localhost', function() {
            open = true
            if (cb) cb()
        })
    }
    
    this.close = function() {
        // traffic.log("Close ")
        server.close()
        open = false
    }
    


}

// App.OpenDelimiter = "<<<"
// App.CloseDelimiter = ">>>"
App.DefaultPort = 3000

if (module == require.main) {
    var app = new App()
    traffic.log("App Start Main - " + App.DefaultPort)
    app.start(App.DefaultPort)
}

// {"type":"Players","action":"create","data":{}}
