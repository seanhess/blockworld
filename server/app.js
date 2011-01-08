var sys = require('sys')

var net = require('net')
var Fault = require('./model/Fault')


var server = net.createServer(function(stream) {
    
    function send(obj) {
        stream.write(JSON.stringify(obj))
    }
    
    function fault(type, message) {
        send(new Fault(type, message))
    }

    stream.setEncoding('utf8')
    
    stream.on('connect',function() {
        stream.write('hello\r\n')
    })
    
    stream.on('data',function(data) {
        stream.write(data)
        
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
        stream.write('goodbye\r\n')
        stream.end()
    })
})

module.exports = server

if (module == require.main) {
    server.listen(3000, 'localhost')
    sys.puts("localhost:3000")    
}
