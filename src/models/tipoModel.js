var database = require("../database/config")

function buscarTipo() {
    var instrucaoSql = `SELECT tipo, cor FROM tipoPokemon ORDER BY tipo;`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    buscarTipo
};