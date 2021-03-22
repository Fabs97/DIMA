const badgeDAO = require("../DAO/badgeDAO"); 
const userDAO = require("../DAO/userDAO"); 
const bcrypt = require("bcrypt");

module.exports = userService = {
    getUserById: async (id) => {
        return await userDAO.getUserById(id);
    },
    getUserByFirebaseId: async (id) => {
        return await userDAO.getUserByFirebaseId(id);
    },
    getUsers: async () => {
        return await userDAO.getUsers();
    },
    insertUser: async (user) => {
        if (user.password) {
            user = await bcrypt.hash(user.password, 10).then(async function(hash){
                user.password = hash;
                return await userDAO.insertUser(user);
            });
        } else {
            user = await userDAO.insertUser(user);
        }
        await badgeDAO.insertBadge(user.id);
        return user;
    },
    updateUser: async (user) => {
        return await userDAO.updateUser(user);
    },
    getUserSecret: async (id) => {
        return await userDAO.getUserSecret(id);
    }
};