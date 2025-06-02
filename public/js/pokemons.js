$(document).ready(function () {
    // Inicializa o Select2
    $('#filtroTipo').select2();

    carregarTiposParaFiltro();

    carregarPokemons();

    // Evento de change no filtro
    $('#filtroTipo').on('change', function () {
        const tipoSelecionado = $(this).val();
        if (tipoSelecionado) {
            carregarPokemonsPorTipo(tipoSelecionado);
        } else {
            carregarPokemons();
        }
    });
});

function carregarTiposParaFiltro() {
    fetch('/tipo/buscarTipo')
        .then(response => response.json())
        .then(tipos => {
            const select = $('#filtroTipo');
            tipos.forEach(tipo => {
                select.append(new Option(tipo.tipo, tipo.idTipoPokemon));
            });
        })
        .catch(error => console.error('Erro ao carregar tipos:', error));
}

function carregarPokemons() {
    fetch('/pokemon/buscarPokemon')
        .then(response => response.json())
        .then(pokemons => {
            exibirPokemons(pokemons);
        })
        .catch(error => console.error('Erro ao carregar Pokémon:', error));
}

function carregarPokemonsPorTipo(idTipo) {
    fetch(`/pokemon/buscarPokemonPorTipo/${idTipo}`)
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => {
                    throw new Error(`Erro HTTP: ${response.status} - ${text}`);
                });
            }
            return response.json();
        })
        .then(pokemons => {
            exibirPokemons(pokemons);
        })
        .catch(error => {
            console.error('Erro completo:', error);
            alert('Erro ao carregar Pokémon por tipo. Veja o console para detalhes.');
        });
}

function exibirPokemons(pokemons) {
    const container = document.getElementById('pokemonContainer');
    container.innerHTML = '';

    if (pokemons.length === 0) {
        container.innerHTML = '<p>Nenhum Pokémon encontrado com o filtro selecionado.</p>';
        return;
    }

    pokemons.forEach(pokemon => {
        const card = document.createElement('div');
        card.className = 'pokemon-card';

        // Imagem do Pokémon (usando imagemUrl do banco ou placeholder)
        const imgUrl = pokemon.imagemUrl || 'assets/pokemon-placeholder.png';

        // Tipos do Pokémon
        let tiposHTML = '';
        if (pokemon.tipo1) {
            tiposHTML += `<span class="type-badge" style="background-color: ${pokemon.cor1}">${pokemon.tipo1}</span>`;
        }
        if (pokemon.tipo2) {
            tiposHTML += `<span class="type-badge" style="background-color: ${pokemon.cor2}">${pokemon.tipo2}</span>`;
        }

        card.innerHTML = `
                    <button onclick=""
                    style="background: rgb(246, 89, 89); border: double; border-radius:20px; font-size: 20px; cursor: pointer; color: rgb(255, 229, 208);">
                     Adicionar ao time
                    </button>
                    <img src="${imgUrl}" alt="${pokemon.nome}" class="pokemon-image">
                    <div class="pokemon-info">
                        <h3 class="pokemon-name">${pokemon.nome}</h3>
                        <p class="pokemon-species">${pokemon.especie}</p>
                        
                        <div class="pokemon-desc"><p style="color: #8e5656; overflow-wrap: break-word;">${pokemon.descricao}</p></div>
                        <div class="pokemon-types">
                            ${tiposHTML}
                        </div>
                    </div>
                `;

        container.appendChild(card);
    });
}