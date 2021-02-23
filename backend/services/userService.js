const userDAO = require("../DAO/userDAO");

module.exports = userService = {
    getUserById: async (id) => {
        return await userDAO.getUserById(id);
    },
    getUsers: async () => {
        return await userDAO.getUsers();
    }
};