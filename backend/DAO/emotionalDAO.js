const db = require("../utils/db");
const T = require("../utils/tablesDefinition");
const E = require("../utils/customError");
const U = require("../utils/utils");

module.exports = {
    insertEmotional: async (i) => {
        let res = await db(T.emotionalTable)
            .returning()
            .insert({
                cleanness: i.cleanness,
                happiness: i.happiness,
                inclusiveness: i.inclusiveness,
                comfort: i.comfort,
                safety: i.safety,
                mean: U.mean([i.cleanness, i.happiness, i.inclusiveness, i.comfort, i.safety]),
                notes: i.notes,
                images: i.images,
                latitude: i.latitude,
                longitude: i.longitude,
                place_tag: i.place_tag
            }, ["id", "created", "mean"])
            .catch(e => {
                if (e) {
                    console.error(`Message: ${e.message}`);
                    console.error(`Stack: ${e.stack}`);
                    throw new E.CustomError(E.InternalServerError, "Something went wrong while trying to save the impression");
                }
            });
        return res[0];
    },
    getEmotionalsByUserId: async (userId) => {
        let res = db(T.emotionalTable)
            .select()
            .where("userId", userId)
            .catch(e => {
                if (e) {
                    console.error(`Message: ${e.message}`);
                    console.error(`Stack: ${e.stack}`);
                    throw new E.CustomError(E.InternalServerError, "Something went wrong while trying to retrieve impressions by userId");
                }
            });
        return res;
    }
}