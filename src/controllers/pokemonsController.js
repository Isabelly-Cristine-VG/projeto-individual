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

// pokemonsController.js
function buscarPokemonPorTipo(req, res) {
    const idTipo = req.params.idTipo;
    
    if (isNaN(idTipo)) {
        return res.status(400).json({ erro: "ID do tipo deve ser um número" });
    }

    pokemonsModel.buscarPokemonPorTipo(idTipo)
        .then((resultado) => {
            res.json(resultado);
        })
        .catch((erro) => {
            console.error("Erro ao buscar pokémons por tipo:", erro);
            res.status(500).json({ erro: erro.sqlMessage });
        });
}

// No final do arquivo, no module.exports, adicione:
module.exports = {
    buscarPokemon,
    buscarPokemonPorTipo,  // ← Certifique-se que está incluído aqui
    habilidadesPorPokemon
};