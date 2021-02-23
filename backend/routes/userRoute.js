const router = require("express").Router();
const E = require("../utils/customError");

const userService = require("../services/userService");

router.get("/user/:id", async (req, res, next) => {
    console.log(req);
    const userId = req.params.id;
    if (!userId) E.sendError(res, E.BadRequest, "User id not found in request");
    const foundUser = await userService
        .getUserById(parseInt(userId))
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    E.sendJson(res, foundUser);
});

router.get("/", async (req, res, next) => {
    console.log(req);
    const users = await userService
        .getUsers()
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    E.sendJson(res, users);
});

module.exports = router;