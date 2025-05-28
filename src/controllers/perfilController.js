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

module.exports = {
    mostrarTiposFavoritos
};