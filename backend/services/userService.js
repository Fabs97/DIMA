const userDAO = require("../DAO/userDAO");

module.exports = userService = {
    getUserById: async (id) => {
        return await userDAO.getUserById(id);
    },
    getUsers: async () => {
        return await userDAO.getUsers();
    },
    insertUser: async (user) => {
        return await userDAO.insertUser(user);
    }
};