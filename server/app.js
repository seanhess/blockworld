var sys = require('sys')

var net = require('net')
var Fault = require('./model/Fault')
var sys = require("sys")

var app = net.createServer(function(stream) {
    
    function send(obj) {
        var payload = JSON.stringify(obj)
        // sys.log("<<< " + payload)
        stream.write(app.OpenDelimiter + payload + app.CloseDelimiter)
    }
    
    function message(type, data) {
        data = data || ""
        send({route:type, data:data})
    }
    
    function fault(type, message) {
        send({fault:new Fault(type, message)})
    }

    stream.setEncoding('utf8')
    
    stream.on('connect',function() {
        message('hello')
    })
    
    stream.on('data',function(data) {
        
        // sys.log(" >>> " + data)
                
        // parse
        try {
            var message = JSON.parse(data)            
        }
        catch (err) {
            return fault(Fault.JsonParsingError, "Could not parse: " + data + " with error " + err)
        }
        
        var route = message.route
        var data = message.data
        
        if (!data)
            return fault(Fault.InvalidData, "No Data")
        
        var split = route.split(".")
        
        try {
            var module = require('./controller/' + split[0]) 
        }
        catch (err) {
            return fault(Fault.InvalidRoute, "Invalid Route: " + route)
        }
        
        if (!split[1] || !module[split[1]]) 
            return fault(Fault.InvalidRoute, "Invalid Route: " + route)

        var method = module[split[1]]
        
        try {
            method(data)
        }
        catch (err) {
            return fault(Fault.BadController, "Bad Controller " + route)
        }
    })
    
    stream.on('end',function() {
        message('goodbye')
        stream.end()
    })
})

module.exports = app
app.port = 3000
app.OpenDelimiter = "<<<"
app.CloseDelimiter = ">>>"

app.start = function(cb) {
    app.listen(app.port, 'localhost', cb)
}

if (module == require.main) {
    app.start()
    sys.puts("localhost:" + app.port)    
}
