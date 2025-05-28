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

function contarVantagensPorTipo(req, res) {
    const idTipo = parseInt(req.params.idTipo);
    
    if (isNaN(idTipo)) {
        return res.status(400).json({ erro: "ID do tipo deve ser um número" });
    }

    tipoModel.contarVantagensPorTipo(idTipo)
        .then((resultado) => {
            // Certifique-se que está retornando um objeto com as propriedades corretas
            res.json({
                totalFraquezas: resultado[0].totalFraquezas || 0,
                totalResistencias: resultado[0].totalResistencias || 0,
                totalImunidades: resultado[0].totalImunidades || 0
            });
        })
        .catch((erro) => {
            console.error("Erro ao contar vantagens:", erro);
            res.status(500).json({ erro: "Erro no servidor" });
        });
}

// Adicione estas novas funções ao tipoController.js
function favoritarTipo(req, res) {
    const idUsuario = req.body.idUsuario;
    const idTipo = req.body.idTipo;

    if (isNaN(idUsuario)) {
        return res.status(400).json({ erro: "ID do usuário inválido" });
    }
    if (isNaN(idTipo)) {
        return res.status(400).json({ erro: "ID do tipo inválido" });
    }

    tipoModel.favoritarTipo(idUsuario, idTipo)
        .then(() => {
            res.json({ success: true });
        })
        .catch((erro) => {
            console.error("Erro ao favoritar tipo:", erro);
            res.status(500).json({ erro: "Erro ao favoritar tipo" });
        });
}

function desfavoritarTipo(req, res) {
    const idUsuario = req.body.idUsuario;
    const idTipo = req.body.idTipo;

    if (isNaN(idUsuario)) {
        return res.status(400).json({ erro: "ID do usuário inválido" });
    }
    if (isNaN(idTipo)) {
        return res.status(400).json({ erro: "ID do tipo inválido" });
    }

    tipoModel.desfavoritarTipo(idUsuario, idTipo)
        .then(() => {
            res.json({ success: true });
        })
        .catch((erro) => {
            console.error("Erro ao desfavoritar tipo:", erro);
            res.status(500).json({ erro: "Erro ao desfavoritar tipo" });
        });
}

function buscarFavoritos(req, res) {
    const idUsuario = parseInt(req.params.idUsuario);
    
    if (isNaN(idUsuario)) {
        return res.status(400).json({ erro: "ID do usuário inválido" });
    }

    tipoModel.buscarFavoritos(idUsuario)
        .then((resultado) => {
            // Garante que retorna um array com os IDs
            res.json(resultado.map(item => ({
                idTipoPokemon: item.idTipoPokemon || item.idTipo
            })));
        })
        .catch((erro) => {
            console.error("Erro ao buscar favoritos:", erro);
            res.status(500).json({ erro: "Erro ao buscar favoritos" });
        });
}

module.exports = {
    // Consultas básicas de tipos
    buscarTipo,
    buscarVantagensPorTipo,
    contarVantagensPorTipo,
    
    // Gestão de favoritos
    favoritarTipo,
    desfavoritarTipo,
    buscarFavoritos
  
};