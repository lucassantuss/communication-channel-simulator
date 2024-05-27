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

            <br>
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Tipo de Sinal:</strong> 
                        <%
                            String tipoSinalDescricao = "";
                            if (tipoSinal.equals("quadrada")) {
                                tipoSinalDescricao = "Onda Quadrada";
                            } else if (tipoSinal.equals("triangular")) {
                                tipoSinalDescricao = "Onda Triangular";
                            } else if (tipoSinal.equals("dente_serra")) {
                                tipoSinalDescricao = "Onda Dente-de-Serra";
                            } else if (tipoSinal.equals("senoidal_retificada")) {
                                tipoSinalDescricao = "Onda Senoidal Retificada";
                            }
                        %>
                        <%= tipoSinalDescricao %>
                    </p>
                    <p><strong>Frequência Fundamental:</strong> <%= frequencia %> kHz</p>
                </div>
                <div class="col-md-6">
                    <p><strong>Tipo de Canal:</strong> 
                        <%
                            String tipoCanalDescricao = "";
                            if (tipoCanal.equals("passa_baixas")) {
                                tipoCanalDescricao = "Canal Passa-Baixas";
                            } else if (tipoCanal.equals("passa_faixas")) {
                                tipoCanalDescricao = "Canal Passa-Faixas";
                            }
                        %>
                        <%= tipoCanalDescricao %>
                    </p>
                    <% if (tipoCanal.equals("passa_baixas")) { %>
                    <p><strong>Frequência de Corte:</strong> <%= frequenciaCorte0 %> kHz</p>
                    <% } else if (tipoCanal.equals("passa_faixas")) { %>
                    <p><strong>Frequência de Corte Inferior:</strong> <%= frequenciaCorte1 %> kHz</p>
                    <p><strong>Frequência de Corte Superior:</strong> <%= frequenciaCorte2 %> kHz</p>
                    <% } %>
                </div>
            </div><br>

            <div id="plot_sinal_emitido" style="width:100%;height:400px;"></div><br>
            <div id="plot_serie_fourier_amplitude" style="width:100%;height:400px;"></div><br>
            <div id="plot_serie_fourier_fase" style="width:100%;height:400px;"></div><br>
            <div id="plot_resposta_frequencia_modulo" style="width:100%;height:400px;"></div><br>
            <div id="plot_resposta_frequencia_fase" style="width:100%;height:400px;"></div><br>
            <div id="plot_saida_fourier_amplitude" style="width:100%;height:400px;"></div><br>
            <div id="plot_saida_fourier_fase" style="width:100%;height:400px;"></div><br>
            <div id="plot_sinal_recebido" style="width:100%;height:400px;"></div>
            <br><br><br>
            <script>
                <% if (frequencia != null) { %>
                var tipoSinal = "<%= tipoSinal %>";
                var frequenciaJS = <%= frequencia %>;
                var tipoCanal = "<%= tipoCanal %>";
                var frequenciaCorte0 = <%= frequenciaCorte0 != null ? frequenciaCorte0 : "null" %>;
                var frequenciaCorte1 = <%= frequenciaCorte1 != null ? frequenciaCorte1 : "null" %>;
                var frequenciaCorte2 = <%= frequenciaCorte2 != null ? frequenciaCorte2 : "null" %>;

                // Parâmetros gerais
                const t_i = -3;
                const t_f = 3;
                const passo = 0.00001;
                const f0 = frequenciaJS;
                const periodo = 1 / f0;

                let t = [];
                for (let i = t_i; i < t_f; i += passo) {
                    t.push(-i);
                }

                // Funções para gerar os sinais
                function ondaQuadrada(t, f0) {
                    return Math.sin(2 * Math.PI * f0 * t) >= 0 ? 1 : -1;
                }

                function ondaTriangular(t, periodo) {
                    const t_mod = t % periodo;
                    if (t_mod < periodo / 4) {
                        return 4 * t_mod / periodo;
                    } else if (t_mod < 3 * periodo / 4) {
                        return 2 - 4 * t_mod / periodo;
                    } else {
                        return -4 + 4 * t_mod / periodo;
                    }
                }

                function ondaDenteSerra(t, periodo) {
                    return 2 * (t / periodo - Math.floor(0.5 + t / periodo));
                }

                function ondaSenoidalRetificada(t, f0) {
                    return Math.abs(Math.sin(2 * Math.PI * f0 * t));
                }

                // Gerar dados do sinal de entrada
                const t1 = [];
                const sinal = [];
                for (let i = t_i; i <= t_f; i += passo) {
                    t1.push(i);
                    let valor;
                    if (tipoSinal === 'quadrada') {
                        valor = ondaQuadrada(i, f0);
                    } else if (tipoSinal === 'triangular') {
                        valor = ondaTriangular(i, periodo);
                    } else if (tipoSinal === 'dente_serra') {
                        valor = ondaDenteSerra(i, periodo);
                    } else if (tipoSinal === 'senoidal_retificada') {
                        valor = ondaSenoidalRetificada(i, f0);
                    }
                    sinal.push(valor);
                }

                const trace = {
                    x: t1,
                    y: sinal,
                    type: 'scatter'
                };
                const layout = {
                    title: {
                        text: 'Sinal Emitido',
                        font: {
                            family: 'Arial, sans-serif',
                            size: 22,
                            color: '#000',
                            weight: 'bold'
                        }
                    },
                    xaxis: {title: 'Tempo (ms)'},
                    yaxis: {title: 'Amplitude'}
                };
                Plotly.newPlot('plot_sinal_emitido', [trace], layout);
                // Função para gerar o gráfico do sinal emitido
                /*function plotSinalEmitido() {
                 const trace = {
                 x: t1,
                 y: sinal,
                 type: 'scatter'
                 };
                 const layout = {
                 title: {
                 text: 'Sinal Emitido',
                 font: {
                 family: 'Arial, sans-serif',
                 size: 22,
                 color: '#000',
                 weight: 'bold'
                 }
                 },
                 xaxis: {title: 'Tempo (ms)'},
                 yaxis: {title: 'Amplitude'}
                 };
                 Plotly.newPlot('plot_sinal_emitido', [trace], layout);
                 }*/


                let f_final = 50;
                let f = [];
                for (let i = 0; i < f_final; i += 0.001) {
                    f.push(i);
                }

                let x_fourier = Array(t.length).fill(0);

                let a0 = 0;
                let N = 50;

                let vetor_An = Array(N).fill(0);
                let vetor_phi_n = Array(N).fill(0);

                for (let n = 1; n <= N; n++) {
                    if (n % 2 === 0) {
                        An = 0;
                        phi_n = 0;
                    } else {
                        An = 4 / (Math.PI * n);
                        phi_n = -Math.PI / 2;
                    }
                    vetor_An[n - 1] = An;
                    vetor_phi_n[n - 1] = phi_n;

                    for (let i = 0; i < t.length; i++) {
                        x_fourier[i] += An * Math.cos(2 * Math.PI * n * f0 * t[i] + phi_n);
                    }
                }

                let f1 = [];
                for (let i = 0; i <= f_final; i++) {
                    f1.push(i);
                }

                let amplitudeTrace = {
                    x: f1,
                    y: [a0, ...vetor_An],
                    type: 'bar',
                    mode: 'lines+markers',
                    marker: {color: 'blue'}
                };

                let phaseTrace = {
                    x: f1,
                    y: [0, ...vetor_phi_n.map(phi => (180 / Math.PI) * phi)],
                    type: 'bar',
                    mode: 'lines+markers',
                    marker: {color: 'blue'}
                };

                let layoutAmplitude = {
                    title: 'Amplitude',
                    xaxis: {title: 'f (Hz)'},
                    yaxis: {title: 'Amplitude'},
                    showlegend: false
                };

                let layoutPhase = {
                    title: 'Fase (°)',
                    xaxis: {title: 'f (Hz)'},
                    yaxis: {title: 'Fase (°)'},
                    showlegend: false
                };

                Plotly.newPlot('plot_serie_fourier_amplitude', [amplitudeTrace], layoutAmplitude);
                Plotly.newPlot('plot_serie_fourier_fase', [phaseTrace], layoutPhase);

                function modulo_resposta_em_frequencia(f, f_c) {
                    return 1 / Math.sqrt(1 + Math.pow(f / f_c, 2));
                }

                function fase_resposta_em_frequencia(f, f_c) {
                    return Math.atan(-f / f_c);
                }

                let modulo = f.map(freq => modulo_resposta_em_frequencia(freq, frequenciaCorte0));
                let fase = f.map(freq => (180 / Math.PI) * fase_resposta_em_frequencia(freq, frequenciaCorte0));

                let trace1 = {
                    x: f,
                    y: modulo,
                    mode: 'lines',
                    name: 'Modulo da Resposta em Frequência',
                    line: {color: 'blue'}
                };

                let trace2 = {
                    x: f,
                    y: fase,
                    mode: 'lines',
                    name: 'Fase da Resposta em Frequência',
                    line: {color: 'blue'}
                };

                let layout1 = {
                    title: 'Modulo da Resposta em Frequência',
                    xaxis: {title: 'f'},
                    yaxis: {title: 'Modulo'},
                    autosize: true,
                    grid: true
                };

                let layout2 = {
                    title: 'Fase da Resposta em Frequência',
                    xaxis: {title: 'f'},
                    yaxis: {title: 'Fase (graus)'},
                    autosize: true,
                    grid: true
                };

                // Plot the graphs
                Plotly.newPlot('plot_resposta_frequencia_modulo', [trace1], layout1);
                Plotly.newPlot('plot_resposta_frequencia_fase', [trace2], layout2);

                let fc1 = 2;
                // Calculate the amplitude and phase of each harmonic that makes up the output signal
                let a0_saida = a0 * modulo_resposta_em_frequencia(0, fc1);
                let vetor_An_sinal_de_saida = new Array(N).fill(0);
                let vetor_phi_n_sinal_de_saida = new Array(N).fill(0);

                for (let n = 1; n <= N; n++) {
                    if (n % 2 === 0) {
                        vetor_An_sinal_de_saida[n - 1] = 0;
                        vetor_phi_n_sinal_de_saida[n - 1] = 0;
                    } else {
                        let An_entrada = 4 / (Math.PI * n);
                        let phi_n_entrada = -Math.PI / 2;
                        vetor_phi_n_sinal_de_saida[n - 1] = phi_n_entrada + fase_resposta_em_frequencia(n * f0, fc1);
                        vetor_An_sinal_de_saida[n - 1] = An_entrada * modulo_resposta_em_frequencia(n * f0, fc1);
                    }
                }

                //let f1 = Array.from({length: f_final + 1}, (_, i) => i);

                // Create the plots for amplitude and phase
                let amplitudeTraceSaida = {
                    x: f1,
                    y: [a0_saida, ...vetor_An_sinal_de_saida],
                    type: 'bar',
                    mode: 'lines+markers',
                    name: 'Amplitude',
                    marker: {color: 'blue'}
                };

                let PhaseTraceSaida = {
                    x: f1,
                    y: [0, ...vetor_phi_n_sinal_de_saida.map(phi => (180 / Math.PI) * phi)],
                    type: 'bar',
                    mode: 'lines+markers',
                    name: 'Fase',
                    marker: {color: 'blue'}
                };

                let layoutAmplitudeSaida = {
                    title: 'Amplitude',
                    xaxis: {title: 'f (Hz)'},
                    yaxis: {title: 'Amplitude'},
                    grid: true
                };

                let layoutFaseSaida = {
                    title: 'Fase',
                    xaxis: {title: 'f (Hz)'},
                    yaxis: {title: 'Fase (°)'},
                    grid: true
                };

                // Plot the graphs
                Plotly.newPlot('plot_saida_fourier_amplitude', [amplitudeTraceSaida], layoutAmplitudeSaida);
                Plotly.newPlot('plot_saida_fourier_fase', [PhaseTraceSaida], layoutFaseSaida);

                let y1 = new Array(t.length).fill(a0_saida);

                for (let n = 1; n <= N; n++) {
                    for (let i = 0; i < t.length; i++) {
                        y1[i] += vetor_An_sinal_de_saida[n - 1] * Math.cos(2 * Math.PI * n * f0 * t[i] + vetor_phi_n_sinal_de_saida[n - 1]);
                    }
                }

                // Create the plot
                let traceRecebido = {
                    x: t,
                    y: y1,
                    mode: 'lines',
                    name: 'Recebido',
                    line: {color: 'red'}
                };

                let layoutRecebido = {
                    title: 'Entrada e Saída do Canal',
                    xaxis: {title: 't (s)'},
                    yaxis: {title: 'Amplitude'},
                    grid: true
                };

                // Plot the graph
                Plotly.newPlot('plot_sinal_recebido', [traceRecebido], layoutRecebido);

                // Função para calcular a Série de Fourier
                /*function serieFourier(sinal, t, N) {
                 const dt = t[1] - t[0];
                 const T = t[t.length - 1] - t[0];
                 const f = [];
                 const A = [];
                 const fase = [];
                 for (let n = 0; n < N; n++) {
                 let an = 0;
                 let bn = 0;
                 for (let i = 0; i < t.length; i++) {
                 an += sinal[i] * Math.cos(2 * Math.PI * n * t[i] / T) * dt;
                 bn += sinal[i] * Math.sin(2 * Math.PI * n * t[i] / T) * dt;
                 }
                 an = (2 / T) * an;
                 bn = (2 / T) * bn;
                 f.push(n / T);
                 A.push(Math.sqrt(an * an + bn * bn));
                 fase.push((180 / Math.PI) * Math.atan2(bn, an));
                 }
                 return {f, A, fase};
                 }
                 
                 // Calcular a Série de Fourier do sinal emitido
                 const N = 305; // Número de harmônicos
                 const fourier = serieFourier(sinal, t, N);
                 
                 // Função para gerar o gráfico da Série de Fourier (Amplitude)
                 function plotSerieFourierAmplitude() {
                 const trace = {
                 x: fourier.f,
                 y: fourier.A,
                 type: 'bar'
                 };
                 const layout = {
                 title: {
                 text: 'Sinal de Entrada (Amplitude)',
                 font: {
                 family: 'Arial, sans-serif',
                 size: 22,
                 color: '#000',
                 weight: 'bold'
                 }
                 },
                 xaxis: {title: 'Frequência (kHz)'},
                 yaxis: {title: 'Amplitude'}
                 };
                 Plotly.newPlot('plot_serie_fourier_amplitude', [trace], layout);
                 }
                 
                 // Função para gerar o gráfico da Série de Fourier (Fase)
                 function plotSerieFourierFase() {
                 // Filtrar os valores de fase negativa
                 const f_negativo = [];
                 const fase_negativa = [];
                 for (let i = 0; i < fourier.f.length; i++) {
                 if (fourier.f[i] <= 50 && fourier.fase[i] < 0) { // Considerando apenas frequências até 50 kHz e fase negativa
                 f_negativo.push(fourier.f[i]);
                 fase_negativa.push(fourier.fase[i]);
                 }
                 }
                 
                 const trace = {
                 x: f_negativo,
                 y: fase_negativa,
                 type: 'bar'
                 };
                 const layout = {
                 title: {
                 text: 'Sinal de Entrada (Fase)',
                 font: {
                 family: 'Arial, sans-serif',
                 size: 22,
                 color: '#000',
                 weight: 'bold'
                 }
                 },
                 xaxis: {title: 'Frequência (kHz)'},
                 yaxis: {title: 'Fase (°)'}
                 };
                 Plotly.newPlot('plot_serie_fourier_fase', [trace], layout);
                 }*/



                // Funções para as respostas dos canais de comunicação
                /*function respostaModuloPassaBaixas(frequencias, fc) {
                 return frequencias.map(f => 1 / Math.sqrt(1 + Math.pow(f / fc, 2)));
                 }
                 
                 function respostaFasePassaBaixas(frequencias, fc) {
                 return frequencias.map(f => Math.atan(-f / fc) * (180 / Math.PI));
                 }
                 
                 function respostaModuloPassaFaixas(frequencias, f1, f2) {
                 return frequencias.map(f => (1 / (f2 - f1)) * (1 / (1 + Math.pow(f / f1, 2))) * (1 / (1 + Math.pow(f / f2, 2))));
                 }
                 
                 function respostaFasePassaFaixas(frequencias, f1, f2) {
                 return frequencias.map(f => (-90 - Math.atan((f * (f1 + f2)) / (f1 * f2 - Math.pow(f, 2)))) * (180 / Math.PI));
                 }
                 
                 // Calcular a resposta do modulo e fase do canal
                 let respostaModulo;
                 let respostaFase;
                 if (tipoCanal === 'passa_baixas' && frequenciaCorte0 != null) {
                 respostaModulo = respostaModuloPassaBaixas(fourier.f, frequenciaCorte0);
                 respostaFase = respostaFasePassaBaixas(fourier.f, frequenciaCorte0);
                 } else if (tipoCanal === 'passa_faixas' && frequenciaCorte1 != null && frequenciaCorte2 != null) {
                 respostaModulo = respostaModuloPassaFaixas(fourier.f, frequenciaCorte1, frequenciaCorte2);
                 respostaFase = respostaFasePassaFaixas(fourier.f, frequenciaCorte1, frequenciaCorte2);
                 }
                 
                 // Função para gerar o gráfico do módulo da resposta em frequência do canal
                 const trace = {
                 x: fourier.f,
                 y: respostaModulo,
                 type: 'scatter'
                 };
                 const layout = {
                 title: {
                 text: 'Módulo da Resposta em Frequência',
                 font: {
                 family: 'Arial, sans-serif',
                 size: 22,
                 color: '#000',
                 weight: 'bold'
                 }
                 },
                 
                 xaxis: {title: 'Frequência (kHz)'},
                 yaxis: {title: 'Módulo'}
                 };
                 Plotly.newPlot('plot_resposta_frequencia_modulo', [trace], layout);
                 /*function plotRespostaFrequenciaModulo() {
                 const trace = {
                 x: fourier.f,
                 y: respostaModulo,
                 type: 'scatter'
                 };
                 const layout = {
                 title: {
                 text: 'Módulo da Resposta em Frequência',
                 font: {
                 family: 'Arial, sans-serif',
                 size: 22,
                 color: '#000',
                 weight: 'bold'
                 }
                 },
                 
                 xaxis: {title: 'Frequência (kHz)'},
                 yaxis: {title: 'Módulo'}
                 };
                 Plotly.newPlot('plot_resposta_frequencia_modulo', [trace], layout);
                 }*/

                // Função para gerar o gráfico da fase da resposta em frequência do canal
                /*const trace = {
                 x: fourier.f,
                 y: respostaFase,
                 type: 'scatter'
                 };
                 const layout = {
                 title: {
                 text: 'Fase da Resposta em Frequência',
                 font: {
                 family: 'Arial, sans-serif',
                 size: 22,
                 color: '#000',
                 weight: 'bold'
                 }
                 },
                 
                 xaxis: {title: 'Frequência (kHz)'},
                 yaxis: {title: 'Fase (°)'}
                 };
                 Plotly.newPlot('plot_resposta_frequencia_fase', [trace], layout);
                 /*function plotRespostaFrequenciaFase() {
                 const trace = {
                 x: fourier.f,
                 y: respostaFase,
                 type: 'scatter'
                 };
                 const layout = {
                 title: {
                 text: 'Fase da Resposta em Frequência',
                 font: {
                 family: 'Arial, sans-serif',
                 size: 22,
                 color: '#000',
                 weight: 'bold'
                 }
                 },
                 
                 xaxis: {title: 'Frequência (kHz)'},
                 yaxis: {title: 'Fase (°)'}
                 };
                 Plotly.newPlot('plot_resposta_frequencia_fase', [trace], layout);
                 }*/

                // Calcular a saída do canal
                /* const saidaAmplitude = fourier.A.map((a, i) => a * respostaModulo[i]);
                 const saidaFase = fourier.fase; // Supondo que a fase não muda
                 
                 // Função para gerar o gráfico da amplitude das componentes do sinal de saída
                 /*function plotSaidaFourierAmplitude() {
                 const trace = {
                 x: fourier.f,
                 y: saidaAmplitude,
                 type: 'bar'
                 };
                 const layout = {
                 title: {
                 text: 'Sinal de Saída (Amplitude)',
                 font: {
                 family: 'Arial, sans-serif',
                 size: 22,
                 color: '#000',
                 weight: 'bold'
                 }
                 },
                 
                 xaxis: {title: 'Frequência (kHz)'},
                 yaxis: {title: 'Amplitude'}
                 };
                 Plotly.newPlot('plot_saida_fourier_amplitude', [trace], layout);
                 }
                 
                 // Função para gerar o gráfico da fase das componentes do sinal de saída
                 function plotSaidaFourierFase() {
                 // Filtrar os valores de fase negativa
                 const f_negativo = [];
                 const fase_negativa = [];
                 for (let i = 0; i < fourier.f.length; i++) {
                 if (fourier.f[i] <= 50 && fourier.fase[i] < 0) { // Considerando apenas frequências até 50 kHz e fase negativa
                 f_negativo.push(fourier.f[i]);
                 fase_negativa.push(fourier.fase[i]);
                 }
                 }
                 
                 const trace = {
                 x: f_negativo,
                 y: fase_negativa,
                 type: 'bar'
                 };
                 
                 //const trace = {
                 //   x: fourier.f,
                 //   y: saidaFase,
                 //    type: 'bar'
                 //};
                 const layout = {
                 title: {
                 text: 'Sinal de Saída (Fase)',
                 font: {
                 family: 'Arial, sans-serif',
                 size: 22,
                 color: '#000',
                 weight: 'bold'
                 }
                 },
                 
                 xaxis: {title: 'Frequência (kHz)'},
                 yaxis: {title: 'Fase (°)'}
                 };
                 Plotly.newPlot('plot_saida_fourier_fase', [trace], layout);
                 }
                 
                 // Reconstruir o sinal de saída
                 function reconstruirSinalSaida(fourier, t, saidaAmplitude, saidaFase) {
                 const T = t[t.length - 1] - t[0];
                 const sinalSaida = [];
                 for (let i = 0; i < t.length; i++) {
                 let valor = 0;
                 for (let n = 0; n < saidaAmplitude.length; n++) {
                 valor += saidaAmplitude[n] * Math.cos(2 * Math.PI * fourier.f[n] * t[i] + saidaFase[n]);
                 }
                 sinalSaida.push(valor);
                 }
                 return sinalSaida;
                 }
                 
                 const sinalSaida = reconstruirSinalSaida(fourier, t, saidaAmplitude, saidaFase);
                 
                 // Função para gerar o gráfico do sinal recebido
                 function plotSinalRecebido() {
                 const trace = {
                 x: t,
                 y: sinalSaida,
                 type: 'scatter'
                 };
                 const layout = {
                 title: {
                 text: 'Sinal Recebido',
                 font: {
                 family: 'Arial, sans-serif',
                 size: 22,
                 color: '#000',
                 weight: 'bold'
                 }
                 },
                 xaxis: {title: 'Tempo (ms)'},
                 yaxis: {title: 'Amplitude'}
                 };
                 Plotly.newPlot('plot_sinal_recebido', [trace], layout);
                 }
                 
                 // Chamar as funções para gerar os gráficos
                 plotSinalEmitido();
                 /*plotSerieFourierAmplitude();
                 plotSerieFourierFase();
                 plotRespostaFrequenciaModulo();
                 plotRespostaFrequenciaFase();
                 plotSaidaFourierAmplitude();
                 plotSaidaFourierFase();
                 plotSinalRecebido();*/

                <% } %>
            </script>
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