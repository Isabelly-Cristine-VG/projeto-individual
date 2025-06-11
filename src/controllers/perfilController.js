var perfilModel = require("../models/perfilModel");

function mostrarTiposFavoritos(req, res) {
    var idUsuario = req.params.idUsuario;

    if (isNaN(idUsuario)) {
        return res.status(400).json([]); // Retorna array vazio
    }

    perfilModel.mostrarTiposFavoritos(idUsuario)
        .then(function(resultado) {
            // Garante que retorna um array
            res.json(Array.isArray(resultado) ? resultado : []);
        })
        .catch(function(erro) {
            console.error(erro);
            res.status(500).json([]); // Retorna array vazio em caso de erro
        });
}

function informacaoTiposFavoritos(req, res) {
    const idTipo = req.params.idTipo;
    console.log(`Controller - ID recebido: ${idTipo}`); // Novo log
    
    if (!idTipo || isNaN(idTipo)) {
        console.log('ID inválido recebido'); // Novo log
        return res.status(400).json({ erro: "ID do tipo inválido" });
    }

    perfilModel.informacaoTiposFavoritos(idTipo)
        .then(resultado => {
            console.log(`Resultado da query: ${JSON.stringify(resultado)}`); // Novo log
            if (!resultado || resultado.length === 0) {
                return res.status(404).json({ erro: "Nenhum dado encontrado" });
            }
            res.status(200).json(resultado);
        })
        .catch(erro => {
            console.error("Erro completo no controller:", erro); // Log detalhado
            res.status(500).json({ erro: "Erro interno no servidor" });
        });
}

function contarTiposFavoritos(req, res) {
    const idTipo = parseInt(req.params.idTipo);
    
    if (isNaN(idTipo)) {
        return res.status(400).json({ erro: "ID do tipo deve ser um número" });
    }
    // kpis das vantagens e desvantagens
    perfilModel.contarTiposFavoritos(idTipo)
        .then((resultado) => {
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

module.exports = {
    mostrarTiposFavoritos,
    informacaoTiposFavoritos,
    contarTiposFavoritos
};
