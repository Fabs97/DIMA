const environment = process.env.CITYLIFE_ENV;

let DBConnection;

switch (environment) {
    case "production": {
        DBConnection = {
            connectionString: process.env.CITYLIFE_DB_URL,
            ssl: { rejectUnauthorized: false },
        };
        break;
    }
    case "development": {
        DBConnection = {
            host: process.env.CITYLIFE_DB_HOST,
            database: process.env.CITYLIFE_DB_NAME,
            user: process.env.CITYLIFE_DB_USR,
            port: process.env.CITYLIFE_DB_PORT,
            password: process.env.CITYLIFE_DB_PWD,
        };
        break;
    }
    default: {
        console.error(`[knexfile.js]::DB setup - Environment not defined ${environment}`);
    }
}


module.exports = {
  client: 'pg',
  connection: DBConnection,
  cwd: "./DB/",
    migrations: {
    directory: './migrations'
  },
  seeds: {
    directory: './seeds'
  }
};
