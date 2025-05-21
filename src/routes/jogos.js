var express = require("express");
var router = express.Router();

var jogoController = require("../controllers/jogoController");

router.get("/buscarGinasios/:idRegiao", function (req, res) {
    jogoController.buscarGinasios(req, res);
});


module.exports = router;