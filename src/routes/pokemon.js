var express = require("express");
var router = express.Router();

var pokemonsController = require("../controllers/pokemonsController");

router.get("/buscarPokemon", function (req, res) {
    pokemonsController.buscarPokemon(req, res);
});


router.get('/habilidadesPorPokemon/:idPokemon(\\d+)', function (req, res) {
    pokemonsController.habilidadesPorPokemon(req, res);
});


//  rotas para favoritar tipos
router.post('/timePokemon', function (req, res) {
    pokemonsController.timePokemon(req, res);
});

router.post('/removerDoTipo', function (req, res) {
    pokemonsController.removerDoTipo(req, res);
});

router.get('/buscarTime/:idUsuario', function (req, res) {
    pokemonsController.buscarFavoritos(req, res);
});
module.exports = router;