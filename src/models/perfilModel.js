var database = require("../database/config")



function mostrarTiposFavoritos(idUsuario) {
    const instrucaoSql = `
        SELECT 
            tp.idTipoPokemon,
            tp.tipo as tipoFavorito, 
            tf.dataFavoritado, 
            tp.cor
        FROM tiposFavoritos tf
        JOIN usuario u ON tf.idUsuario = u.idUsuario
        JOIN tipoPokemon tp ON tf.idTipoPokemon = tp.idTipoPokemon
        WHERE tf.idUsuario = ${idUsuario}
        ORDER BY tf.dataFavoritado DESC;
    `;
    
    return database.executar(instrucaoSql)
        .then(resultado => resultado || []); // Garante array vazio se undefined
}

module.exports = {
    mostrarTiposFavoritos
};