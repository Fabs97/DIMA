const badgeDAO = require("../DAO/badgeDAO");
const userDAO = require("../DAO/userDAO");
const E = require("../utils/customError");
const M = require("moment");

const BADGE_POINTS = {
    "daily_3": 100,
    "daily_5": 150,
    "daily_10": 200,
    "daily_30": 300,
}

module.exports = badgeService = {
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
    }
}