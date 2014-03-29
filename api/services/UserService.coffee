BaseModelService = require './BaseModelService'

class UserService extends BaseModelService

    constructor: () ->

        super User

module.exports = new UserService()