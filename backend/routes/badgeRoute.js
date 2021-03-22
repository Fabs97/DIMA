const router = require("express").Router();
const E = require("../utils/customError");

const badgeService = require("../services/badgeService");

router.post("/login/:userId", async (req, res, next) => {
    const userId = req.params.userId;

    let result = await badgeService
        .loggedIn(userId)
        .catch(e => {
            E.sendError(res, e.code ?? E.UnprocessableEntity, e.message);
        });
    E.sendJson(res, result === null ? "" : result);
});

module.exports = router;