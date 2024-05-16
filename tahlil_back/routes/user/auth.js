const {generateJwtToken, validateJwtToken} = require('../../utils/jwt');


function auth_requests(app, db, jsonParser) {
    /**
     * @swagger
     * /auth/register:
     *   post:
     *     summary: Register
     *     requestBody:
     *       required: true
     *       content:
     *         application/json:
     *           schema:
     *             type: object
     *             properties:
     *               ssid: string
     *               first_name: string
     *               last_name: string
     *               password: string
     *               repeat_password: string
     *               medical_id: string
     *               user_type: string
     *             example:
     *               ssid: 1234567890
     *               first_name: fname
     *               last_name: lname
     *               password: passpass123
     *               repeat_password: passpass123
     *               medical_id: 12345
     *               user_type: doctor
     *     responses:
     *       201:
     *         description: Successful register.
     *       401:
     *         description: An error occurred during register. Messages in body.
     *
     */
    app.post('/auth/register', jsonParser, async function (req, res) {
        const {ssid, first_name, last_name, password, repeat_password, medical_id, user_type} = req.body;
        const {rowCount} = await db.query(`select * from public."user" where ssid='${ssid}'`);
        if (rowCount > 0) {
            res.status(401).send('SSID should be Unique.')
        } else if (password !== repeat_password) {
            res.status(401).send('Password and Repeat Password should match.')
        } else if (password.length < 8) {
            res.status(401).send('Password should be at least 8 characters long.')
        } else if (!['doctor', 'patient', 'referrer'].includes(user_type)) {
            res.status(401).send("User Type should be between 'doctor', 'patient', 'referrer'.")
        } else if (user_type === 'doctor' && (medical_id || '').length == 0) {
            res.status(401).send("Medical ID is required for doctors.")
        } else {
            const values = [ssid, first_name, last_name, username, password];
            if (user_type === 'doctor') {
                values.push(medical_id);
                const {rowCount} = await db.query(`select * from public."doctor" where medical_id='${medical_id}'`);
                if (rowCount > 0) {
                    res.status(401).send('Medical ID should be Unique.')
                    return
                }
            } else if (user_type === 'referrer') {
                values.push(true) // referrer is verified by default
            }

            res.status(201).json(await db.query({
                text: `insert into public.${user_type} ` +
                    `(ssid, first_name, last_name, password${user_type == 'doctor' ? ", medical_id" : ""}${user_type == 'referrer' ? ", is_verified" : ""}) ` +
                    `values ($1, $2, $3, $4${user_type != 'patient' ? ", $5" : ""})`,
                values: values,
            }));
        }
    });

    /**
     * @swagger
     * /auth/login:
     *   post:
     *     summary: Login
     *     requestBody:
     *       required: true
     *       content:
     *         application/json:
     *           schema:
     *             type: object
     *             properties:
     *               ssid: string
     *               password: string
     *             example:
     *               ssid: 1234567899
     *               password: passpass123
     *     responses:
     *       200:
     *         description: Successful login with token cookie.
     *       401:
     *         description: An error occurred during login. Messages in body.
     *
     */
    app.post('/auth/login', jsonParser, async function (req, res) {
        const {ssid, password} = req.body;
        const {rowCount, rows} = await db.query(`select * from public."user" where ssid='${ssid}' and password='${password}'`);
        if (rowCount === 0) {
            res.status(401).send('SSID or Password is incorrect.');
        } else if (!rows[0]['is_verified']) {
            res.status(401).send('Unverified users can\'t login.');
        } else {
            const token = generateJwtToken(ssid);
            db.query({
                text: `insert into public.login_token (ssid, token, created_at) values ($1, $2, $3)`,
                values: [ssid, token, (new Date()).toISOString()]
            }).then((_) => {
                res.cookie('token', token, {httpOnly: true});
                res.status(200).send('Login Successful!');
            })
        }
    });

    /**
     * @swagger
     * /auth/refresh:
     *   post:
     *     summary: Refresh Token
     *     responses:
     *       200:
     *         description: Successful refresh token with new token cookie.
     *       401:
     *         description: An error occurred during refresh.
     *
     */
    app.post('/auth/refresh', jsonParser, async function (req, res) {
        let {token} = req.cookies;
        if (validateJwtToken(token)) {
            const {rows} = await db.query(`select ssid from public."login_token" where token='${token}' order by created_at desc limit 1`);
            const {ssid} = rows[0]
            token = generateJwtToken(ssid);
            db.query({
                text: `insert into public.login_token (ssid, token, created_at) values ($1, $2, $3)`,
                values: [ssid, token, (new Date()).toISOString()]
            }).then((_) => {
                res.cookie('token', token, {httpOnly: true});
                res.status(200).send('Refresh Token Successful!');
            })
        } else {
            res.status(401).send('Invalid token.');
        }
    });

    /**
     * @swagger
     * /auth/logout:
     *   delete:
     *     summary: Logout
     *     responses:
     *       204:
     *         description: Successful logout.
     *       401:
     *         description: An error occurred during logout.
     *
     */
    app.delete('/auth/logout', jsonParser, async function (req, res) {
        let {token} = req.cookies;
        if (validateJwtToken(token)) {
            const {rows} = await db.query(`select * from public."login_token" where token='${token}' order by created_at desc limit 1`);
            const {ssid, created_at} = rows[0]
            if ((new Date()).getTime() - created_at.getTime() >= process.env.cookie_max_age) {
                res.status(401).send('Invalid token.')
            }
            token = generateJwtToken(ssid);
            db.query({
                text: `delete from public.login_token where ssid=$1`,
                values: [ssid]
            }).then((_) => {
                res.status(204).send('Logout Successful!');
            })
        } else {
            res.status(401).send('Invalid token.');
        }
    });
}

module.exports = auth_requests;