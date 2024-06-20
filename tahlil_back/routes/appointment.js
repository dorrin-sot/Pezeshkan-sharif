const {validateJwtToken} = require('../utils/jwt');

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
     *     summary: Get List of doctor or imaging center or patient's appointments
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
            const {rows: list2} = await db.query(`select * from public."imaging_center_appointment_v1" where patient='${ssid}' or imaging_center_name='${ssid}'`)
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
            let {year, month, day, hour, doctor, imaging_center} = req.body;
            month -= 1;
            let greg = new Date(year, month, day, hour)
            const weekday = greg.toLocaleDateString('en-US', {weekday: 'long'}).toLowerCase()

            await db.query({
                text: 'insert into public."time" ' +
                    '(date_time, weekday) values ' +
                    '($1, $2) ' +
                    'on conflict on constraint time_date_time_key do nothing',
                values: [greg, weekday]
            }).catch(console.log);

            const {rows: times} = await db.query(`select id from public."time" where extract(years from date_time)=${year} and extract(months from date_time)=${month+1} and extract(days from date_time)=${day} and extract(hours from date_time)=${hour} and extract(minutes from date_time)=0`)
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

    /**
     * @swagger
     * /appointment/{id}:
     *   get:
     *     summary: Get appointment Info
     *     parameters:
     *       - in: path
     *         name: id
     *         schema:
     *           type: integer
     *         required: true
     *         description: The ID of the appointment
     *     responses:
     *       200:
     *         description: Appointment returned as json
     *       404:
     *         description: Appointment not found
     *       401:
     *         description: Unauthorized access. Try logging in or refreshing token.
     *
     */
    app.get('/appointment/:id', async function (req, res) {
        let {token} = req.cookies;

        const {rows} = await db.query(`select * from public."login_token" where token='${token}' order by created_at desc limit 1`);
        if (rows.length === 0) return res.status(401).send('Invalid Token!');
        const {ssid, created_at, user_type} = rows[0]

        if (!validateJwtToken(token)) {
            res.status(401).send('Invalid Token!')
        } else if ((new Date()).getTime() - created_at.getTime() >= process.env.cookie_max_age) {
            res.status(401).send('Old Token! Send a GET /auth/refresh request and try again.')
        } else {
            const {id: appointment_id} = req.params;
            let type = 'doctor'
            let {rows: appointment, rowCount} = await db.query({text: `select * from public."${type}_appointment_v1" where id=$1`, values: [parseInt(appointment_id)]})
                .catch(console.log)

            if (rowCount === 0) {
                type = 'imaging_center'
                const result = await db.query({text: `select * from public."${type}_appointment_v1" where id=$1`, values: [parseInt(appointment_id)]})
                    .catch(console.log)
                appointment = result['rows']
                rowCount = result['rowCount']
            }

            if (rowCount === 0 || ![appointment[0]['patient'], appointment[0][type]].includes(ssid))
                return res.status(404).send('Appointment not found!')

            res.status(200).json({...appointment[0], type})
        }
    });
}

module.exports = appointment_requests;