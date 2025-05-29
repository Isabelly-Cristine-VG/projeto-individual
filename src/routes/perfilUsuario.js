var express = require("express");
var router = express.Router();

var perfilController = require("../controllers/perfilController");


router.get("/mostrarTiposFavoritos/:idUsuario", function (req, res) {
    perfilController.mostrarTiposFavoritos(req, res);
});

router.get("/mostrarTimePokemon/:idUsuario", function (req, res) {
    perfilController.mostrarTimePokemon(req, res);
});

router.get('/buscarVantagensUsuario/:idTipo(\\d+)', function (req, res) {
    console.log(`Acessando endpoint com ID: ${req.params.idTipo}`);
    perfilController.buscarVantagensUsuario(req, res);
});

router.get('/contarVantagensUsuario/:idTipo(\\d+)', function (req, res) {
    perfilController.buscarVantagensUsuario(req, res);
});

module.exports = router;