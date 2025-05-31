var database = require("../database/config")

function buscarTipo() {
    var instrucaoSql = `SELECT idTipoPokemon, tipo, cor FROM tipoPokemon ORDER BY tipo;`;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarVantagensPorTipo(idTipo) {
    // Remova a validação do ID se já estiver sendo feita no controller
    var instrucaoSql = `
        SELECT 
            t2.tipo AS tipoAtacante,
            vt.multiplicador,
            t2.cor
        FROM vantagemTipo vt
        JOIN tipoPokemon t ON vt.idTipoDefensor = t.idTipoPokemon
        JOIN tipoPokemon t2 ON vt.idTipoAtacante = t2.idTipoPokemon
        WHERE t.idTipoPokemon = ${idTipo}
        ORDER BY vt.multiplicador DESC, t2.tipo;
    `;
    
    console.log("SQL executado:", instrucaoSql);
    return database.executar(instrucaoSql); // Remova o array de parâmetros
}

function contarVantagensPorTipo(idTipo) {
    var instrucaoSql = `
        SELECT 
            SUM(CASE WHEN multiplicador = 2 THEN 1 ELSE 0 END) AS totalFraquezas,
            SUM(CASE WHEN multiplicador = 0.5 THEN 1 ELSE 0 END) AS totalResistencias,
            SUM(CASE WHEN multiplicador = 0 THEN 1 ELSE 0 END) AS totalImunidades
        FROM vantagemTipo
        WHERE idTipoDefensor = ${idTipo};
    `;
    
    console.log("SQL de contagem executado:", instrucaoSql);
    return database.executar(instrucaoSql);
}


function favoritarTipo(idUsuario, idTipo) {
    var instrucaoSql = `
        INSERT INTO tiposFavoritos (idUsuario, idTipoPokemon, dataFavoritado)
        VALUES (${idUsuario}, ${idTipo}, CURRENT_TIMESTAMP)
        ON DUPLICATE KEY UPDATE dataFavoritado = CURRENT_TIMESTAMP;
    `;
    return database.executar(instrucaoSql);
}

function desfavoritarTipo(idUsuario, idTipo) {
    var instrucaoSql = `
        DELETE FROM tiposFavoritos 
        WHERE idUsuario = ${idUsuario} AND idTipoPokemon = ${idTipo};
    `;
    return database.executar(instrucaoSql);
}

function buscarFavoritos(idUsuario) {
    var instrucaoSql = `
        SELECT tf.idTipoPokemon as idTipo, tf.dataFavoritado, tp.tipo, tp.cor
        FROM tiposFavoritos tf
        JOIN tipoPokemon tp ON tf.idTipoPokemon = tp.idTipoPokemon
        WHERE tf.idUsuario = ${idUsuario}
        ORDER BY tf.dataFavoritado DESC;
    `;
    return database.executar(instrucaoSql);
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