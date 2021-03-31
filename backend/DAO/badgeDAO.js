const db = require("../utils/db");
const T = require("../utils/tablesDefinition");
const E = require("../utils/customError");
const U = require("../utils/utils");
const M = require("moment");

module.exports = {
    getBadgeByUserId: async (userId) => {
        let badge = db(T.badgeTable)
            .select()
            .where("userId", userId)
            .first()
            .catch((e) => {
                if (e) {
                    console.error(`Message: ${e.message}`);
                    console.error(`Stack: ${e.stack}`);
                    throw new E.CustomError(E.InternalServerError, "Something went wrong while trying to retrieve the badge by userId");
                }
            });
        return badge;
    },
    insertBadge: async (userId) => {
        let res = await db(T.badgeTable)
            .returning()
            .insert({
                userId: userId,
                daily_last: M().format("L"),
                daily_counter: 1,
            })
            .catch(e => {
                if (e) {
                    console.error(`Message: ${e.message}`);
                    console.error(`Stack: ${e.stack}`);
                    throw new E.CustomError(E.InternalServerError, "Something went wrong while trying to save the badge");
                }
            });
        return res;
    },
    putBadge: async (badge, userId) => {
        let res = await db(T.badgeTable)
            .where("userId", userId)
            .update(badge)
            .returning()
            .catch(e => {
                if (e) {
                    console.error(`Message: ${e.message}`);
                    console.error(`Stack: ${e.stack}`);
                    throw new E.CustomError(E.InternalServerError, "Something went wrong while trying to update the badge");
                }
            });
        return res;
    }
};