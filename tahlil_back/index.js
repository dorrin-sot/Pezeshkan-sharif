const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./swagger');
const bodyParser = require('body-parser')
const cookieParser = require('cookie-parser');
const morgan = require('morgan')
const cors = require('cors')

const {Client} = require('pg')

const auth_requests = require('./routes/user/auth');
const healthcheck_request = require('./routes/health-check');
const user_requests = require("./routes/user/user");
const verify_requests = require("./routes/user/verify");
const appointment_requests = require("./routes/appointment");
const {validateJwtToken} = require("./utils/jwt");


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

app.use(morgan('> :date[iso] :method :url :status :res[content-length]B - :response-time[0]ms'))
app.use('/swagger', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
app.use(cookieParser());
app.use(cors({
    origin: ["http://localhost:3000", "http://127.0.0.1:3000"],
    credentials: true,
    exposedHeaders: ["Set-Cookie"],
}));

healthcheck_request(app)
auth_requests(app, db_client, jsonParser);
user_requests(app, db_client, jsonParser);
verify_requests(app, db_client, jsonParser);
appointment_requests(app, db_client, jsonParser);

app.listen(port, () => {
    console.log(`Pezeshkan-sharif listening at http://localhost:${port}`);
    console.log(`Swagger app listening at http://localhost:${port}/swagger`);
});

