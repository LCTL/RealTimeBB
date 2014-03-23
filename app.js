// Start sails and pass it command line arguments
require('coffee-script/register');
require('sails').lift(require('optimist').argv);
