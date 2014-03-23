module.exports = (req, res, next) ->

    user = req.session.user

    if user and user.isAdmin

        return next()

    res.forbidden 'You are not permitted to perform this action.'