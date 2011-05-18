var express = require('express')
var io = require('socket.io')
var path = require('path')

if (module == require.main) {

    var app = express.createServer();

    app.get('/', function(req, res){ 
       res.send('Hello World'); 
    })

    app.get('/test', function(req, res) {
        res.sendfile(path.join(__dirname, "..", "public", "test.html"))
    })

    app.listen(3000)
      

    var socket = io.listen(app); 
    socket.on('connection', function(client){ 
        console.log("CONNECTION")
        
        //socket.broadcast({woot:"true"})
        client.send({woot:"true"})
        
        client.on('message', function(message) {
            console.log("MESSAGE!", message)
        })
        
        client.on('disconnect', function() {
            console.log("GOODBYE")
        })
    })
    
}