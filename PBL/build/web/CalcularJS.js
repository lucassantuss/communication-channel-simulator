function calcularValores(valor1, valor2) {
    // Criar um objeto XMLHttpRequest
    var xhr = new XMLHttpRequest();

    // Configurar uma função para lidar com a resposta da requisição
    xhr.onreadystatechange = function() {
        // Verificar se a requisição foi concluída e a resposta está pronta
        if (xhr.readyState === XMLHttpRequest.DONE) {
            // Verificar se a resposta está OK (código 200)
            if (xhr.status === 200) {
                // Tratar a resposta recebida do servidor
                console.log("Resultado do cálculo:", xhr.responseText);
            } else {
                // Se ocorrer algum erro na requisição, exibir mensagem de erro
                console.error('Erro ao calcular:', xhr.status);
            }
        }
    };

    // Montar a URL com os parâmetros de consulta
    var url = "/calcular?valor1=" + encodeURIComponent(valor1) + "&valor2=" + encodeURIComponent(valor2);

    // Abrir uma requisição AJAX para a URL configurada, usando o método GET
    xhr.open("GET", url, true);

    // Enviar a requisição
    xhr.send();
}

