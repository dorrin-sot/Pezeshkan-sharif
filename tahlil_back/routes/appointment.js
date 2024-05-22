const {validateJwtToken} = require('../utils/jwt');


function appointment_requests(app, db, jsonParser) {
    /**
     * @swagger
     * /appointments:
     *   get:
     *     summary: Get List of doctor or patient's appointments
     *     responses:
     *       200:
     *         description: Returns user profile as a json.
     *       400:
     *         description: Referrer can not have appointments.
     *       401:
     *         description: Unauthorized access. Try logging in or refreshing token.
     *
     */
    app.get('/appointments', async function (req, res) {
        let {token} = req.cookies;

        const {rows} = await db.query(`select * from public."login_token" where token='${token}' order by created_at desc limit 1`);
        const {ssid, created_at, user_type} = rows[0]

        if (!validateJwtToken(token)) {
            res.status(401).send('Invalid Token!')
        } else if ((new Date()).getTime() - created_at.getTime() >= process.env.cookie_max_age) {
            res.status(401).send('Old Token! Send a GET /auth/refresh request and try again.')
        } else if (user_type == 'referrer') {
            res.status(400).send('Referrer can not have appointments!')
        } else {
            const {rows} = await db.query(`select * from public."appointment" where patient='${ssid}' or doctor='${ssid}'`)
                .catch(console.log);
            res.status(200).json(rows)
        }
    });
}

module.exports = appointment_requests;