const fs = require("fs");
const path = require("path");
const yaml = require("js-yaml");

try {
  let fileContents = fs.readFileSync(path.join(__dirname, './documentation.yaml'), 'utf-8');
  let documentation = yaml.safeLoad(fileContents);

  module.exports = documentation;

} catch (e) {
  console.error(e);
}