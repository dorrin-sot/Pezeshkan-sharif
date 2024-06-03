const {validateJwtToken} = require('../utils/jwt');


function imaging_center_requests(app, db, jsonParser) {
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