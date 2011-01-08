module.exports = PacketParser = function() {
    
    var onMatch
    var dataStream = ""
    
    this.addData = function(data) {
        dataStream += data
        
        dataStream.replace(/<<<(.*?)>>>/gim, function(match, group) {
            if (onMatch) onMatch(group)
            return ""
        })
    }
    
    this.onPacket = function(cb) {
        onMatch = cb
    }
}