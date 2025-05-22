var database = require("../database/config")

function buscarGinasios(idRegiao) {
    const instrucaoSql = `
        SELECT lg.nomeLider AS lider, lg.cidade, r.nomeRegiao, 
        tm.nomeTime AS nomeT, tpm.posicao_no_time AS posicao,
        p.nome AS nomeP, p.imagemUrl AS pokemon, tp.tipo, tp.cor AS tipoCor, tp2.tipo AS tipo2, tp2.cor AS tipoCor2
        FROM timePokemon_membros tpm
        LEFT JOIN pokemon p ON tpm.idPokemon = p.idPokemon
        LEFT JOIN tipoPokemon tp ON p.idTipoPokemon = tp.idTipoPokemon
        LEFT JOIN tipoPokemon tp2 ON p.idTipoPokemon2 = tp2.idTipoPokemon
        LEFT JOIN timePokemon tm ON tpm.idTimePokemon = tm.idTimePokemon
        LEFT JOIN liderGinasio lg ON tm.idLider = lg.idLider
        LEFT JOIN regiao r ON lg.idRegiao = r.idRegiao
        WHERE lg.idRegiao = ${idRegiao};
    `;

    console.log(`Executando query para região ${idRegiao}`);
    return database.executar(instrucaoSql);
}

module.exports = {
    buscarGinasios
};