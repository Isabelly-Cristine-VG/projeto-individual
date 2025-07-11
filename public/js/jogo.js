function ginasiosDadosFireRed() {
    const loadingElement = document.getElementById('ginasios');
    loadingElement.innerHTML = '<p class="loading">Carregando ginásios...</p>';

    fetch('/jogos/buscarGinasios/1')
        .then(async response => {
            const data = await response.json();
            if (!response.ok) {
                const error = new Error(data.message || 'Erro ao carregar');
                error.details = data;
                throw error;
            }
            return data;
        })
        .then(data => {
            if (data.success && data.data && data.data.length > 0) {
                exibirTimesGinasio(data.data);
            } else {
                loadingElement.innerHTML =
                    `<p class="warning">${data.message || 'Nenhum ginásio encontrado'}</p>`;
            }
        })
        .catch(error => {
            console.error('Erro completo:', error);
            let errorMessage = error.message;
            if (error.details?.sqlError) {
                errorMessage += `<br><small>Detalhe: ${error.details.sqlError}</small>`;
            }
            loadingElement.innerHTML =
                `<p class="error">${errorMessage}</p>`;
        });
}

function ginasiosDadosHeartGold() {
    const loadingElement = document.getElementById('ginasios');
    loadingElement.innerHTML = '<p class="loading">Carregando ginásios...</p>';

    fetch('/jogos/buscarGinasios/2')
        .then(async response => {
            const data = await response.json();
            if (!response.ok) {
                const error = new Error(data.message || 'Erro ao carregar');
                error.details = data;
                throw error;
            }
            return data;
        })
        .then(data => {
            if (data.success && data.data && data.data.length > 0) {
                exibirTimesGinasio(data.data);
            } else {
                loadingElement.innerHTML =
                    `<p class="warning">${data.message || 'Nenhum ginásio encontrado'}</p>`;
            }
        })
        .catch(error => {
            console.error('Erro completo:', error);
            let errorMessage = error.message;
            if (error.details?.sqlError) {
                errorMessage += `<br><small>Detalhe: ${error.details.sqlError}</small>`;
            }
            loadingElement.innerHTML =
                `<p class="error">${errorMessage}</p>`;
        });
}

function ginasiosDadosRuby() {
    const loadingElement = document.getElementById('ginasios');
    loadingElement.innerHTML = '<p class="loading">Carregando ginásios...</p>';

    fetch('/jogos/buscarGinasios/3')
        .then(async response => {
            const data = await response.json();
            if (!response.ok) {
                const error = new Error(data.message || 'Erro ao carregar');
                error.details = data;
                throw error;
            }
            return data;
        })
        .then(data => {
            if (data.success && data.data && data.data.length > 0) {
                exibirTimesGinasio(data.data);
            } else {
                loadingElement.innerHTML =
                    `<p class="warning">${data.message || 'Nenhum ginásio encontrado'}</p>`;
            }
        })
        .catch(error => {
            console.error('Erro completo:', error);
            let errorMessage = error.message;
            if (error.details?.sqlError) {
                errorMessage += `<br><small>Detalhe: ${error.details.sqlError}</small>`;
            }
            loadingElement.innerHTML =
                `<p class="error">${errorMessage}</p>`;
        });
}

function ginasiosDadosDiamond() {
    const loadingElement = document.getElementById('ginasios');
    loadingElement.innerHTML = '<p class="loading">Carregando ginásios...</p>';

    fetch('/jogos/buscarGinasios/4')
        .then(async response => {
            const data = await response.json();
            if (!response.ok) {
                const error = new Error(data.message || 'Erro ao carregar');
                error.details = data;
                throw error;
            }
            return data;
        })
        .then(data => {
            if (data.success && data.data && data.data.length > 0) {
                exibirTimesGinasio(data.data);
            } else {
                loadingElement.innerHTML =
                    `<p class="warning">${data.message || 'Nenhum ginásio encontrado'}</p>`;
            }
        })
        .catch(error => {
            console.error('Erro completo:', error);
            let errorMessage = error.message;
            if (error.details?.sqlError) {
                errorMessage += `<br><small>Detalhe: ${error.details.sqlError}</small>`;
            }
            loadingElement.innerHTML =
                `<p class="error">${errorMessage}</p>`;
        });
}

function ginasiosDadosBlackWhite() {
    const loadingElement = document.getElementById('ginasios');
    loadingElement.innerHTML = '<p class="loading">Carregando ginásios...</p>';

    fetch('/jogos/buscarGinasios/5')
        .then(async response => {
            const data = await response.json();
            if (!response.ok) {
                const error = new Error(data.message || 'Erro ao carregar');
                error.details = data;
                throw error;
            }
            return data;
        })
        .then(data => {
            if (data.success && data.data && data.data.length > 0) {
                exibirTimesGinasio(data.data);
            } else {
                loadingElement.innerHTML =
                    `<p class="warning">${data.message || 'Nenhum ginásio encontrado'}</p>`;
            }
        })
        .catch(error => {
            console.error('Erro completo:', error);
            let errorMessage = error.message;
            if (error.details?.sqlError) {
                errorMessage += `<br><small>Detalhe: ${error.details.sqlError}</small>`;
            }
            loadingElement.innerHTML =
                `<p class="error">${errorMessage}</p>`;
        });
}

function exibirTimesGinasio(dados) {
    const timesPorLider = {};
    let html = '';

    // Agrupamento
    for (let i = 0; i < dados.length; i++) {
        const item = dados[i];
        timesPorLider[item.lider] = timesPorLider[item.lider] || [];
        timesPorLider[item.lider].push(item);
    }

    // Construção do HTML
    const lideres = Object.keys(timesPorLider);

    for (let i = 0; i < lideres.length; i++) {
        const lider = lideres[i];
        const pokemons = timesPorLider[lider];
        let pokemonsHTML = '';



        for (let j = 0; j < pokemons.length; j++) {
            const p = pokemons[j];
            console.log('Pokémon:', p);


            let tiposHTML = `<span class="type-badge" style="background-color: ${p.tipoCor}">${p.tipo}</span>`;

if (p.tipo2) {
    tiposHTML += `<span class="type-badge" style="background-color: ${p.tipoCor2}">${p.tipo2}</span>`;
}


            pokemonsHTML += `
        <div class="pokemon-card" style="border-color: ${p.tipoCor}">
            <img src="${p.pokemon}" alt="${p.nomeP}">
            <p>${p.nomeP}</p>
            <div class="pokemon-types">
                ${tiposHTML}
            </div>
        </div>`;
        }


        html += `
            <div class="time-lider">
                <h3>${lider} (${pokemons[0].cidade})</h3>
                <div class="pokemons-container">${pokemonsHTML}</div>
            </div>`;
    }

    ginasios.innerHTML = html;
}