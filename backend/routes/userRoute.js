const router = require("express").Router();
const E = require("../utils/customError");
const U = require("../utils/utils");

const userService = require("../services/userService");

router.get("/:id", async (req, res, next) => {
    const userId = req.params.id;
    if (!userId) {
        E.sendError(res, E.BadRequest, "User id not found in request");
        return;
    }
    const foundUser = await userService
        .getUserById(parseInt(userId))
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    E.sendJson(res, foundUser);
});

router.get("/", async (req, res, next) => {
    const users = await userService
        .getUsers()
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    E.sendJson(res, users);
});

router.post("/new", async (req, res, next) => {
    const newUser = req.body;
    if (!newUser || U.isEmpty(newUser)) {
        E.sendError(res, E.BadRequest, "newUser not found in request body");
        return;
    }
    let createdUser = await userService
        .insertUser(newUser)
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    
    E.sendJson(res, createdUser);
});

module.exports = router;