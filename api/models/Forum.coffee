module.exports =
    
    schema: true

    attributes: 

        name:
            type: 'string'
            required: true
            maxLength: 100

        desc:
            type: 'string'
            required: false
            maxLength: 500