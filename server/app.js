var sys = require('sys')

var net = require('net')
var path = require('path')


var Fault = require('./model/Fault')
var Client = require("./model/Client")
var sys = require("sys")

var log = require("./utils/log")

var App = module.exports = function() {
    
    var localPort
	var clients = {}
	
	this.sendAll = function (route, data) {
		var clientsLength = clients.length
		for(var clientId in clients) {
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
        var client = new Client(self, stream)
		self.addClient(client)
		client.send("Hello")

        client.onMessage(function(route, data) {
            
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
                method(this, client, data)
            }
            catch (err) {
                return client.sendFault(Fault.BadController, "Bad Controller " + route + " with Error " + err)
            }
        })
		
		client.onEnd(function () {
			self.removeClient(client)
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

if (module == require.main) {
    var app = new App()
    App.puts("App Start Main - " + App.DefaultPort)
    app.start(App.DefaultPort)
}
