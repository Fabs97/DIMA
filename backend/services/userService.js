const userDAO = require("../DAO/userDAO");

module.exports = userService = {
    getUserById: async (id) => {
        return await userDAO.getUserById(id);
    }
};