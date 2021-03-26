const router = require("express").Router();
const E = require("../utils/customError");

const badgeService = require("../services/badgeService");

router.get("/by/:userId", async (req, res, next) => {
    const userId = req.params.userId;

    const result = await badgeService
        .getBy(userId)
        .catch(e => {
            E.sendError(res, e.code ?? E.InternalServerError, e.message);
        });
    
    E.sendJson(res, result);
});

router.post("/login/:userId", async (req, res, next) => {
    const userId = req.params.userId;

    let result = await badgeService
        .loggedIn(userId)
        .catch(e => {
            E.sendError(res, e.code ?? E.UnprocessableEntity, e.message);
        });
    E.sendJson(res, result === null ? "" : result);
});

router.post("/techie/:userId", async (req, res, next) => {
    const userId = req.params.userId;

    let result = await badgeService
        .techie(userId)
        .catch(e => {
            E.sendError(res, e.code ?? E.UnprocessableEntity, e.message);
        });
    E.sendJson(res, result === null ? "" : result);
});

router.post("/impression/emotional/:userId", async (req, res, next) => {
    const userId = req.params.userId;

    let result = await badgeService
        .impression(userId, true)
        .catch(e => {
            E.sendError(res, e.code ?? E.UnprocessableEntity, e.message);
        });
    E.sendJson(res, result === null ? "" : result);
});

router.post("/impression/structural/:userId", async (req, res, next) => {
    const userId = req.params.userId;

    let result = await badgeService
        .impression(userId, false)
        .catch(e => {
            E.sendError(res, e.code ?? E.UnprocessableEntity, e.message);
        });
    E.sendJson(res, result === null ? "" : result);
});

module.exports = router;