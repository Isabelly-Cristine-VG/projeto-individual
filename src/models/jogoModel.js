var database = require("../database/config")

function buscarGinasios(idRegiao) {
    const instrucaoSql = `
        SELECT lg.nomeLider AS lider, lg.cidade, r.nomeRegiao, 
        tm.nomeTime AS nomeT, tpm.posicao_no_time AS posicao,
        p.nome AS nomeP, p.imagemUrl AS pokemon, tp.tipo, tp.cor AS tipoCor
        FROM timePokemon_membros tpm
        JOIN pokemon p ON tpm.idPokemon = p.idPokemon
        JOIN tipoPokemon tp ON p.idTipoPokemon = tp.idTipoPokemon
        JOIN timePokemon tm ON tpm.idTimePokemon = tm.idTimePokemon
        JOIN liderGinasio lg ON tm.idLider = lg.idLider
        JOIN regiao r ON lg.idRegiao = r.idRegiao
        WHERE lg.idRegiao = ${idRegiao};
    `;

    console.log(`Executando query para região ${idRegiao}`);
    return database.executar(instrucaoSql);
}

module.exports = {
    buscarGinasios
};