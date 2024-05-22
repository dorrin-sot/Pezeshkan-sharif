const {validateJwtToken} = require('../../utils/jwt');


function verify_requests(app, db, jsonParser) {
    /**
     * @swagger
     * /referees:
     *   get:
     *     summary: Get a list of all patients and doctors that need current referrer's verification
     *     responses:
     *       200:
     *         description: Returns list of said users as a json.
     *       401:
     *         description: Unauthorized access. Try logging in or refreshing token.
     *
     */
    app.get('/referees', async function (req, res) {
        let {token} = req.cookies;

        const {rows} = await db.query(`select * from public."login_token" where token='${token}' order by created_at desc limit 1`);
        if (rows.length == 0) return res.status(401).send('Invalid Token!');
        const {ssid, created_at, user_type} = rows[0]

        if (!validateJwtToken(token)) {
            res.status(401).send('Invalid Token!')
        } else if ((new Date()).getTime() - created_at.getTime() >= process.env.cookie_max_age) {
            res.status(401).send('Old Token! Send a GET /auth/refresh request and try again.')
        } else if (user_type != 'referrer') {
            res.status(401).send('You have to be a referrer to access this part!')
        } else {
            const {rows: results} = await db.query({text: `select ssid, first_name, last_name, 'doctor' as user_type from public."doctor" where referrer=$1 and not is_verified`, values: [ssid]})
                .catch(console.log);
            await db.query({text: `select ssid, first_name, last_name, 'patient' as user_type from public."patient" where referrer=$1 and not is_verified`, values: [ssid]})
                .then(({rows}) => rows.forEach((e) => results.push(e)))
                .catch(console.log);

            res.status(200).send(results)
        }
    });
}

module.exports = verify_requests;