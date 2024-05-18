const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./swagger');
const bodyParser = require('body-parser')
const cookieParser = require('cookie-parser');
const morgan = require('morgan')

const {Client} = require('pg')

const auth_requests = require('./routes/user/auth');
const healthcheck_request = require('./routes/health-check');
const user_requests = require("./routes/user/user");


const db_client = new Client({
    connectionString: process.env.pg_url,
});

db_client
    .connect()
    .then(() => console.log('Connected to PostgreSQL database'))
    .catch((err) => console.error('Error connecting to PostgreSQL database', err));

const app = express();
const port = process.env.server_port;
const jsonParser = bodyParser.json();

app.use(morgan('> :date[iso] :method :url :status :res[content-length]B - :response-time[3]ms'))
app.use('/swagger', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
app.use(cookieParser());

healthcheck_request(app)
auth_requests(app, db_client, jsonParser);
user_requests(app, db_client, jsonParser);

app.listen(port, () => {
    console.log(`Pezeshkan-sharif listening at http://localhost:${port}`);
    console.log(`Swagger app listening at http://localhost:${port}/swagger`);
});

