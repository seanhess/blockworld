var sys = require('sys')

module.exports = PacketParser = function() {
    
    var onMatch
    var dataStream = ""
    
    this.data = function() {
        return dataStream
    }
    
    this.addData = function(data) {
        dataStream += data.toString()
        
        var index = 0
        while((index = dataStream.indexOf("\n")) > 0) {
            var match = dataStream.substr(0, index-1)
            dataStream = dataStream.substr(index+1)
            // sys.puts("MATCH ("+match+")")

            // skip empty messages
            if (match.length > 0 && onMatch) onMatch(match)
        }
        
        return true
    }
    
    this.onPacket = function(cb) {
        onMatch = cb
    }
}

