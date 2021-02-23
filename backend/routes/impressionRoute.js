const router = require("express").Router();
const E = require("../utils/customError");
const U = require("../utils/utils");

const impressionService = require("../services/impressionService");

router.post("/emotional/new", async (req, res, next) => {
    const newImpression = req.body;
    if (!newImpression || U.isEmpty(newImpression)) {
        E.sendError(res, E.BadRequest, "newImpression not found in request body");
        return;
    }

    let createdImpression = await impressionService
        .insertEmotional(newImpression)
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    E.sendJson(res, createdImpression);
});

router.get("/emotional/user/:userId", async (req, res, next) => {
    const userId = req.params.userId;
    let emotionals = await impressionService
        .getEmotionalsByUserId(userId)
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    E.sendJson(res, emotionals);
});

module.exports = router;