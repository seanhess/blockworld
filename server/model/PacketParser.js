var sys = require('sys')

module.exports = PacketParser = function() {
    
    var onMatch
    var dataStream = ""
    
    this.data = function() {
        return dataStream
    }
    
    this.addData = function(data) {
        dataStream += data
        
        if (!dataStream.match(/^<<</)) {
            dataStream = ""
            return false            
        }
        
        dataStream = dataStream.replace(/<<<(.*?)>>>/gim, function(match, group) {
            if (onMatch) onMatch(group)
            return ""
        })
        
        return true
    }
    
    this.onPacket = function(cb) {
        onMatch = cb
    }
}