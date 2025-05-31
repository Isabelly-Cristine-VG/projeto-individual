var database = require("../database/config")



function mostrarTiposFavoritos(idUsuario) {
    var instrucaoSql = `
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

function informacaoTiposFavoritos(idTipo) {
    console.log(`Buscando informações para o tipo ID: ${idTipo}`);
    
    var instrucaoSql = `
        SELECT 
            t2.tipo AS tipoAtacante,
            vt.multiplicador,
            t2.cor
            FROM vantagemTipo vt
            JOIN tipoPokemon t2 ON vt.idTipoAtacante = t2.idTipoPokemon
            WHERE vt.idTipoDefensor = ?
        ORDER BY vt.multiplicador DESC, t2.tipo;

    `;
    
    return database.executar(instrucaoSql, [idTipo]);
}

function contarTiposFavoritos(idTipo) {
    var instrucaoSql = `
        SELECT 
            SUM(CASE WHEN multiplicador = 2 THEN 1 ELSE 0 END) AS totalFraquezas,
            SUM(CASE WHEN multiplicador = 0.5 THEN 1 ELSE 0 END) AS totalResistencias,
            SUM(CASE WHEN multiplicador = 0 THEN 1 ELSE 0 END) AS totalImunidades
        FROM vantagemTipo
        WHERE idTipoDefensor = ${idTipo};
    `;
    
    return database.executar(instrucaoSql);
}

module.exports = {
    mostrarTiposFavoritos,
    informacaoTiposFavoritos,
    contarTiposFavoritos
};