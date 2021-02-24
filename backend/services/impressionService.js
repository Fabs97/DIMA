const emotionalDAO = require("../DAO/emotionalDAO");
const structuralDAO = require("../DAO/structuralDAO")

module.exports = impressionService = {
    insertEmotional: async (impression) => {
        return await emotionalDAO.insertEmotional(impression);
    },
    getEmotionalsByUserId: async (userId) => {
        return await emotionalDAO.getEmotionalsByUserId(userId);
    },
    getEmotionalsByLatLongRange: async (lat, long) => {
        return await emotionalDAO.getEmotionalsByLatLongRange(lat, long);
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
}