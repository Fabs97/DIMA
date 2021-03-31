const router = require("express").Router();
const E = require("../utils/customError");
const U = require("../utils/utils");
const O  = require("../utils/otp");

const userService = require("../services/userService");

router.get("/leaderboard", async (req, res, next) => {
    const leaderboard = await userService
        .getLeaderboard()
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    E.sendJson(res, leaderboard);
});

router.get("/byUser/:id", async (req, res, next) => {
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

router.get("/byFirebase/:id", async (req, res, next) => {
    const firebaseId = req.params.id;
    if (!firebaseId) {
        E.sendError(res, E.BadRequest, "User id not found in request");
        return;
    }
    const foundUser = await userService
        .getUserByFirebaseId(firebaseId)
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

router.post("/update", async (req, res, next) => {
    const user = req.body;
    if (!user) {
        E.sendError(res, E.BadRequest, "User not found in request body");
        return;
    }
    const userUpdated = await userService
        .updateUser(user)
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    E.sendJson(res, userUpdated);
});

/**
 * Creates a new user row in the user table
 * 
 * @param {object} newUser in req.body
 * @returns {number} 400 if newUser is not found in the request body
 * @returns {number} 500 if any error has occured while saving in the db
 * @returns {number} 200 along with the saved user data if everything is OK
 */
router.post("/new", async (req, res, next) => {
    const newUser = req.body;
    if (!newUser || U.isEmpty(newUser)) {
        E.sendError(res, E.BadRequest, "newUser not found in request body");
        return;
    }
    let createdUser = await userService
        .insertUser(newUser)
        .catch(e => {
            E.sendError(res, e.code ?? E.InternalServerError, e.message);
        });
    
    E.sendJson(res, createdUser);
});

router.post("/2fa/:userId", async (req, res, next) => {
    const userId = req.params.userId;
    const code = req.headers["x-citylife-code"];
    if (!code || !userId) {
        E.sendError(res, E.BadRequest, "Code or userId not found in request header or parameters");
        return;
    }
    const result = await O.Check(code, userId);
    
    E.sendJson(res, result ? "OK" : "Unauthorized", result ? E.OK : E.Unauthorized);
});

router.get("/2fa/:userId", async (req, res, next) => {
    const userId = req.params.userId;
    if (!userId) {
        E.sendError(res, E.BadRequest, "User id not found in request parameters");
        return;
    }
    const result = await userService.getUserSecret(userId);
    E.sendJson(res, result);
});

module.exports = router;