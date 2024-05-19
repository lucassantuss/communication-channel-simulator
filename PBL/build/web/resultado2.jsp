<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Resultados da Simulação</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>
        <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    </head>
    <body>
        <header class="bg-dark text-light py-4">
            <div class="container">
                <h1 class="text-center">Resultados da Simulação</h1>
                <div class="text-right">
                    <a href="index.html" class="btn btn-secondary">Voltar à Página Inicial</a>
                </div>
            </div>
        </header>
        <main class="container mt-4">
            <canvas id="grafico"></canvas>
                <%
                    String tipoSinal = request.getParameter("tipo_sinal");
                    Integer frequencia = null;
                    if (request.getParameter("frequencia") != null && !request.getParameter("frequencia").isEmpty()) {
                        frequencia = Integer.parseInt(request.getParameter("frequencia"));
                    }
                    String tipoCanal = request.getParameter("tipo_canal");
                    Integer frequenciaCorte0 = null;
                    Integer frequenciaCorte1 = null;
                    Integer frequenciaCorte2 = null;
                    if (request.getParameter("frequencia_corte0") != null && !request.getParameter("frequencia_corte0").isEmpty()) {
                        frequenciaCorte0 = Integer.parseInt(request.getParameter("frequencia_corte0"));
                    }
                    if (request.getParameter("frequencia_corte1") != null && !request.getParameter("frequencia_corte1").isEmpty()) {
                        frequenciaCorte1 = Integer.parseInt(request.getParameter("frequencia_corte1"));
                    }
                    if (request.getParameter("frequencia_corte2") != null && !request.getParameter("frequencia_corte2").isEmpty()) {
                        frequenciaCorte2 = Integer.parseInt(request.getParameter("frequencia_corte2"));
                    }
                %>

            <div id="plot" style="width:100%;height:400px;"></div>

            <script>
                <% if (frequencia != null) { %>
                var frequenciaJS = <%= frequencia %>;

                // Definir os parâmetros
                const t_i = -3;
                const t_f = 3;
                const passo = 0.00001;
                const f0 = frequenciaJS;

                // Gerar os dados da onda quadrada
                const t = [];
                const x = [];
                for (let i = t_i; i <= t_f; i += passo) {
                    t.push(i);
                    const value = Math.sin(2 * Math.PI * f0 * i) >= 0 ? 1 : -1;
                    x.push(value);
                }

                // Dados para o Plotly - onda quadrada
                const trace = {
                    x: t,
                    y: x,
                    mode: 'lines',
                    type: 'scatter',
                    name: 'Onda Quadrada'
                };

                const data = [trace];

                const layout = {
                    title: 'Sinal emitido',
                    xaxis: {title: 'Tempo (s)'},
                    yaxis: {title: ''}
                };

                // Renderizar o gráfico de onda quadrada
                Plotly.newPlot('plot', data, layout);
                <% } else { %>
                // Caso a frequência não esteja definida, exibir uma mensagem de erro ou tomar outra ação
                console.error('Frequência não especificada.');
                <% } %>
            </script>
            <br><br><br>
        </main>
        <footer class="bg-dark text-light py-4">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 text-md-left text-center mb-3 mb-md-0">
                        <h5>Sobre Nós</h5>
                        <p>Alunos do EC7, responsáveis pela criação e implementação desse Simulador de Canal de Comunicação</p>
                    </div>
                    <div class="col-md-6 text-md-right text-center">
                        <h5>Desenvolvedores</h5>
                        <ul class="list-unstyled">
                            <li>Danilo Rodrigues Dantas</li>
                            <li>Lucas Araujo dos Santos</li>
                            <li>Maik Soares Luiz</li>
                            <li>Renan Cesar de Araujo</li>
                        </ul>
                    </div>
                </div>
            </div>
        </footer>
    </body>
</html>
