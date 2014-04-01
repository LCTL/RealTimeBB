async = require 'async'

module.exports = (req, res, next) ->

    user = req.session.user

    if user

        async.some user.roles

        , (role, callback) ->

            callback role is 'admin'

        , (result) ->

            if result then next() else res.forbidden 'You are not permitted to perform this action.'