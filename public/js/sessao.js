function validarSessao() {
    var email = sessionStorage.EMAIL_USUARIO;
    var nome = sessionStorage.NOME_USUARIO;


    if (email != null && nome != null) {
        
    } else {
        window.location = "./index.html";
    }
}

function limparSessao() {
    sessionStorage.clear();
    window.location = "./index.html";
}