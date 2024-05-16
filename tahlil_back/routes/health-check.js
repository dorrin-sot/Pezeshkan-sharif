/**
 * @swagger
 * /health-check:
 *   get:
 *     summary: Health-Check
 *     responses:
 *       200:
 *         description: Everything is ok
 *
 */

function healthcheck_request(app) {
    app.get('/health-check',
        (req, res) => res.sendStatus(200));
}

module.exports = healthcheck_request;