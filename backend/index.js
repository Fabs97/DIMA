const express = require('express');
const app = express();
const swaggerUI = require("swagger-ui-express");
const APIDocumentation = require("./docs/openapi");
const cors = require("cors");
const port = process.env.PORT || 3000;

app.use(cors());

app.use("/", swaggerUI.serve, swaggerUI.setup(APIDocumentation));
app.use(express.json);

app.listen(port, () => console.log(`CityLife backend is ready to know what you think of our city on port ${port}!`));

module.exports = app;