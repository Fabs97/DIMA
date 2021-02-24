const db = require("../utils/db");
const T = require("../utils/tablesDefinition");
const E = require("../utils/customError");

module.exports = {
    getUserById: async (id) => {
        let res = await db(T.userTable)
            .select()
            .where("id", id)
            .first()
            .catch(e => {
                if (e) {
                    console.error(`Message: ${e.message}`);
                    console.error(`Stack: ${e.stack}`);
                    throw new E.CustomError(E.NotFound, `No available user with id ${id} in the database`);
                }
            });
        return res;
    },
    getUsers: async (fields = []) => {
        const errFun = e => {
            if (e) {
                console.error(`Message: ${e.message}`);
                console.error(`Stack: ${e.stack}`);
                throw new E.CustomError(E.InternalServerError, "Something went wrong while retrieving the users");
            }
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
    },
    insertUser: async (user) => {
        let res = await db(T.userTable)
            .returning()
            .insert({
                firebaseId: user.firebaseId,
                tech: user.tech,
                exp: user.exp,
                email: user.email,
                password: user.password,
                name: user.name ?? user.email.split("@")[0], 
            }, ["id", "firebaseId", "tech", "exp", "email", "name"])
            .catch(e => {
                if (e) {
                    throw new E.CustomError(E.InternalServerError, "Something went wrong while trying to save the user");
                }
            });
        return res[0];
    }
}