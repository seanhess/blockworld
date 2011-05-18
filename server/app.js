var sys = require('sys')

var net = require('net')
var path = require('path')


var Fault = require('./model/Fault')

var GameState = require("./model/GameState")
// var GameTimer = require("./model/GameTimer")
var Message = require("./model/Message")
var sys = require("sys")
var traffic = require("./utils/traffic")

var io = require('socket.io')
var express = require('express')




var App = module.exports = function() {
    
    var self = this
    var server = null
    var socket = null    
    
	var state = new GameState()
    // var timer = new GameTimer()
	
	this.state = function() {
	    return state
	}
	
    // this.timer = function() {
    //     return timer
    // }
	
	this.resetStateForTesting = function() {
	    // should only be called from testing
	    state = new GameState()
        // timer = new GameTimer()
        // timer.start()
        
        if (socket) {
            socket.clients = socket.clientsIndex = {};
        }
	}
	
	this.sendAll = function(message) {
        socket.broadcast(message)
	}
	
	this.sendOthers = function(client, message) {
        client.broadcast(message)
	}
    
    
    
    
    this.start = function(port, cb) {
                    
        // web server
        server = express.createServer()
        
        server.get('/', function(req, res) {
            res.send("Hello World")
        })      
        
        server.get('/test', function(req, res) {
            res.sendfile(path.join(__dirname, "public", "test.html"))
        })        
        
        server.listen(port, cb)
        
        
        
        // socket
        
        socket = io.listen(server)
        
        socket.on('connection', function(client) {
                
            // welcome message
            client.send(new Message("Welcome"))

            client.on('message', function(message) {
                
                try {
                    var filename = message.type.toLowerCase() + ".control"
                    var modulePath = path.join(__dirname, 'controller', filename)
                    var module = require(modulePath) 
                }
                catch (err) {
                    return client.send(new Fault(Fault.InvalidType, "Invalid Type - Error Loading Module " + message + " " + modulePath + " " + err))
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
                    return client.send(new Fault(Fault.ControllerFault, "Controller Fault " + message + " _ \nWithError:" + err + "\n" + err.stack))
                }
            })
            
            client.on('disconnect', function () {
                console.log("Disconnected")
            })
            
        })
        
        server.on('close', function() {
            // traffic.log("Closed ")
        })              
    }    
    
    



    
    this.close = function() {
        server.close()
    }
    


}


App.DefaultPort = 3000

if (module == require.main) {
    var port = process.ARGV[2] || App.DefaultPort
    var app = new App()
    traffic.log("App Start Main - " + port)
    app.start(port)
}

