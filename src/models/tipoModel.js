var database = require("../database/config")

function buscarTipo() {
    var instrucaoSql = `SELECT idTipoPokemon, tipo, cor FROM tipoPokemon ORDER BY tipo;`;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarVantagensPorTipo(idTipo) {
    // Remova a validação do ID se já estiver sendo feita no controller
    const instrucaoSql = `
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

module.exports = {
    buscarTipo,
    buscarVantagensPorTipo
};