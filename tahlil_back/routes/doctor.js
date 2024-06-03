const {validateJwtToken} = require('../utils/jwt');


function doctor_requests(app, db, jsonParser) {
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

    /**
     * @swagger
     * /doctor/{ssid}/working-hours:
     *   get:
     *     summary: Get Doctor Working Hours info
     *     parameters:
     *       - in: path
     *         name: ssid
     *         schema:
     *           type: string
     *         required: true
     *         description: The ID of the Doctor
     *     responses:
     *       200:
     *         description: Doctor Working Hours returned successfully.
     *       404:
     *         description: Doctor not found.
     */
    app.get('/doctor/:ssid/working-hours', async function (req, res) {
        const {ssid} = req.params;
        const {rowCount} = await db.query({text: 'select * from public."doctor" where ssid=$1', values: [ssid]})
            .catch(console.log);
        if (rowCount === 0) return res.status(404).send('Doctor not found!')
        const {rows} = await db.query({text: 'select * from public."doctor_work_times" where doctor=$1', values: [ssid]})
            .catch(console.log);
        res.status(200).json(rows);
    });

    /**
     * @swagger
     * /doctor/{ssid}/filled-times:
     *   get:
     *     summary: Get Doctor Filled Times
     *     parameters:
     *       - in: path
     *         name: ssid
     *         schema:
     *           type: string
     *         required: true
     *         description: The ID of the Doctor
     *     responses:
     *       200:
     *         description: Doctor Filled Times returned successfully.
     *       404:
     *         description: Doctor not found.
     */
    app.get('/doctor/:ssid/filled-times', async function (req, res) {
        const {ssid} = req.params;
        const {rowCount} = await db.query({text: 'select * from public."doctor" where ssid=$1', values: [ssid]})
            .catch(console.log);
        if (rowCount === 0) return res.status(404).send('Doctor not found!')
        const {rows} = await db.query({text: 'select date_time, weekday from public."doctor_appointment_v1" where doctor=$1', values: [ssid]})
            .catch(console.log);
        res.status(200).json(rows);
    });
}

module.exports = doctor_requests;