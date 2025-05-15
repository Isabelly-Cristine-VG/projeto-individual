var tipoModel = require("../models/tipoModel");


function buscarTipo(req, res) {
    tipoModel.buscarTipo()
        .then((resultado) => {
            res.json(resultado);
        })
        .catch((erro) => {
            console.error("Erro ao buscar tipos:", erro);
            res.status(500).json({ erro: erro.sqlMessage });
        });
}


module.exports = {
    buscarTipo
}