const badgeDAO = require("../DAO/badgeDAO");
const E = require("../utils/customError");
const M = require("moment");

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
                case 3:
                    return "daily_3";
                case 5:
                    return "daily_5";
                case 10:
                    return "daily_10";
                case 30:
                    return "daily_30";
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