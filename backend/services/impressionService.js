const emotionalDAO = require("../DAO/emotionalDAO");

module.exports = impressionService = {
    insertEmotional: async (impression) => {
        return await emotionalDAO.insertEmotional(impression);
    },
    getEmotionalsByUserId: async (userId) => {
        return await emotionalDAO.getEmotionalsByUserId(userId);
    },
    getEmotionalsByLatLongRange: async (lat, long) => {
        return await emotionalDAO.getEmotionalsByLatLongRange(lat, long);
    }
}