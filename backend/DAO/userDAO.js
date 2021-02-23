const db = require("../utils/db");
const T = require("../utils/tablesDefinition");
const E = require("../utils/customError");

module.exports = {
    getUserById: async (id) => {
        let result = await db(T.userTable)
            .select()
            .where("id", id)
            .limit(0)
            .catch(e => {
                console.error(`Message: ${e.message}`);
                console.error(`Stack: ${e.stack}`);
                throw new E.CustomError(E.NotFound, `No available user with id ${id} in the database`);
            });
        return result[0];
    },
    getUsers: async (fields = []) => {
        const errFun = e => {
            console.error(`Message: ${e.message}`);
            console.error(`Stack: ${e.stack}`);
            throw new E.CustomError(E.InternalServerError, "Something went wrong while retrieving the users");
        };
        
        let res = fields.length === 0 ?
            await db(T.userTable)
                .select()
                .limit(100)
                .catch(errFun)
            : await db(T.userTable)
                .select(fields)
                .limit(100)
                .catch(errFun);
        return res;
    }
}