_  = require 'underscore'
_.str = require 'underscore.string'

class NotificationService 

    constructor: () ->

        @defaultRoomName = 'commons'

    onConnect: (session, socket) ->

        socket.join @defaultRoomName

    onDisconnect: (session, socket) ->

        socket.leave @defaultRoomName

    publishCreate: (modelClass, model, roomName) ->

        @publish modelClass, model, 'create', roomName

    publishUpdate: (modelClass, model, roomName) ->

        @publish modelClass, model, 'update', roomName

    publishDestroy: (modelClass, model, roomName) ->

        @publish modelClass, model, 'destory', roomName

    publish: (modelClass, model, action, roomName) ->

        roomName = @defaultRoomName if not roomName

        sails.io.sockets.in(roomName).emit @createMessageName(modelClass), @createPublishMessage model, action

    createMessageName: (modelClass) ->

        _.str.capitalize modelClass.identity

    createPublishMessage: (model, action) ->

        action: action
        data: model.toJSON()

module.exports = new NotificationService()
