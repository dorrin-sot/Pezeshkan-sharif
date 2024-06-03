const {validateJwtToken} = require('../../utils/jwt');


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
        if (rows.length === 0) return res.status(401).send('Invalid Token!')
        let {ssid, created_at, user_type} = rows[0]

        if (!validateJwtToken(token)) {
            res.status(401).send('Invalid Token!')
        } else if ((new Date()).getTime() - created_at.getTime() >= process.env.cookie_max_age) {
            res.status(401).send('Old Token! Send a GET /auth/refresh request and try again.')
        } else {
            if (user_type === 'doctor') user_type += '_v1';
            const {rows} = await db.query(`select * from public."${user_type}" where ssid='${ssid}'`);
            user_type = user_type.replace('_v1', '');
            res.status(200).json({...rows[0], user_type})
        }
    });

    /**
     * @swagger
     * /profile:
     *   put:
     *     summary: Edit one or more of the user's information
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
     *               referrer: string
     *               phone_number: string
     *               email_address: string
     *               province: string
     *               city: string
     *               street: string
     *               specialty: string
     *             example:
     *               province: Tehran
     *               city: Tehran
     *     responses:
     *       200:
     *         description: User updated successfully! new user info will be sent in response body.
     *       400:
     *         description: SSID or Medical ID can't be changed. Also the fields should be valid.
     *       401:
     *         description: Unauthorized access. Try logging in or refreshing token.
     *
     */
    app.put('/profile', jsonParser, async function (req, res) {
        let {token} = req.cookies;

        const {rows} = await db.query(`select * from public."login_token" where token='${token}' order by created_at desc limit 1`);
        if (rows.length === 0) return res.status(401).send('Invalid Token!')
        const {ssid, created_at, user_type} = rows[0]
        if (!validateJwtToken(token)) {
            res.status(401).send('Invalid Token!')
        } else if ((new Date()).getTime() - created_at.getTime() >= process.env.cookie_max_age) {
            res.status(401).send('Old Token! Send a GET /auth/refresh request and try again.')
        } else {
            const body = req.body;
            if (body['ssid']) return res.status(400).send('SSID Can\'t be changed!')
            if (user_type == 'doctor' && body['medical_id']) return res.status(400).send('Medical ID Can\'t be changed!')

            let i = 1
            let query = `update public."${user_type}" set `
            let values = []
            for (let [key, value] of Object.entries(body)) {
                query += `${key}=\$${i++},`
                values.push(value)
            }
            if (i > 1) {
                query = query.substring(0, query.length - 1) + ` where ssid=\$${i++}`
                values.push(ssid)
                let error = false
                await db.query({text: query, values})
                    .catch((e) => {
                        res.status(400).send(e.message);
                        error = true;
                    })
                if (error) return
            }

            const {rows: new_user} = await db.query(`select * from public."${user_type}" where ssid='${ssid}'`)
            res.status(200).json({...new_user[0], user_type})
        }
    });

    /**
     * @swagger
     * /doctor/{ssid}:
     *   get:
     *     summary: Get Doctor info
     *     parameters:
     *       - in: path
     *         name: ssid
     *         schema:
     *           type: string
     *         required: true
     *         description: The SSID of the doctor
     *     responses:
     *       200:
     *         description: Doctor info returned successfully.
     *       404:
     *         description: Doctor not found.
     */
    app.get('/doctor/:ssid', async function (req, res) {
        const {ssid} = req.params;
        const {rows} = await db.query({text: 'select * from public."doctor_v1" where ssid=$1', values: [ssid]})
            .catch(console.log);
        if (rows.length === 0) return res.status(404).send('Doctor not found!')
        res.status(200).json(rows[0]);
    });
}

module.exports = user_requests;