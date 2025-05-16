var charts = {
    fraquezas: null,
    resistencias: null,
    imunidades: null
};

$(document).ready(function () {
    // Inicializa o Select2
    $('#ipt_tipo').select2();

    // Busca os tipos Pokémon
    carregarTipos();

    // Evento de change do select
    $('#ipt_tipo').on('change', function() {
        const idTipo = $(this).val();
        
        // Limpar tudo antes de carregar novos dados
        destruirGraficos();
        limparMensagens();
        
        if (idTipo) {
            carregarVantagens(idTipo);
        }
    });
});

function limparMensagens() {
    const containers = [
        document.getElementById('fraquezasChart').parentNode,
        document.getElementById('resistenciasChart').parentNode,
        document.getElementById('imunidadesChart').parentNode
    ];
    
    containers.forEach(container => {
        const messages = container.querySelectorAll('.no-data-message');
        messages.forEach(msg => msg.remove());
        container.querySelector('canvas').style.display = 'block';
    });
}

function destruirGraficos() {
    Object.keys(charts).forEach(key => {
        if (charts[key]) {
            charts[key].destroy();
            charts[key] = null;
        }
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
    })
    .catch(erro => {
        console.error("Erro ao carregar tipos:", erro);
        alert("Erro ao carregar tipos. Recarregue a página.");
    });
}

function carregarVantagens(idTipo) {
    console.log(`Buscando vantagens para tipo ID: ${idTipo}`);
    
    fetch(`/tipo/buscarVantagensPorTipo/${idTipo}`)
    .then(async res => {
        const data = await res.json();
        if (!res.ok) {
            const error = new Error(data.erro || 'Erro desconhecido');
            error.response = data;
            throw error;
        }
        return data;
    })
    .then(dados => {
        console.log('Dados recebidos:', dados);
        criarGraficos(dados, $('#ipt_tipo option:selected').text());
    })
    .catch(erro => {
        console.error("Erro completo:", erro);
        alert(`Erro: ${erro.message}`);
        destruirGraficos();
    });
}

function criarGraficos(dados, tipoNome) {
    destruirGraficos();
    limparMensagens();
    
    // Converter multiplicadores para número e arredondar
    const dadosProcessados = dados.map(item => ({
        ...item,
        multiplicador: Number(item.multiplicador).toFixed(1)
    }));

    console.log('Dados processados:', dadosProcessados);

    // Filtrar com comparação estrita
    const fraquezas = dadosProcessados.filter(item => item.multiplicador === '2.0');
    const resistencias = dadosProcessados.filter(item => item.multiplicador === '0.5');
    const imunidades = dadosProcessados.filter(item => item.multiplicador === '0.0');

    console.log('Dados filtrados:', {
        fraquezas,
        resistencias, 
        imunidades
    });

    // Criar gráficos
    if (fraquezas.length > 0) {
        charts.fraquezas = criarGraficoRosca(
            'fraquezasChart', 
            fraquezas, 
            `Fraquezas (2x) - ${tipoNome}`
        );
    } else {
        mostrarMensagemSemDados('fraquezasChart');
    }
    
    if (resistencias.length > 0) {
        charts.resistencias = criarGraficoRosca(
            'resistenciasChart', 
            resistencias, 
            `Resistências (0.5x) - ${tipoNome}`
        );
    } else {
        mostrarMensagemSemDados('resistenciasChart');
    }
    
    if (imunidades.length > 0) {
        charts.imunidades = criarGraficoRosca(
            'imunidadesChart', 
            imunidades, 
            `Imunidades (0x) - ${tipoNome}`
        );
    } else {
        mostrarMensagemSemDados('imunidadesChart');
    }
}

function mostrarMensagemSemDados(idCanvas) {
    const container = document.getElementById(idCanvas).parentNode;
    const noDataMsg = document.createElement('p');
    noDataMsg.className = 'no-data-message';
    noDataMsg.textContent = 'Nenhum dado disponível';
    container.appendChild(noDataMsg);
    document.getElementById(idCanvas).style.display = 'none';
}

function criarGraficoRosca(idCanvas, dados, titulo) {
    const ctx = document.getElementById(idCanvas);
    ctx.style.display = 'block';

    const labels = dados.map(item => item.tipoAtacante);
    const cores = dados.map(item => item.cor || getCorPadrao(idCanvas));
    const valores = dados.map(() => 1); // Valor constante para gráfico de proporção

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
        fraquezasChart: '#ff6384', // Vermelho
        resistenciasChart: '#36a2eb', // Azul
        imunidadesChart: '#ffce56' // Amarelo
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
            },
            tooltip: {
                callbacks: {
                    label: function(context) {
                        return context.label;
                    }
                }
            }
        },
        cutout: '60%',
        animation: {
            animateScale: true,
            animateRotate: true
        }
    };
}