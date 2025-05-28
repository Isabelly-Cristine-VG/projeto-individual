var favoritosUsuario = [];
var usuarioLogado = false;
var idUsuario = null;

$(document).ready(function () {
    // Verifica se o usuário está logado
    const idStorage = sessionStorage.getItem('ID_USUARIO');
    
    // Verificação mais robusta
    if (idStorage && idStorage !== "undefined" && idStorage !== "null") {
        idUsuario = parseInt(idStorage);
        usuarioLogado = !isNaN(idUsuario);
        
        if (usuarioLogado) {
            console.log("Usuário logado com ID:", idUsuario);
            carregarFavoritos();
            MostrarDadosUsuario();
        } else {
            console.error("ID de usuário inválido:", idStorage);
            // Redirecionar para login ou mostrar mensagem
            window.location.href = "login.html";
        }
    } else {
        console.error("Nenhum usuário logado");
        window.location.href = "login.html";
    }
});

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

function MostrarDadosUsuario(){
    const loadingElement = document.getElementById('tiposUsuarios');
    loadingElement.innerHTML = '<p class="loading">Carregando ginásios...</p>';

    if (!usuarioLogado || isNaN(idUsuario)) {
        console.error('ID de usuário inválido:', idUsuario);
        return;
    }

    fetch(`/perfilUsuario/mostrarTiposFavoritos/${idUsuario}`)
    .then(res => {
        if (!res.ok) throw new Error(`Erro: ${res.status}`);
        return res.json();
    })
    .then(data => {
        console.log('Favoritos recebidos:', data);
        favoritosUsuario = data.map(item => ({
            tipo: item.tipoFavorito,  // Use tipoFavorito em vez de idTipo
            cor: item.cor,
            data: item.dataFavoritado,
            nomeUsuario: item.nomeU  // Caso precise do nome do usuário
        }));
        carregarTodosTipos();
    })
    .catch(erro => {
        console.error("Erro ao carregar favoritos:", erro);
    });
}

function carregarFavoritos() {
    if (!usuarioLogado || isNaN(idUsuario)) {
        console.error('ID de usuário inválido:', idUsuario);
        return;
    }

    fetch(`/perfilUsuario/mostrarTiposFavoritos/${idUsuario}`)
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
    const container = document.getElementById('tiposUsuarios');
    if (!container) {
        console.error('Erro: div #tiposUsuarios não encontrada!');
        return;
    }

    console.log("Iniciando carregarTodosTipos..."); // Debug
    container.innerHTML = '<p>Carregando seus tipos favoritos...</p>';

    fetch(`/perfilUsuario/mostrarTiposFavoritos/${idUsuario}`)
    .then(res => {
        console.log("Resposta recebida, status:", res.status); // Debug
        if (!res.ok) {
            throw new Error(`Erro HTTP: ${res.status}`);
        }
        return res.json();
    })
    .then(data => {
        console.log("Dados recebidos:", data); // Debug importante!
        
        if (!data) {
            throw new Error("Dados são undefined");
        }
        
        if (!Array.isArray(data)) {
            console.warn("Dados não são um array:", data);
            data = []; // Força ser um array vazio
        }

        container.innerHTML = '';
        
        if (data.length === 0) {
            container.innerHTML = '<p>Você ainda não tem tipos favoritos.</p>';
            return;
        }

        // Mapeamento seguro dos dados
        const tipos = data.map(item => ({
            idTipoPokemon: item.idTipoPokemon || item.idTipo || 0,
            tipo: item.tipoFavorito || item.tipo || 'Desconhecido',
            cor: item.cor || '#cccccc'
        }));

        tipos.forEach(tipo => {
            container.innerHTML += criarCardTipo(tipo, true);
        });
    })
    .catch(erro => {
        console.error("Erro completo:", erro); // Debug detalhado
        container.innerHTML = `
            <p style="color:red">
                Erro ao carregar favoritos: ${erro.message}
            </p>
        `;
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
        }