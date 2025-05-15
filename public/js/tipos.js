var tipos = {};

$(document).ready(function () {
    // Inicializa o Select2
    $('#ipt_tipo').select2();

    // Busca os tipos Pokémon
    fetch("/tipo/buscarTipo", {
        method: "POST"
    })
        .then(res => res.json())
        .then(dados => {
            $('#ipt_tipo').empty();
            $('#ipt_tipo').append(new Option('Selecione o tipo', ''));

            dados.forEach(tipo => {
                $('#ipt_tipo').append(new Option(tipo.tipo, tipo.idTipoPokemon));
                // Ou manter como estava: new Option(tipo.tipo, tipo.tipo)
            });

            $('#ipt_tipo').trigger('change');
        })
        .catch(erro => console.error("Erro ao carregar tipos:", erro));
});