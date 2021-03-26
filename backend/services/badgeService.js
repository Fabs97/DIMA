const badgeDAO = require("../DAO/badgeDAO");
const userDAO = require("../DAO/userDAO");
const E = require("../utils/customError");
const M = require("moment");
const emotionalDAO = require("../DAO/emotionalDAO");
const structuralDAO = require("../DAO/structuralDAO");

const BADGE_POINTS = {
    "daily_3": 100,
    "daily_5": 150,
    "daily_10": 200,
    "daily_30": 300,
    "techie": 50,
    "emotional_1": 10,
    "emotional_3": 10,
    "emotional_5": 10,
    "emotional_10": 10,
    "emotional_25": 10,
    "emotional_50": 10,
    "structural_1": 10,
    "structural_3": 10,
    "structural_5": 10,
    "structural_10": 10,
    "structural_25": 10,
    "structural_50": 10,
}

module.exports = badgeService = {
    getBy: async (userId) => {
        return await badgeDAO.getBadgeByUserId(userId);
    },
    loggedIn: async (userId) => {
        let badge = await badgeDAO.getBadgeByUserId(userId);
        if (badge === null || badge === undefined) throw new E.CustomError(E.NotFound, "Badge not found");
        let difference = M().diff(badge.daily_last, "days");

        if (difference === 1) {
            let newCounter = badge.daily_counter + 1;
            await badgeDAO.putBadge({
                daily_last: M().format("L"),
                daily_counter: newCounter,
                daily_3: newCounter >= 3,
                daily_5: newCounter >= 5,
                daily_10: newCounter >= 10,
                daily_30: newCounter >= 30,
            }, userId);
            switch (newCounter) {
                case 3: {
                    const badge = "daily_3";
                    await userDAO.updateUserExperience(userId, BADGE_POINTS[badge]);
                    return badge;
                }
                case 5: {
                    const badge = "daily_5";
                    await userDAO.updateUserExperience(userId, BADGE_POINTS[badge]);
                    return badge;
                }
                case 10:{
                    const badge = "daily_10";
                    await userDAO.updateUserExperience(userId, BADGE_POINTS[badge]);
                    return badge;
                }
                case 30: {
                    const badge = "daily_30";
                    await userDAO.updateUserExperience(userId, BADGE_POINTS[badge]);
                    return badge;
                }
                default:
                    return null;
            }
        } else if (difference > 1) {
            await badgeDAO.putBadge({
                daily_last: M().format("L"),
                daily_counter: 0,
            }, userId);
        }
        return null;
    },
    techie: async (userId) => {
        const badge = "techie";
        await badgeDAO.putBadge({
            technical: true
        }, userId);
        await userDAO.updateUserExperience(userId, BADGE_POINTS[badge]);
        return badge;
    },
    impression: async (userId, emotional) => {
        const impressions = emotional
            ? (await emotionalDAO.getEmotionalsByUserId(userId))
            : (await structuralDAO.getStructuralsByUserId(userId));
        const badgeFromDB = await badgeDAO.getBadgeByUserId(userId);
        const count = impressions.length;
        let badgeUpdate = {};
        let badge;
        switch (count) {
            case 1: {
                badge = emotional ? "emotional_1" : "structural_1"; 
                if(!badgeFromDB[badge]){
                    badgeUpdate[badge] = true;
                }
                break
            };
            case 5: {
                badge = emotional ? "emotional_5" : "structural_5"; 
                if(!badgeFromDB[badge]){
                    badgeUpdate[badge] = true;
                }
                break
            };
            case 10: {
                badge = emotional ? "emotional_10" : "structural_10"; 
                if(!badgeFromDB[badge]){
                    badgeUpdate[badge] = true;
                }
                break;
            }
            case 25: {
                badge = emotional ? "emotional_25" : "structural_25"; 
                if(!badgeFromDB[badge]){
                    badgeUpdate[badge] = true;
                }
                break;
            }
            case 50: {
                badge = emotional ? "emotional_50" : "structural_50"; 
                if(!badgeFromDB[badge]){
                    badgeUpdate[badge] = true;
                }
                break;
            }
            default:
                break;
        }
        if (badge !== null && badge !== undefined) {
            if (Object.entries(badgeUpdate).length > 0) {
                await badgeDAO.putBadge(badgeUpdate, userId);
                await userDAO.updateUserExperience(userId, BADGE_POINTS[badge]);
            }
        }
        return badge;
    }
}