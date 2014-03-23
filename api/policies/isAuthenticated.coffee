module.exports = (req, res, next) ->

    user = req.session.user

    if user

        return next()

    res.forbidden 'You are not permitted to perform this action.'