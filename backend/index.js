const express = require('express');
const app = express();
const swaggerUI = require("swagger-ui-express");
const APIDocumentation = require("./docs/openapi");
const cors = require("cors");
const port = process.env.PORT || 3000;
const L = require("./utils/logger");

app.use(cors());1

app.use("/apis", swaggerUI.serve, swaggerUI.setup(APIDocumentation));
app.use(express.json());
app.use(L);

const userRoute = require("./routes/userRoute");
const impressionRoute = require("./routes/impressionRoute");
app.use("/user", userRoute);
app.use("/impression", impressionRoute);

app.listen(port, () => console.log(`CityLife backend is ready to know what you think of our city on http://localhost:${port}!`));

module.exports = app;