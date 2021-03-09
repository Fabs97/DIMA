const emotionalDAO = require("../DAO/emotionalDAO");
const structuralDAO = require("../DAO/structuralDAO")

module.exports = impressionService = {
    getImpressionsBy: async (userId) => {
        const emotionals = await emotionalDAO.getEmotionalsByUserId(userId);
        const structurals = await structuralDAO.getStructuralsByUserId(userId);

        return [...emotionals, ...structurals].sort((a, b) => a.created - b.created);
    },


    insertEmotional: async (impression) => {
        return await emotionalDAO.insertEmotional(impression);
    },
    getEmotionalsByUserId: async (userId) => {
        return await emotionalDAO.getEmotionalsByUserId(userId);
    },
    getEmotionalsByLatLongRange: async (lat, long) => {
        return await emotionalDAO.getEmotionalsByLatLongRange(lat, long);
    },
    deleteEmotionalById: async (id) => {
        let emotional = await emotionalDAO.deleteEmotionalById(id);
        if (emotional != null || emotional != undefined) {
            return await impressionService.getImpressionsBy(emotional.userId);
        } else {
            throw new E.CustomError(E.InternalServerError, "Could not find the userId of the deleted impression");
        }
    },


    insertStructural: async(impression) => {
        return await structuralDAO.insertStructural(impression);
    },
    getStructuralsByUserId: async (userId) => {
        return await structuralDAO.getStructuralsByUserId(userId)
    },
    getStructuralsByLatLongRange: async (lat, long) => {
        return await structuralDAO.getStructuralsByLatLongRange(lat, long);
    },
    deleteStructuralById: async (id) => {
        let structural = await structuralDAO.deleteStructuralById(id);
        if (structural != null || structural != undefined) {
            return await impressionService.getImpressionsBy(structural.userId);
        } else {
            throw new E.CustomError(E.InternalServerError, "Could not find the userId of the deleted impression");
        }
    },
}