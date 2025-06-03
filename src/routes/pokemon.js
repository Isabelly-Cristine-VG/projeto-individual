var express = require("express");
var router = express.Router();

var pokemonsController = require("../controllers/pokemonsController");

router.get("/buscarPokemon", function (req, res) {
    pokemonsController.buscarPokemon(req, res);
});


router.get('/buscarPokemonPorTipo/:idTipo', function (req, res) {
    pokemonsController.buscarPokemonPorTipo(req, res);
});

router.post('/timePokemon', function (req, res) {
    pokemonsController.timePokemon(req, res);
});

module.exports = router;