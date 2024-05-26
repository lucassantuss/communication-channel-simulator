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
                const passo = 0.001;
                const f0 = frequenciaJS;
                const periodo = 1 / f0;

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
                const t = [];
                const sinal = [];
                for (let i = t_i; i <= t_f; i += passo) {
                    t.push(i);
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

                // Função para gerar o gráfico do sinal emitido
                function plotSinalEmitido() {
                    const trace = {
                        x: t,
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
                }

                // Função para calcular a Série de Fourier
                function serieFourier(sinal, t, N) {
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
                        fase.push(Math.atan2(bn, an));
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
                            text: 'Série de Fourier (Amplitude)',
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
                    const trace = {
                        x: fourier.f,
                        y: fourier.fase,
                        type: 'bar'
                    };
                    const layout = {
                        title: {
                            text: 'Série de Fourier (Fase)',
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
                }

                // Funções para as respostas dos canais de comunicação
                function respostaPassaBaixas(f, fc) {
                    return f.map(fi => fi <= fc ? 1 : 0);
                }

                function respostaPassaFaixas(f, fc1, fc2) {
                    return f.map(fi => (fi >= fc1 && fi <= fc2) ? 1 : 0);
                }

                // Calcular a resposta do canal
                let resposta;
                if (tipoCanal === 'passa_baixas' && frequenciaCorte0 != null) {
                    resposta = respostaPassaBaixas(fourier.f, frequenciaCorte0);
                } else if (tipoCanal === 'passa_faixas' && frequenciaCorte1 != null && frequenciaCorte2 != null) {
                    resposta = respostaPassaFaixas(fourier.f, frequenciaCorte1, frequenciaCorte2);
                }

                // Função para gerar o gráfico do módulo da resposta em frequência do canal
                function plotRespostaFrequenciaModulo() {
                    const trace = {
                        x: fourier.f,
                        y: resposta,
                        type: 'scatter'
                    };
                    const layout = {
                        title: {
                            text: 'Resposta em Frequência (Módulo)',
                            font: {
                                family: 'Arial, sans-serif',
                                size: 22,
                                color: '#000',
                                weight: 'bold'
                            }
                        },

                        xaxis: {title: 'Frequência (Hz)'},
                        yaxis: {title: 'Módulo'}
                    };
                    Plotly.newPlot('plot_resposta_frequencia_modulo', [trace], layout);
                }

                // Função para gerar o gráfico da fase da resposta em frequência do canal
                function plotRespostaFrequenciaFase() {
                    const faseResposta = resposta.map(v => Math.atan2(0, v)); // Aproximação simplificada
                    const trace = {
                        x: fourier.f,
                        y: faseResposta,
                        type: 'scatter'
                    };
                    const layout = {
                        title: {
                            text: 'Resposta em Frequência (Fase)',
                            font: {
                                family: 'Arial, sans-serif',
                                size: 22,
                                color: '#000',
                                weight: 'bold'
                            }
                        },

                        xaxis: {title: 'Frequência (Hz)'},
                        yaxis: {title: 'Fase (°)'}
                    };
                    Plotly.newPlot('plot_resposta_frequencia_fase', [trace], layout);
                }

                // Calcular a saída do canal
                const saidaAmplitude = fourier.A.map((a, i) => a * resposta[i]);
                const saidaFase = fourier.fase; // Supondo que a fase não muda

                // Função para gerar o gráfico da amplitude das componentes do sinal de saída
                function plotSaidaFourierAmplitude() {
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

                        xaxis: {title: 'Frequência (Hz)'},
                        yaxis: {title: 'Amplitude'}
                    };
                    Plotly.newPlot('plot_saida_fourier_amplitude', [trace], layout);
                }

                // Função para gerar o gráfico da fase das componentes do sinal de saída
                function plotSaidaFourierFase() {
                    const trace = {
                        x: fourier.f,
                        y: saidaFase,
                        type: 'bar'
                    };
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

                        xaxis: {title: 'Frequência (Hz)'},
                        yaxis: {title: 'Fase (radianos)'}
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
                        xaxis: {title: 'Tempo (s)'},
                        yaxis: {title: 'Amplitude'}
                    };
                    Plotly.newPlot('plot_sinal_recebido', [trace], layout);
                }

                // Chamar as funções para gerar os gráficos
                plotSinalEmitido();
                plotSerieFourierAmplitude();
                plotSerieFourierFase();
                plotRespostaFrequenciaModulo();
                plotRespostaFrequenciaFase();
                plotSaidaFourierAmplitude();
                plotSaidaFourierFase();
                plotSinalRecebido();

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