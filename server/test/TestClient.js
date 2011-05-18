
// Test TestClient. Connects to server

var net = require("net")
var sys = require('sys')
var App = require('../app')
var traffic = require("../utils/traffic")
var io = require('node-socket.io-client/socket.io').io

var EventEmitter = require('events').EventEmitter

var TestClient = module.exports = function() {
    
    var socket = null
    var onMessage, onFault
    
    this.connect = function(port, cb) {
        
        socket = new io.Socket("localhost", {port:port})
        socket.connect()
    
        socket.on('connect', function() {
            cb()
        })
        
        socket.on('message', function(message) {
            
            if (message.fault) {
                if (onFault) onFault(message)
            }
        
            else if (onMessage) 
                onMessage(message)
        })
        
        socket.on('disconnect', function() {
            
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
        socket.close()
    }
    
    this.send = function(message) {
        socket.send(message)
    }    
}