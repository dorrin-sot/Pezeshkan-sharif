function patient_requests(app, db, jsonParser) {
    /**
     * @swagger
     * /patients:
     *   get:
     *     summary: Get a list of all patients
     *     responses:
     *       200:
     *         description: Returns list of all patients as a json.
     *
     */
    app.get('/patients', async function (req, res) {
        const {rows} = await db.query('select * from public."patient"')
            .catch(console.log);
        res.status(200).json(rows);
    });
}

module.exports = patient_requests;