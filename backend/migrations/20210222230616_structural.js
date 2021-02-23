const structuralTable = "structural";

exports.up = async function(knex) {
    const hasTable = await knex.schema.hasTable(structuralTable);
    return !hasTable ? knex.schema.createTable(structuralTable, table => {
        table.increments("id").notNullable();
        table.integer("userId").unsigned();
        table.foreign("userId").references("user.id").onDelete("CASCADE");
       
        table.string("component");
        table.string("pathology");
        table.enum("typology", ["Repair"]);
       
        table.string("notes");
        table.specificType("images", "text[]");
        table.string("latitude");
        table.string("longitude");
        table.timestamp('created').defaultTo(knex.fn.now());
    }) : null; 
};

exports.down = function(knex) {
    return knex.schema.dropTable(structuralTable);
};
