module.exports = {
    isEmpty: (obj) => {
        return Object.keys(obj).length === 0;
    },
    mean: (arr) => {
        return arr.reduce((acc, val) => acc + val) / arr.length;
    }
}