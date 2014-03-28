module.exports = 

    schema: true

    attributes: 

        topicId: 
            type: 'string'
            index: true
            required: true

        userId:
            type: 'string'
            index: true
            required: true

        content:
            type: 'string'
            required: true
            maxLength: 5000