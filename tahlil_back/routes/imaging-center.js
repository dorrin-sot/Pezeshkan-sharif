function imaging_center_requests(app, db, jsonParser) {
    /**
     * @swagger
     * /imaging-center:
     *   post:
     *     summary: Create Imaging Center
     *     requestBody:
     *       required: true
     *       content:
     *         application/json:
     *           schema:
     *             type: object
     *             properties:
     *               name: string
     *               referrer: string
     *               password: string
     *               repeat_password: string
     *             example:
     *               name: imaging center
     *               referrer: 1234567892
     *               password: passpass123
     *               repeat_password: passpass123
     *     responses:
     *       201:
     *         description: Imaging Center Created Successfully.
     *       400:
     *         description: Error in creation
     *       404:
     *         description: Referrer not found
     */
    app.post('/imaging-center', jsonParser, async function (req, res) {
        console.log('kcmdslmc')
        const {name, password, repeat_password, referrer} = req.body;
        const {rows: referrers} = await db.query('select ssid from public."referrer"');
        const {rowCount} = await db.query(`select * from public."imaging_center" where name='${name}'`);

        if (rowCount > 0) {
            res.status(400).send('Name should be Unique.')
        } else if (!referrers.map((r) => r['ssid']).includes(referrer)) {
            res.status(404).send('Referrer not found.')
        } else if (password !== repeat_password) {
            res.status(400).send('Password and Repeat Password should match.')
        } else if (password.length < 8) {
            res.status(400).send('Password should be at least 8 characters long.')
        } else {
            await db.query({
                text: `insert into public."imaging_center" ` +
                    `(name, referrer, password) ` +
                    `values ($1, $2, $3)`,
                values: [name, referrer, password],
            }).catch(console.log);
            res.status(201).send('Imaging Center Created Successfully!');
        }
    });

    /**
     * @swagger
     * /imaging-center/{id}:
     *   get:
     *     summary: Get Imaging Center info
     *     parameters:
     *       - in: path
     *         name: id
     *         schema:
     *           type: string
     *         required: true
     *         description: The ID of the Imaging Center
     *     responses:
     *       200:
     *         description: Imaging Center info returned successfully.
     *       404:
     *         description: Imaging Center not found.
     */
    app.get('/imaging-center/:id', async function (req, res) {
        const {id} = req.params;
        const {rows} = await db.query({text: 'select * from public."imaging_center_v1" where id=$1', values: [id]})
            .catch(console.log);
        if (rows.length === 0) return res.status(404).send('Imaging Center not found!')
        res.status(200).json(rows[0]);
    });

    /**
     * @swagger
     * /imaging-center/{id}/working-hours:
     *   get:
     *     summary: Get Imaging Center Working Hours
     *     parameters:
     *       - in: path
     *         name: id
     *         schema:
     *           type: string
     *         required: true
     *         description: The ID of the Imaging Center
     *     responses:
     *       200:
     *         description: Imaging Center Working Hours returned successfully.
     *       404:
     *         description: Imaging Center not found.
     */
    app.get('/imaging-center/:id/working-hours', async function (req, res) {
        const {id} = req.params;
        const {rowCount} = await db.query({text: 'select * from public."imaging_center" where id=$1', values: [id]})
            .catch(console.log);
        if (rowCount === 0) return res.status(404).send('Imaging Center not found!')
        const {rows} = await db.query({text: 'select * from public."imaging_center_work_times" where imaging_center=$1', values: [id]})
            .catch(console.log);
        res.status(200).json(rows);
    });
}

module.exports = imaging_center_requests;