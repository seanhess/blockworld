var sys = require('sys')

var net = require('net')
var path = require('path')


var Fault = require('./model/Fault')

var GameState = require("./model/GameState")
var GameTimer = require("./model/GameTimer")
var Message = require("./model/Message")
var sys = require("sys")

// utils
var traffic = require("./utils/traffic")

// models
var Tile = require('./model/Tile')

// vendor
var io = require('socket.io')
var express = require('express')
var cluster = require('cluster')



var playerControl = require('./controller/player.control')

var App = module.exports = function() {
    
    var self = this
    var server = null
    var socket = null    
    
	var state = new GameState()
    var timer = new GameTimer()
    
    // clients -> players
    var players = {}
	
	this.state = function() {
	    return state
	}
	
    this.timer = function() {
        return timer
    }
    
    this.socket = function(mock) {
        if (mock) socket = mock
        return socket
    }
	
	this.resetStateForTesting = function() {
	    // should only be called from testing

	    state = new GameState()
        
        if (socket) {
            socket.clients = socket.clientsIndex = {};
        }
        
        Tile.clearAll()
        
	    if (timer) timer.stop()
        timer = new GameTimer()
        timer.start()
	}
	
	this.sendAll = function(message) {
        traffic.log(" OUT " + message.type + "." + message.action + " " + JSON.stringify(message.data))        
        socket.broadcast(message)
	}
	
	this.sendOthers = function(client, message) {
        traffic.log(" OUT " + message.type + "." + message.action + " " + JSON.stringify(message.data))        
        client.broadcast(message)
	}
    
    this.setClientPlayer = function(client, player) {
        players[client.sessionId] = player
    }
    
    this.getClientPlayer = function(client) {
        return players[client.sessionId]
    }
    
    
    
    
    this.start = function(port, cb) {
    
    
        state.loadFromDb(function() {
        
            // timer
            timer.start()
            
        
            // web server
            server = express.createServer()
            
            server.use(express.static(path.join(__dirname, '/public')));            
                        
            server.get('/', function(req, res) {
                res.send("Hello World")
            })      
            
            server.listen(port, cb)
            
            
            
            // socket
            
            socket = io.listen(server)
            
            socket.on('connection', function(client) {
                    
                // welcome message
                client.send(new Message("Welcome"))

                client.on('message', function(message) {
                
                    traffic.log(" IN  " + message.type + "." + message.action + " " + JSON.stringify(message.data))        
                    
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
                        traffic.log("CAUGHT " + err + "\n" + err.stack)
                        return client.send(new Fault(Fault.ControllerFault, "Controller Fault " + message + " _ \nWithError:" + err + "\n" + err.stack))
                    }
                })
                
                client.on('disconnect', function () {
                    var player = players[client.sessionId]
                    
                    if (player)
                        playerControl.leave(self, client, player.toValue())
                })
                
            })
            
            server.on('close', function() {
                // traffic.log("Closed ")
            })  
                    
        })
                                
    }    
    
    



    
    this.close = function() {
        timer.stop()
        timer = null
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

