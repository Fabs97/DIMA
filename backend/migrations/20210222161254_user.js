const T = require("../utils/tablesDefinition");

exports.up = async function (knex) {
    let hasTable = await knex.schema.hasTable(T.userTable);
    
    return !hasTable ? knex.schema.createTable(T.userTable, table => {
        table.increments("id").primary().notNullable();
        table.string("firebaseId").notNullable();
        table.boolean("tech").defaultTo(false);
        table.string("name");
        table.float("exp").defaultTo(0.0);
        table.string("email");
        table.string("password");
        table.string("avatar").defaultTo("avatar_1");
    }) : null;
};

exports.down = function(knex) {
    return knex.schema.dropTable(T.userTable);
};
