var express = require("express");
var router = express.Router();

var tipoController = require("../controllers/tipoController");

router.get("/buscarTipo", function (req, res) {
    tipoController.buscarTipo(req, res);
});

router.get('/buscarVantagensPorTipo/:idTipo(\\d+)', function (req, res) {
    console.log(`Acessando endpoint com ID: ${req.params.idTipo}`);
    tipoController.buscarVantagensPorTipo(req, res);
});

router.get('/contarVantagensPorTipo/:idTipo(\\d+)', function (req, res) {
    tipoController.contarVantagensPorTipo(req, res);
});


//  rotas para favoritar tipos
router.post('/favoritarTipo', function (req, res) {
    tipoController.favoritarTipo(req, res);
});

router.post('/desfavoritarTipo', function (req, res) {
    tipoController.desfavoritarTipo(req, res);
});

router.get('/buscarFavoritos/:idUsuario', function (req, res) {
    tipoController.buscarFavoritos(req, res);
});
module.exports = router;