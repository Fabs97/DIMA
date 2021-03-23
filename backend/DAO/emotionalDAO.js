const db = require("../utils/db");
const T = require("../utils/tablesDefinition");
const E = require("../utils/customError");
const U = require("../utils/utils");

module.exports = {
    insertEmotional: async (i) => {
        let res = await db(T.emotionalTable)
            .returning()
            .insert({
                userId: i.userId,
                fromTech: i.fromTech,
                cleanness: i.cleanness,
                happiness: i.happiness,
                inclusiveness: i.inclusiveness,
                comfort: i.comfort,
                safety: i.safety,
                mean: U.mean([i.cleanness, i.happiness, i.inclusiveness, i.comfort, i.safety]),
                notes: i.notes,
                latitude: i.latitude,
                longitude: i.longitude,
                place_tag: i.place_tag
            }, ["id", "userId", "fromTech", "cleanness", "happiness", "inclusiveness", "comfort", "safety", "mean", "notes", "latitude", "longitude", "created", "place_tag"])
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
        let res = await db(T.emotionalTable)
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
    },
    getEmotionalsByLatLongRange: async (lat, long) => {
        let res = await db(T.emotionalTable)
            .select()
            .whereBetween("latitude", [lat.min, lat.max])
            .andWhereBetween("longitude", [long.min, long.max])
            .catch(e => {
                if (e) {
                    console.error(`Message: ${e.message}`);
                    console.error(`Stack: ${e.stack}`);
                    throw new E.CustomError(E.InternalServerError, "Something went wrong while trying to retrieve impressions by latitude and longitude");
                }
            });
        return res;
    },
    deleteEmotionalById: async (id) => {
        let res = await db(T.emotionalTable)
            .where("id", id)
            .delete("*")
            .catch(e => {
                if (e) {
                    throw new E.CustomError(E.InternalServerError, "Something went wrong while trying to delete the impression");
                }
            });
        return res[0];
    },
}