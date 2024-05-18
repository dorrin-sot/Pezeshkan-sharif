const {generateJwtToken, validateJwtToken} = require('../../utils/jwt');


function user_requests(app, db, jsonParser) {
    /**
     * @swagger
     * /profile:
     *   get:
     *     summary: Get Current User Profile
     *     responses:
     *       200:
     *         description: Returns user profile as a json.
     *       401:
     *         description: Unauthorized access. Try logging in or refreshing token.
     *
     */
    app.get('/profile', async function (req, res) {
        let {token} = req.cookies;

        const {rows} = await db.query(`select * from public."login_token" where token='${token}' order by created_at desc limit 1`);
        console.log(token, rows)
        const {ssid, created_at} = rows[0]
        if ((new Date()).getTime() - created_at.getTime() >= process.env.cookie_max_age) {
            res.status(401).send('Old Token! Send a GET /auth/refresh request and try again.')
        } else {
            let {rows} = await db.query(`select * from public."doctor" where ssid='${ssid}'`);
            if (rows.length == 0) {
                rows = (await db.query(`select * from public."patient" where ssid='${ssid}'`))['rows'];
                if (rows.length == 0) {
                    rows = (await db.query(`select * from public."referrer" where ssid='${ssid}'`))['rows'];
                }
            }
            res.status(200).json(rows[0])
        }
    });
}

module.exports = user_requests;