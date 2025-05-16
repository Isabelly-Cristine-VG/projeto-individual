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

function buscarVantagensPorTipo(req, res) {
    const idTipo = parseInt(req.params.idTipo);
    
    if (isNaN(idTipo)) {
        return res.status(400).json({ erro: "ID do tipo deve ser um número" });
    }

    console.log(`Buscando vantagens para o tipo ID: ${idTipo}`);
    
    tipoModel.buscarVantagensPorTipo(idTipo)
        .then((resultado) => {
            console.log('Dados retornados:', resultado);
            res.json(resultado);
        })
        .catch((erro) => {
            console.error("Erro ao buscar vantagens:", erro);
            res.status(500).json({ 
                erro: "Erro no servidor",
                detalhes: process.env.NODE_ENV === 'development' ? erro.message : undefined
            });
        });
}

module.exports = {
    buscarTipo,
    buscarVantagensPorTipo
};