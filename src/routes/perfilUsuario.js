var express = require("express");
var router = express.Router();

var perfilController = require("../controllers/perfilController");


router.get("/mostrarTiposFavoritos/:idUsuario", function (req, res) {
    perfilController.mostrarTiposFavoritos(req, res);
});

router.get("/mostrarTimePokemon/:idUsuario", function (req, res) {
    perfilController.mostrarTimePokemon(req, res);
});

module.exports = router;