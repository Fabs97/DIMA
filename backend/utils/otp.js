const jsSHA = require("jssha");
const userDAO = require("../DAO/userDAO");

function dec2hex(s) { return (s < 15.5 ? '0' : '') + Math.round(s).toString(16); }
function hex2dec(s) { return parseInt(s, 16); }


function base32ToHex(base32) {
    const base32chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
    let bits = "";
    let hex = "";

    for (let i = 0; i < base32.length; i++){
        let val = base32chars.indexOf(base32.charAt(i).toUpperCase());
        bits += leftpad(val.toString(2), 5, '0');
    }

    for (let i = 0; i <= bits.length - 4; i += 4){
        let chunk = bits.substr(i, 4);
        hex = hex + parseInt(chunk, 2).toString(16);
    }
    return hex;
}

function leftpad(str, len, pad) {
    if (len + 1 >= str.length) {
        str = Array(len + 1 - str.length).join(pad) + str;
    }
    return str;
}

function getCurrentTime() {
    let epoch = Math.round(new Date().getTime() / 1000.0);
    let time = leftpad(dec2hex(Math.floor(epoch / 30)), 16, '0');
    return time;
}

let O = {
    Check: async (code, userId) => {
        const secret = await userDAO.getUserSecret(userId);
        
        let key = base32ToHex(secret);
        let time = getCurrentTime();

        let shaObj = new jsSHA("SHA-1", "HEX");
        shaObj.setHMACKey(key, "HEX");
        shaObj.update(time);
        let hmac = shaObj.getHMAC("HEX");
        let offset = hex2dec(hmac.substring(hmac.length - 1));

        let otp = (hex2dec(hmac.substr(offset * 2, 8)) & hex2dec('7fffffff')) + '';
        otp = (otp).substr(otp.length - 6, 6);
        return otp === code;
    },
}

module.exports = O;