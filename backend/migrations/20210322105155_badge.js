const T = require("../utils/tablesDefinition");
const M = require("moment");


exports.up = async function(knex) {
    let hasTable = await knex.schema.hasTable(T.badgeTable);
    
    return !hasTable ? knex.schema.createTable(T.badgeTable, table => {
        table.increments("id").primary().notNullable();
        table.integer("userId").unsigned();
        table.foreign("userId").references("user.id").onDelete("CASCADE");
        
        // * Dailies
        table.string("daily_last").defaultTo(M().format("L"));
        table.integer("daily_counter").defaultTo(0);
        table.boolean("daily_3").defaultTo(false);
        table.boolean("daily_5").defaultTo(false);
        table.boolean("daily_10").defaultTo(false);
        table.boolean("daily_30").defaultTo(false);

        // * Techie
        table.boolean("technical").defaultTo(false);

        // * Structural impressions
        table.boolean("structural_1").defaultTo(false);
        table.boolean("structural_5").defaultTo(false);
        table.boolean("structural_10").defaultTo(false);
        table.boolean("structural_25").defaultTo(false);
        table.boolean("structural_50").defaultTo(false);

        // * Emotional impressions
        table.boolean("emotional_1").defaultTo(false);
        table.boolean("emotional_5").defaultTo(false);
        table.boolean("emotional_10").defaultTo(false);
        table.boolean("emotional_25").defaultTo(false);
        table.boolean("emotional_50").defaultTo(false);
    }) : null;
};

exports.down = function(knex) {
    return knex.schema.dropTable(T.badgeTable);
};