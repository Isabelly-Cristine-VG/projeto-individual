var favoritosUsuario = [];
var usuarioLogado = false;
var idUsuario = null;

$(document).ready(function () {
    const idStorage = sessionStorage.getItem('ID_USUARIO');

    if (idStorage && idStorage !== "undefined" && idStorage !== "null") {
        idUsuario = parseInt(idStorage);
        usuarioLogado = !isNaN(idUsuario);

        if (usuarioLogado) {
            console.log("Usuário logado com ID:", idUsuario);
            carregarFavoritos();
            MostrarDadosUsuario();
        } else {
            console.error("ID de usuário inválido:", idStorage);
            window.location.href = "login.html";
        }
    } else {
        console.error("Nenhum usuário logado");
        window.location.href = "login.html";
    }
});

function MostrarDadosUsuario() {
    const loadingElement = document.getElementById('tiposUsuarios');
    loadingElement.innerHTML = '<p class="loading">Carregando tipos favoritos...</p>';

    fetch(`/perfilUsuario/mostrarTiposFavoritos/${idUsuario}`)
        .then(res => {
            if (!res.ok) throw new Error(`Erro: ${res.status}`);
            return res.json();
        })
        .then(data => {
            favoritosUsuario = data.map(item => ({
                tipo: item.tipoFavorito,
                cor: item.cor,
                data: item.dataFavoritado
            }));
            carregarTodosTipos();
        })
        .catch(erro => {
            console.error("Erro ao carregar favoritos:", erro);
            loadingElement.innerHTML = `<p style="color:red">Erro ao carregar tipos favoritos</p>`;
        });
}

function carregarFavoritos() {
    fetch(`/perfilUsuario/mostrarTiposFavoritos/${idUsuario}`)
        .then(res => {
            if (!res.ok) throw new Error(`Erro: ${res.status}`);
            return res.json();
        })
        .then(data => {
            favoritosUsuario = data.map(item => ({
                idTipo: item.idTipoPokemon, // Corrigido aqui
                data: item.dataFavoritado
            }));
        })
        .catch(erro => {
            console.error("Erro ao carregar favoritos:", erro);
        });
}

function carregarTodosTipos() {
    const container = document.getElementById('tiposUsuarios');
    container.innerHTML = '<p>Carregando seus tipos favoritos...</p>';

    fetch(`/perfilUsuario/mostrarTiposFavoritos/${idUsuario}`)
        .then(res => {
            if (!res.ok) throw new Error(`Erro HTTP: ${res.status}`);
            return res.json();
        })
        .then(data => {
            if (!Array.isArray(data) || data.length === 0) {
                container.innerHTML = '<p>Você ainda não tem tipos favoritos.</p>';
                return;
            }

            container.innerHTML = '';
            data.forEach(tipo => {
                container.innerHTML += criarCardTipo({
                    idTipoPokemon: tipo.idTipoPokemon,
                    tipo: tipo.tipoFavorito,
                    cor: tipo.cor
                }, true);
            });
        })
        .catch(erro => {
            console.error("Erro ao carregar tipos:", erro);
            container.innerHTML = `<p style="color:red">Erro: ${erro.message}</p>`;
        });
}

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
        <button class="informacaoGrafico" onclick="informacaoFavorito(${tipo.idTipoPokemon})">Mais informações</button>
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

var infoCharts = {
    fraquezas: null,
    resistencias: null,
    imunidades: null
};

function informacaoFavorito(idTipo) {
    if (!idTipo) {
        console.error("ID do tipo não foi passado corretamente:", idTipo);
        return;
    }

    console.log(`Buscando informações para tipo ID: ${idTipo}`);

    const infoContainer = document.getElementById('infoContainer');
    infoContainer.style.display = 'block';

    fetch(`/perfilUsuario/informacaoTiposFavoritos/${idTipo}`)
        .then(res => {
            if (!res.ok) throw new Error(`Erro ${res.status}: ${res.statusText}`);
            return res.json();
        })
        .then(dados => {
            if (!dados || dados.length === 0) throw new Error("Nenhum dado retornado");

            return fetch(`/perfilUsuario/contarTiposFavoritos/${idTipo}`)
                .then(res => {
                    if (!res.ok) throw new Error(`Erro ${res.status}: ${res.statusText}`);
                    return res.json();
                })
                .then(contagens => {
                    atualizarInfoKPIs(contagens);
                    criarInfoGraficos(dados, 'Tipo Favorito');
                });
        })
        .catch(erro => {
            console.error("Erro detalhado:", erro);
            infoContainer.innerHTML = `
                <p style="color:red">Erro: ${erro.message}</p>
                <button onclick="fecharInformacoes()">Fechar</button>
            `;
        });
}

function fecharInformacoes() {
    const infoContainer = document.getElementById('infoContainer');
    infoContainer.style.display = 'none';
    destruirInfoGraficos();
}

function destruirInfoGraficos() {
    Object.keys(infoCharts).forEach(key => {
        if (infoCharts[key]) {
            infoCharts[key].destroy();
            infoCharts[key] = null;
        }
    });
}

function atualizarInfoKPIs(contagens) {
    document.getElementById('infoFraquezas').textContent = contagens.totalFraquezas || '0';
    document.getElementById('infoResistencias').textContent = contagens.totalResistencias || '0';
    document.getElementById('infoImunidades').textContent = contagens.totalImunidades || '0';
}

function criarInfoGraficos(dados, tipoNome) {
    const dadosProcessados = dados.map(item => ({
        ...item,
        multiplicador: Number(item.multiplicador).toFixed(1)
    }));

    const fraquezas = dadosProcessados.filter(item => item.multiplicador === '2.0');
    const resistencias = dadosProcessados.filter(item => item.multiplicador === '0.5');
    const imunidades = dadosProcessados.filter(item => item.multiplicador === '0.0');

    infoCharts.fraquezas = criarInfoGraficoRosca('infoFraquezasChart', fraquezas, `Fraquezas (2x) - ${tipoNome}`, fraquezas.length === 0);
    infoCharts.resistencias = criarInfoGraficoRosca('infoResistenciasChart', resistencias, `Resistências (0.5x) - ${tipoNome}`, resistencias.length === 0);
    infoCharts.imunidades = criarInfoGraficoRosca('infoImunidadesChart', imunidades, `Imunidades (0x) - ${tipoNome}`, imunidades.length === 0);
}

function criarInfoGraficoRosca(idCanvas, dados, titulo, semDados) {
    const ctx = document.getElementById(idCanvas);
    const container = ctx.parentNode;

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
        infoFraquezasChart: '#ff6384',
        infoResistenciasChart: '#36a2eb',
        infoImunidadesChart: '#ffce56'
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



