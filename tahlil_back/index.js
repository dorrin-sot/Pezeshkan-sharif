const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./swagger');
const bodyParser = require('body-parser')
const cookieParser = require('cookie-parser');

const {Client} = require('pg')

const auth_requests = require('./routes/user/auth');
const healthcheck_request = require('./routes/health-check');


const db_client = new Client({
    user: process.env.pg_user,
    password: process.env.pg_password,
    host: process.env.pg_host,
    port: process.env.pg_port,
    database: process.env.pg_database,
});

db_client
    .connect()
    .then(() => console.log('Connected to PostgreSQL database'))
    .catch((err) => console.error('Error connecting to PostgreSQL database', err));

const app = express();
const port = process.env.server_port;
const jsonParser = bodyParser.json()

app.use('/swagger', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
app.use(cookieParser());

healthcheck_request(app)
auth_requests(app, db_client, jsonParser);

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`);
});

