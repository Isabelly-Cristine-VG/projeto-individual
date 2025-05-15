var express = require("express");
var router = express.Router();

var tipoController = require("../controllers/tipoController");

router.post("/buscarTipo", function (req, res) {
    tipoController.buscarTipo(req, res);
});

module.exports = router;