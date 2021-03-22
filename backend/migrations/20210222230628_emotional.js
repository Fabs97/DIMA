const T = require("../utils/tablesDefinition");

exports.up = async function(knex) {
    const hasTable = await knex.schema.hasTable(T.emotionalTable);
    return !hasTable ? knex.schema.createTable(T.emotionalTable, table => {
        table.increments("id").primary().notNullable();
        table.integer("userId").unsigned();
        table.foreign("userId").references("user.id").onDelete("CASCADE");
        table.boolean("fromTech");
        
        table.float("cleanness");
        table.float("happiness");
        table.float("inclusiveness");
        table.float("comfort");
        table.float("safety");
        table.float("mean");
        
        table.string("notes");
        table.float("latitude");
        table.float("longitude");
        table.string("place_tag");
        table.timestamp('created').defaultTo(knex.fn.now());
    }) : null; 
};

exports.down = function(knex) {
    return knex.schema.dropTable(T.emotionalTable);
};
