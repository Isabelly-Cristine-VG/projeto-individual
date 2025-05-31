// pokemonsController.js
var pokemonsModel = require("../models/pokemonsModel");

function buscarPokemon(req, res) {
    pokemonsModel.buscarPokemon()
        .then((resultado) => {
            res.json(resultado);
        })
        .catch((erro) => {
            console.error("Erro ao buscar pokémons:", erro);
            res.status(500).json({ erro: erro.sqlMessage });
        });
}

function habilidadesPorPokemon(req, res) {
    const idPokemon = parseInt(req.params.idPokemon);
    
    if (isNaN(idPokemon)) {
        return res.status(400).json({ erro: "ID do Pokémon deve ser um número" });
    }

    pokemonsModel.habilidadesPorPokemon(idPokemon)
        .then((resultado) => {
            res.json(resultado);
        })
        .catch((erro) => {
            console.error("Erro ao buscar habilidades:", erro);
            res.status(500).json({ erro: "Erro no servidor" });
        });
}

module.exports = {
    buscarPokemon,
    buscarPokemonPorTipo,
    habilidadesPorPokemon
};