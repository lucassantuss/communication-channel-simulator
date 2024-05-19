<%-- 
    Document   : resultado
    Created on : 16 de mai. de 2024, 20:01:30
    Author     : 081210033
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Onda Quadrada com Plotly.js</title>
        <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    </head>
    <body>

        <% String tipoSinal = request.getParameter("tipo_sinal"); %>
        <% Integer frequencia = Integer.parseInt(request.getParameter("frequencia")); %>
        <% String tipoCanal = request.getParameter("tipo_canal"); %>
        <% Integer frequenciaCorte0 = Integer.parseInt(request.getParameter("frequencia_corte0")); %>
        <% //Integer frequenciaCorte1 = Integer.parseInt(request.getParameter("frequencia_corte1")); %>
        <% //Integer frequenciaCorte2 = Integer.parseInt(request.getParameter("frequencia_corte2")); %>

        <div id="plot" style="width:100%;height:400px;"></div>

        <script>
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

            // Dados para o Plotly
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

            // Renderizar o gráfico
            Plotly.newPlot('plot', data, layout);


        </script>



    </body>
</html>