const {validateJwtToken} = require('../utils/jwt');
const {gregorianToJalali} = require('shamsi-date-converter')

function appointment_requests(app, db, jsonParser) {
    /**
     * @swagger
     * /doctors:
     *   get:
     *     summary: Get List of doctors (Optional search)
     *     parameters:
     *       - in: query
     *         name: search
     *         schema:
     *           type: string
     *         description: The query string to search with. if not provided, will return all doctors
     *     responses:
     *       200:
     *         description: Returns doctor list as a json.
     *
     */
    app.get('/doctors', async function (req, res) {
        const {search} = req.query;
        if (search) {
            const {rows} = await db.query({
                text: `select * from public."doctor_v1" where first_name || ' ' || last_name like $1`,
                values: [`%${search}%`],
            })
                .catch(console.log);
            res.status(200).json(rows)
        } else {
            const {rows} = await db.query(`select * from public."doctor_v1"`)
                .catch(console.log);
            res.status(200).json(rows)
        }
    });

    /**
     * @swagger
     * /imaging-centers:
     *   get:
     *     summary: Get List of Imaging Centers (Optional search)
     *     parameters:
     *       - in: query
     *         name: search
     *         schema:
     *           type: string
     *         description: The query string to search with. if not provided, will return all imaging centers
     *     responses:
     *       200:
     *         description: Returns imaging center list as a json.
     *
     */
    app.get('/imaging-centers', async function (req, res) {
        const {search} = req.query;
        if (search) {
            const {rows} = await db.query({
                text: `select * from public."imaging_center_v1" where name like $1`,
                values: [`%${search}%`],
            }).catch(console.log);
            res.status(200).json(rows)
        } else {
            const {rows} = await db.query(`select * from public."imaging_center_v1"`)
                .catch(console.log);
            res.status(200).json(rows)
        }
    });

    /**
     * @swagger
     * /appointments:
     *   get:
     *     summary: Get List of doctor or patient's appointments
     *     responses:
     *       200:
     *         description: Returns appointment list.
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
        } else if (user_type === 'referrer') {
            res.status(400).send('Referrer can not have appointments!')
        } else {
            const {rows: list1} = await db.query(`select * from public."doctor_appointment_v1" where patient='${ssid}' or doctor='${ssid}'`)
                .catch(console.log);
            const {rows: list2} = await db.query(`select * from public."imaging_center_appointment_v1" where patient='${ssid}'`)
                .catch(console.log);
            res.status(200).json([...list1, ...list2])
        }
    });

    /**
     * @swagger
     * /appointment:
     *   post:
     *     summary: Create appointment
     *     requestBody:
     *       required: true
     *       content:
     *         application/json:
     *           schema:
     *             type: object
     *             properties:
     *               doctor: string
     *               year: integer
     *               month: integer
     *               day: integer
     *               hour: integer
     *             example:
     *               doctor: 1234567890
     *               year: 2022
     *               month: 10
     *               day: 1
     *               hour: 11
     *     responses:
     *       200:
     *         description: Appointment created successfully.
     *       400:
     *         description: Non-Patient users cannot create appointment or appointment is duplicate
     *       401:
     *         description: Unauthorized access. Try logging in or refreshing token.
     *
     */
    app.post('/appointment', jsonParser, async function (req, res) {
        let {token} = req.cookies;

        const {rows} = await db.query(`select * from public."login_token" where token='${token}' order by created_at desc limit 1`);
        const {ssid, created_at, user_type} = rows[0]

        if (!validateJwtToken(token)) {
            res.status(401).send('Invalid Token!')
        } else if ((new Date()).getTime() - created_at.getTime() >= process.env.cookie_max_age) {
            res.status(401).send('Old Token! Send a GET /auth/refresh request and try again.')
        } else if (user_type !== 'patient') {
            res.status(400).send('Non-Patient users cannot create appointment!')
        } else {
            const {year, month, day, hour, doctor, imaging_center} = req.body;
            const greg = new Date(year, month, day)
            const weekday = greg.toLocaleDateString('en-US', {weekday: 'long'}).toLowerCase()
            const jalali = gregorianToJalali(greg);

            await db.query({
                text: 'insert into public."time" ' +
                    '(year, month, day, hour, weekday) values ' +
                    '($1, $2, $3, $4, $5) ' +
                    'on conflict on constraint time_year_month_day_hour_key do nothing',
                values: [jalali[0], jalali[1], jalali[2], hour, weekday]
            }).catch(console.log);

            const {rows: times} = await db.query(`select id from public."time" where year=${jalali[0]} and month=${jalali[1]} and day=${jalali[2]} and hour=${hour}`)
                .catch(console.log);
            const time_id = times[0]['id']

            if (doctor) {
                await db.query({
                    text: `insert into public."appointment_doctor" (patient, doctor, time) values ($1, $2, $3)`,
                    values: [ssid, doctor, time_id]
                })
                    .then((_) => res.status(200).send('Appointment created successfully!'))
                    .catch((e) => {
                        if (e.constraint === 'appointment_doctor_unique_key')
                            res.status(400).send('Appointment already exists!')
                        else console.log(e);
                    });
            } else if (imaging_center) {
                await db.query({
                    text: `insert into public."appointment_imaging_center" (patient, imaging_center, time) values ($1, $2, $3)`,
                    values: [ssid, imaging_center, time_id]
                })
                    .then((_) => res.status(200).send('Appointment created successfully!'))
                    .catch((e) => {
                        if (e.constraint === 'appointment_imaging_center_unique_key')
                            res.status(400).send('Appointment already exists!')
                        else console.log(e);
                    });
            }
        }
    });
}

module.exports = appointment_requests;