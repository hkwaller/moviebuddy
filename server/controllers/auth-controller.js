var jwt = require('jsonwebtoken')
var secret = "supersecret"

module.exports.authenticate = function(req, res) {
    if (!(req.body.username === 'hannes' && req.body.password === 'password')) {
        return;
    }
    
    var user = {
        first_name: 'Hannes',
        last_name: 'Waller',
        email: 'hkwaller@gmail.com'
    };

    var token = jwt.sign(user, secret, {});
    res.json({ token: token });
}