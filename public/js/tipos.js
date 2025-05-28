var charts = {
    fraquezas: null,
    resistencias: null,
    imunidades: null
};
var favoritosUsuario = [];
var usuarioLogado = false;
var idUsuario = null;


$(document).ready(function () {
    // Verifica se o usuário está logado
    const idStorage = sessionStorage.getItem('ID_USUARIO');
    usuarioLogado = idStorage !== null && idStorage !== "undefined" && !isNaN(idStorage);
    idUsuario = usuarioLogado ? parseInt(idStorage) : null;

    if (usuarioLogado) {
        carregarFavoritos();
    }
    // Inicializa o Select2
    $('#ipt_tipo').select2();

    // Busca os tipos Pokémon
    carregarTipos();

    // Evento de change do select
    $('#ipt_tipo').on('change', function () {
        const idTipo = $(this).val();

        destruirGraficos();

        if (!idTipo) {
            // Resetar tudo apenas quando não há tipo selecionado
            limparTudo();
        } else {
            carregarVantagens(idTipo);
        }
    });
});

function limparTudo() {
    destruirGraficos();
    resetarKPIs();
}

function resetarKPIs() {
    document.getElementById('totalFraquezas').textContent = '0';
    document.getElementById('totalResistencias').textContent = '0';
    document.getElementById('totalImunidades').textContent = '0';
}

function carregarVantagens(idTipo) {
    // Primeiro busca as contagens para os KPIs
    fetch(`/tipo/contarVantagensPorTipo/${idTipo}`)
        .then(res => {
            if (!res.ok) throw new Error("Erro ao buscar contagens");
            return res.json();
        })
        .then(contagens => {
            console.log('Contagens recebidas:', contagens);
            // Atualiza os KPIs
            atualizarKPIs(contagens);

            // Depois busca os detalhes para os gráficos
            return fetch(`/tipo/buscarVantagensPorTipo/${idTipo}`);
        })
        .then(res => {
            if (!res.ok) throw new Error("Erro ao buscar detalhes");
            return res.json();
        })
        .then(dados => {
            console.log('Dados detalhados recebidos:', dados);
            criarGraficos(dados, $('#ipt_tipo option:selected').text());
        })
        .catch(erro => {
            console.error("Erro completo:", erro);
            alert(`Erro: ${erro.message}`);
            limparTudo();
        });
}

function atualizarKPIs(contagens) {
    document.getElementById('totalFraquezas').textContent = contagens.totalFraquezas || '0';
    document.getElementById('totalResistencias').textContent = contagens.totalResistencias || '0';
    document.getElementById('totalImunidades').textContent = contagens.totalImunidades || '0';
}

function destruirGraficos() {
    Object.keys(charts).forEach(key => {
        if (charts[key]) {
            charts[key].destroy();
            charts[key] = null;
        }
    });

    // Limpar mensagens de todos os gráficos
    ['fraquezasChart', 'resistenciasChart', 'imunidadesChart'].forEach(id => {
        const container = document.getElementById(id).parentNode;
        const messages = container.querySelectorAll('.no-data-message');
        messages.forEach(msg => msg.remove());
        document.getElementById(id).style.display = 'block';
    });
}

function carregarTipos() {
    fetch("/tipo/buscarTipo")
        .then(res => {
            if (!res.ok) throw new Error("Erro na requisição");
            return res.json();
        })
        .then(dados => {
            $('#ipt_tipo').empty().append(new Option('Selecione o tipo', ''));
            dados.forEach(tipo => {
                $('#ipt_tipo').append(new Option(tipo.tipo, tipo.idTipoPokemon));
            });
            
            // Re-inicializa o Select2 após carregar os dados
            $('#ipt_tipo').select2();
        })
        .catch(erro => {
            console.error("Erro ao carregar tipos:", erro);
            alert("Erro ao carregar tipos. Recarregue a página.");
        });
}

function criarGraficos(dados, tipoNome) {
    // Converter multiplicadores para número e arredondar
    const dadosProcessados = dados.map(item => ({
        ...item,
        multiplicador: Number(item.multiplicador).toFixed(1)
    }));

    // Filtrar com comparação estrita
    const fraquezas = dadosProcessados.filter(item => item.multiplicador === '2.0');
    const resistencias = dadosProcessados.filter(item => item.multiplicador === '0.5');
    const imunidades = dadosProcessados.filter(item => item.multiplicador === '0.0');

    // Criar gráficos com tratamento para dados vazios
    charts.fraquezas = criarGraficoRosca(
        'fraquezasChart',
        fraquezas,
        `Fraquezas (2x) - ${tipoNome}`,
        fraquezas.length === 0
    );

    charts.resistencias = criarGraficoRosca(
        'resistenciasChart',
        resistencias,
        `Resistências (0.5x) - ${tipoNome}`,
        resistencias.length === 0
    );

    charts.imunidades = criarGraficoRosca(
        'imunidadesChart',
        imunidades,
        `Imunidades (0x) - ${tipoNome}`,
        imunidades.length === 0
    );
}

function criarGraficoRosca(idCanvas, dados, titulo, semDados) {
    const ctx = document.getElementById(idCanvas);
    const container = ctx.parentNode;

    // Limpar mensagens anteriores
    const messages = container.querySelectorAll('.no-data-message');
    messages.forEach(msg => msg.remove());

    if (semDados || !dados || dados.length === 0) {
        const noDataMsg = document.createElement('p');
        noDataMsg.className = 'no-data-message';
        noDataMsg.textContent = 'Nenhum dado disponível';
        container.appendChild(noDataMsg);
        ctx.style.display = 'none';
        return null;
    }

    ctx.style.display = 'block';

    const labels = dados.map(item => item.tipoAtacante);
    const cores = dados.map(item => item.cor || getCorPadrao(idCanvas));
    const valores = dados.map(() => 1);

    return new Chart(ctx.getContext('2d'), {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                data: valores,
                backgroundColor: cores,
                borderWidth: 1
            }]
        },
        options: getChartOptions(titulo)
    });
}

function getCorPadrao(idCanvas) {
    const cores = {
        fraquezasChart: '#ff6384',
        resistenciasChart: '#36a2eb',
        imunidadesChart: '#ffce56'
    };
    return cores[idCanvas] || '#cccccc';
}

function getChartOptions(titulo) {
    return {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            title: {
                display: true,
                text: titulo,
                font: {
                    size: 14,
                    weight: 'bold'
                }
            },
            legend: {
                position: 'right',
                labels: {
                    boxWidth: 12,
                    padding: 10,
                    usePointStyle: true
                }
            }
        },
        cutout: '60%'
    };
}


// Atualize a função carregarFavoritos:
function carregarFavoritos() {
    if (!usuarioLogado || isNaN(idUsuario)) {
        console.error('ID de usuário inválido:', idUsuario);
        return;
    }

    fetch(`/tipo/buscarFavoritos/${idUsuario}`)
    .then(res => {
        if (!res.ok) throw new Error(`Erro: ${res.status}`);
        return res.json();
    })
    .then(data => {
        console.log('Favoritos recebidos:', data); // Debug
        favoritosUsuario = data.map(item => ({
            idTipo: item.idTipo,
            data: item.dataFavoritado
        }));
        carregarTodosTipos();
    })
    .catch(erro => {
        console.error("Erro ao carregar favoritos:", erro);
    });
}

function carregarTodosTipos() {
    // 1. Verifica se o elemento existe
    const container = document.getElementById('listaTipos');
    if (!container) {
        console.error('Erro: div #listaTipos não encontrada!');
        return;
    }

    // 2. Mostra mensagem de carregamento
    container.innerHTML = '<p>Carregando tipos...</p>';

    // 3. Busca os tipos e favoritos
    Promise.all([
        fetch("/tipo/buscarTipo").then(res => res.json()),
        fetch(`/tipo/buscarFavoritos/${idUsuario}`).then(res => res.json())
    ])
    .then(([tipos, favoritos]) => {
        // 4. Extrai apenas os IDs dos favoritos
        const idsFavoritos = favoritos.map(f => f.idTipoPokemon || f.idTipo);
        
        // 5. Limpa o container
        container.innerHTML = '';
        
        // 6. Adiciona cada tipo
        tipos.forEach(tipo => {
            const estaFavoritado = idsFavoritos.includes(tipo.idTipoPokemon);
            container.innerHTML += criarCardTipo(tipo, estaFavoritado);
        });
    })
    .catch(erro => {
        console.error("Erro:", erro);
        container.innerHTML = '<p style="color:red">Erro ao carregar</p>';
    });
}

// Função auxiliar para criar o HTML do card
function criarCardTipo(tipo, estaFavoritado) {
    return `
    <div class="tipo-card" style="background-color: ${tipo.cor || '#ccc'}; 
        padding: 15px; margin: 10px; border-radius: 8px; color: white;">
        <h3 style="margin-top: 0;">${tipo.tipo}</h3>
        <p>${getDescricao(tipo.tipo)}</p>
        ${usuarioLogado ? `
        <button onclick="toggleFavorito(${tipo.idTipoPokemon}, this)"
            style="background: none; border: none; font-size: 20px; cursor: pointer; color: rgb(255, 243, 178);">
            ${estaFavoritado ? '★' : '☆'}
        </button>` : ''}
    </div>`;
}


function getDescricao(tipo) {
    const descricoes = {
        'Água': 'Fortes contra Fogo e Terra',
        'Fogo': 'Fortes contra Planta e Gelo',
        'Planta': 'Fortes contra Água e Pedra',
        'Elétrico': 'Fortes contra Água e Voador',
        
    };
    return descricoes[tipo] || `Pokémon do tipo ${tipo}`;
}


function criarElementoTipo(tipo, estaFavoritado) {
   
    const htmlDoCard = `
        <div class="tipo-card" style="background-color: ${tipo.cor || '#cccccc'}; padding: 10px; margin: 10px; border-radius: 5px;">
            <h3 style="margin: 0;">${tipo.tipo}</h3>
            <p style="margin: 5px 0;">${getDescricao(tipo.tipo)}</p>
            ${usuarioLogado ? 
                `<button onclick="toggleFavorito(${tipo.idTipoPokemon}, this)" 
                 style="background: none; border: none; font-size: 20px; cursor: pointer;">
                    ${estaFavoritado ? '★' : '☆'}
                </button>` 
                : ''
            }
        </div>
    `;
    
    // Cria um elemento div temporário para converter a string em HTML
    const divTemp = document.createElement('div');
    divTemp.innerHTML = htmlDoCard;
    
    
    return divTemp.firstChild;
}


function toggleFavorito(idTipo, botao) {
    if (!usuarioLogado) {
        alert('Faça login para favoritar!');
        return;
    }

    const estaFavoritado = botao.innerHTML.includes('★');
    
    fetch(estaFavoritado ? '/tipo/desfavoritarTipo' : '/tipo/favoritarTipo', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            idUsuario: idUsuario,
            idTipo: idTipo
        })
    })
    .then(res => res.json())
    .then(resposta => {
        if (resposta.success) {
            botao.innerHTML = estaFavoritado ? '☆' : '★';
        } else {
            alert('Ocorreu um erro!');
        }
    })
    .catch(erro => {
        console.error('Erro:', erro);
        alert('Erro na conexão!');
    });
}
// Função auxiliar para descrições dos tipos 
