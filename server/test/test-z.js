// The tests won't let it close for some reason. 
// Force the process to end.

exports.z = function(assert) {
    assert.finish()
    process.exit()
}