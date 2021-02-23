const emotionalTable = "emotional";
exports.up = async function(knex) {
    const hasTable = await knex.schema.hasTable(emotionalTable);
    return !hasTable ? knex.schema.createTable(emotionalTable, table => {
        table.increments("id").notNullable();
        table.integer("userId").unsigned();
        table.foreign("userId").references("user.id").onDelete("CASCADE");
        
        table.float("cleanness");
        table.float("happiness");
        table.float("inclusiveness");
        table.float("comfort");
        table.float("safety");
        
        table.string("notes");
        table.specificType("images", "text[]");
        table.string("latitude");
        table.string("longitude");
        table.timestamp('created').defaultTo(knex.fn.now());
    }) : null; 
};

exports.down = function(knex) {
    return knex.schema.dropTable(emotionalTable);
};
