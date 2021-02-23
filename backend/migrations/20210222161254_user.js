const T = require("../utils/tablesDefinition");

exports.up = async function (knex) {
    let hasTable = await knex.schema.hasTable(T.userTable);
    
    return !hasTable ? knex.schema.createTable(T.userTable, table => {
        table.increments("id").primary().notNullable();
        table.string("firebaseId").notNullable();
        table.boolean("tech");
        table.float("exp");
        table.string("email");
        table.string("password");
    }) : null;
};

exports.down = function(knex) {
    return knex.schema.dropTable(T.userTable);
};
