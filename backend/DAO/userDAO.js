const db = require("../utils/db");
const T = require("../utils/tablesDefinition");
const E = require("../utils/customError");
const { groupBy } = require("../utils/db");
const base32 = require("hi-base32");

// TODO: must return fields one by one, take out the secret field
module.exports = {
    getUserById: async (id) => {
        let res = await db(T.userTable)
            .select(
                "id",
                "firebaseId",
                "tech",
                "name",
                "exp",
                "email",
                "password",
                "avatar",
            "twofa")
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
    getUserByFirebaseId: async (id) => {
        let res = await db(T.userTable)
            .select(
                "id",
                "firebaseId",
                "tech",
                "name",
                "exp",
                "email",
                "password",
                "avatar",
            "twofa")
            .where("firebaseId", id)
            .first()
            .catch(e => {
                if (e) {
                    console.error(`Message: ${e.message}`);
                    console.error(`Stack: ${e.stack}`);
                    throw new E.CustomError(E.NotFound, `No available user with firebaseId ${id} in the database`);
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
                .select(
                "id",
                "firebaseId",
                "tech",
                "name",
                "exp",
                "email",
                "password",
                "avatar",
            "twofa")
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
                twofa: user.twofa,
                name: user.name ?? user.email.split("@")[0],
                secret: base32.encode(Date.now().toString()).toUpperCase().replace(/=/g, ""),
            }, ["id", "firebaseId", "tech", "exp", "email", "name", "avatar", "twofa"])
            .catch(e => {
                if (e) {
                    throw new E.CustomError(E.InternalServerError, "Something went wrong while trying to save the user");
                }
            });
        return res[0];
    },
    updateUser: async (user) => {
        let res = await db(T.userTable)
            .where("id", user.id)
            .update(user)
            .returning("id",
                "firebaseId",
                "tech",
                "name",
                "exp",
                "email",
                "password",
                "avatar",
                "twofa",)
            .catch(e => {
                if (e) {
                    throw new E.CustomError(E.NotFound, "User not found");
                }
            });
        return res[0];
    },
    getUserSecret: async (userId) => {
        let res = await db(T.userTable)
            .select("secret")
            .where("id", userId)
            .first()
            .catch(e => {
                if (e) {
                    console.error(`Message: ${e.message}`);
                    console.error(`Stack: ${e.stack}`);
                    throw new E.CustomError(E.NotFound, `No available user with id ${id} in the database`);
                }
            });
        return res.secret;
    }
}