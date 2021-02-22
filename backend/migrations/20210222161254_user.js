const userTable = "user";

exports.up = async function (knex) {
    let hasTable = await knex.schema.hasTable(userTable);
    
    return !hasTable ? knex.schema.createTable(userTable, table => {
        table.increments("id").notNullable();
        table.string("firebaseId").notNullable();
        table.boolean("tech");
        table.float("exp");
        table.string("email");
        table.string("password");
    }) : null;
};

exports.down = function(knex) {
    return knex.schema.dropTable(userTable);
};
