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

router.get("/emotional/byUser/:userId", async (req, res, next) => {
    const userId = req.params.userId;
    let emotionals = await impressionService
        .getEmotionalsByUserId(userId)
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    E.sendJson(res, emotionals);
});

router.get("/emotional/byLatLong/:latMin/:latMax/:longMin/:longMax", async (req, res, next) => {
    const lat = {
        min: parseFloat(req.params.latMin),
        max: parseFloat(req.params.latMax),
    };
    const long = {
        min: parseFloat(req.params.longMin),
        max: parseFloat(req.params.longMax),
    };

    let emotionals = await impressionService
        .getEmotionalsByLatLongRange(lat, long)
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    E.sendJson(res, emotionals);
});

router.post("/structural/new", async (req, res, next) => {
    const newImpression = req.body;
    if (!newImpression || U.isEmpty(newImpression)) {
        E.sendError(res, E.BadRequest, "newImpression not found in request body");
        return;
    }

    let createdImpression = await impressionService
        .insertStructural(newImpression)
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    E.sendJson(res, createdImpression);
});

router.get("/structural/byUser/:userId", async(req, res, next) => {
    const userId = req.params.userId;
    let structurals = await impressionService
    .getStructuralsByUserId(userId)
    .catch(e => {
        E.sendError(res, e.code, e.message);
    });
    E.sendJson(res,structurals);
})

router.get("/structural/byLatLong/:latMin/:latMax/:longMin/:longMax", async (req, res, next) => {
    const lat = {
        min: parseFloat(req.params.latMin),
        max: parseFloat(req.params.latMax),
    };
    const long = {
        min: parseFloat(req.params.longMin),
        max: parseFloat(req.params.longMax),
    };

    let emotionals = await impressionService
        .getStructuralsByLatLongRange(lat, long)
        .catch(e => {
            E.sendError(res, e.code, e.message);
        });
    E.sendJson(res, emotionals);
});

module.exports = router;