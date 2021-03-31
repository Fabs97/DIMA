const environmentConfig = require("../knexfile");
const knex = require('knex');
const connection = knex(environmentConfig);

module.exports = connection;