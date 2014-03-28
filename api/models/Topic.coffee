module.exports = 

    attributes: 

        forumId: 
            type: 'string'
            index: true
            required: true

        userId:
            type: 'string'
            index: true
            required: true

        title:
            type: 'string'
            index: true
            required: true
            maxLength: 100
            