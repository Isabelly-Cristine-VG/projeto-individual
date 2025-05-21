var jogoModel = require("../models/jogoModel");

// jogoController.js
function buscarGinasios(req, res) {
    const idRegiao = parseInt(req.params.idRegiao);
    
    if (isNaN(idRegiao)) {
        return res.status(400).json({ 
            success: false,
            message: "ID da região inválido"
        });
    }

    jogoModel.buscarGinasios(idRegiao)
        .then(resultado => {
            if (!resultado || resultado.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: "Nenhum ginásio encontrado para esta região"
                });
            }
            res.status(200).json({
                success: true,
                data: resultado
            });
        })
        .catch(erro => {
            console.error('Erro detalhado:', erro);
            res.status(500).json({
                success: false,
                message: "Erro ao buscar ginásios",
                error: erro.message,
                sqlError: erro.sqlMessage  // Adiciona informação específica do SQL
            });
        });
}

module.exports = {
    buscarGinasios
};