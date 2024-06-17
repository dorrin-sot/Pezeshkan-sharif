const multer = require("multer");
const FTPStorage = require('multer-ftp')
const path = require("path");
const {Client} = require("basic-ftp")
const fs = require('fs');

// const pfp_storage = multer({
//     storage: new FTPStorage({
//         basepath: '/profile-pictures',
//         ftp: {
//             host: process.env.ftp_host,
//             port: process.env.ftp_port,
//             user: process.env.ftp_username,
//             password: process.env.ftp_password,
//             secure: false,
//         },
//         destination: (req, file, opts, cb) => cb(null, `profile-pictures/${req.ssid}`),
//     }),
// })
//
// const delete_file = async (filename) => {
//     const client = new Client()
//     try {
//         await client.access({
//             host: process.env.ftp_host,
//             port: process.env.ftp_port,
//             user: process.env.ftp_username,
//             password: process.env.ftp_password,
//             secure: false,
//         })
//         await client.remove(filename)
//         return true;
//     } catch (err) {
//         console.log(err)
//         return false;
//     } finally {
//         client.close()
//     }
// };
//
// const download = async (filename) => {
//     const client = new Client()
//     try {
//         await client.access({
//             host: process.env.ftp_host,
//             port: process.env.ftp_port,
//             user: process.env.ftp_username,
//             password: process.env.ftp_password,
//             secure: false,
//         })
//         await client.remove(filename)
//         return true;
//     } catch (err) {
//         console.log(err)
//         return false;
//     } finally {
//         client.close()
//     }
// }

const pfp_storage = multer({
    storage: multer.diskStorage({
        destination: 'files/profile-pictures/',
        filename: (req, file, cb) => cb(null, req.ssid + path.extname(file.originalname)),
    })
});

const delete_file = (filename) => fs.unlink(filename, console.log);

module.exports = {pfp_storage, delete_file}