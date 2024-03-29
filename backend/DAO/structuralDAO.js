const db = require("../utils/db");
const T = require("../utils/tablesDefinition");
const E = require("../utils/customError");
const U = require("../utils/utils");

module.exports = {
    insertStructural: async (i) => {
        let res = await db(T.structuralTable)
        .returning()
        .insert({
            userId: i.userId,
            fromTech: i.fromTech,
            component: i.component,
            pathology: i.pathology,
            typology: i.typology,
            notes: i.notes,
            latitude: i.latitude,
            longitude: i.longitude,
            place_tag: i.placeTag
        }, ["id", "fromTech", "userId", "component", "pathology", "typology", "notes", "latitude", "longitude", "created", "place_tag"])
        .catch(e => {
            if (e) {
                console.error(`Message: ${e.message}`);
                console.error(`Stack: ${e.stack}`);
                throw new E.CustomError(E.InternalServerError, "Something went wrong while trying to save the impression")
            }
        });
        return res[0];
    },
    getStructuralsByUserId: async (userId) => {
        let res = await db(T.structuralTable)
        .select()
        .where("userId", userId)
        .catch(e => {
            if(e) {
                console.error(`Message: ${e.message}`);
                console.error(`Stack: ${e.stack}`);
                throw new E.CustomError(E.InternalServerError, "Something went wrong while trying to retrieve impressions by userId");
            }
        });
        return res;
    },
    getStructuralsByLatLongRange: async (lat, long) => {
        let res = await db(T.structuralTable)
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
    deleteStructuralById: async (id) => {
        let res = await db(T.structuralTable)
            .where("id", id)
            .delete("*")
            .catch(e => {
                if (e) {
                    throw new E.CustomError(E.InternalServerError, "Something went wrong while trying to delete the impression");
                }
            });
        return res[0];
    }
}