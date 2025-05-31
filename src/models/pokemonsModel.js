// pokemonsModel.js
var database = require("../database/config")

function buscarPokemon() {
    var instrucaoSql = `
    SELECT 
        p.idPokemon, p.nome, p.especie, p.descricao, 
        p.idTipoPokemon, p.idTipoPokemon2, p.imagemUrl,
        t1.tipo as tipo1, t1.cor as cor1, t2.tipo as tipo2, t2.cor as cor2
        FROM pokemon p
        JOIN tipoPokemon t1 ON p.idTipoPokemon = t1.idTipoPokemon
        LEFT JOIN tipoPokemon t2 ON p.idTipoPokemon2 = t2.idTipoPokemon
        ORDER BY p.nome;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}


function habilidadesPorPokemon(idPokemon) {
    var instrucaoSql = `
        SELECT 
            hpBase, ataqueBase, defesaBase, ataqueEspecial_base, 
            defesaEspecial_base, velocidadeBase 
            FROM pokemon
            WHERE idPokemon = ${idPokemon};
    `;
    
    console.log("SQL de habilidades executado:", instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    buscarPokemon,
    habilidadesPorPokemon
};