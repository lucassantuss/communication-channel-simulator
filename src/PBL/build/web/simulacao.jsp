<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.edu.cefsa.pbl.model.DadosFormulario" %>
<%@ page import="java.util.Arrays" %>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Resultados da Simulação</title>
        <link rel="icon" type="image/png" href="assets/images/logo.png">
        <link rel="stylesheet" href="assets/css/simulacao.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    </head>
    <body>
        <header class="bg-dark text-light py-4">
            <div class="container d-flex flex-column align-items-center justify-content-center position-relative"> <!-- Adicionando position-relative -->
                <div class="d-flex align-items-center mb-3">
                    <img src="assets/images/logo.png" alt="Logo" class="logo">
                    <h1 class="text-center m-0">Resultados da Simulação</h1>
                </div>
                <div class="position-absolute" style="bottom: 0rem; right: 1rem;">
                    <a href="index.html" class="btn btn-secondary">Voltar à Página Inicial</a>
                </div>
            </div>
        </header>
        <main class="container mt-4">
            <%
                // Recebendo os parâmetros do formulário
                String tipoSinal = request.getParameter("tipo_sinal");
                int frequencia = Integer.parseInt(request.getParameter("frequencia"));
                String tipoCanal = request.getParameter("tipo_canal");
                Integer frequenciaCorte0 = null;
                Integer frequenciaCorte1 = null;
                Integer frequenciaCorte2 = null;
                
                if (tipoCanal.equals("passa_baixas")) {
                    frequenciaCorte0 = Integer.parseInt(request.getParameter("frequencia_corte0"));
                } else if (tipoCanal.equals("passa_faixas")) {
                    frequenciaCorte1 = Integer.parseInt(request.getParameter("frequencia_corte1"));
                    frequenciaCorte2 = Integer.parseInt(request.getParameter("frequencia_corte2"));
                }

                // Criando um objeto DadosFormulario
                DadosFormulario dadosFormulario = new DadosFormulario(tipoSinal, frequencia, tipoCanal, frequenciaCorte0, frequenciaCorte1, frequenciaCorte2);
            %>
            <br>
            <div class="grafico-container">
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Tipo de Sinal:</strong> 
                            <%= request.getAttribute("descricaoTipoSinal") %>
                        </p>
                        <p><strong>Frequência Fundamental:</strong> <%= frequencia %> kHz</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Tipo de Canal:</strong>
                            <%= request.getAttribute("descricaoTipoCanal") %>
                        </p>
                        <% if (tipoCanal.equals("passa_baixas")) { %>
                        <p><strong>Frequência de Corte:</strong> <%= frequenciaCorte0 %> kHz</p>
                        <% } else if (tipoCanal.equals("passa_faixas")) { %>
                        <p><strong>Frequência de Corte Inferior:</strong> <%= frequenciaCorte1 %> kHz</p>
                        <p><strong>Frequência de Corte Superior:</strong> <%= frequenciaCorte2 %> kHz</p>
                        <% } %>
                    </div>
                </div>
            </div><br>

            <div class="grafico-container">
                <div id="grafico_sinal_emitido" style="width:100%;height:400px;"></div>
            </div>
            <div class="grafico-container">
                <div id="grafico_sinal_entrada_amplitude" style="width:100%;height:400px;"></div>
            </div>
            <div class="grafico-container">
                <div id="grafico_sinal_entrada_fase" style="width:100%;height:400px;"></div>
            </div>
            <div class="grafico-container">
                <div id="grafico_sinal_resposta_modulo" style="width:100%;height:400px;"></div>
            </div>
            <div class="grafico-container">
                <div id="grafico_sinal_resposta_fase" style="width:100%;height:400px;"></div>
            </div>
            <div class="grafico-container">
                <div id="grafico_sinal_saida_amplitude" style="width:100%;height:400px;"></div>
            </div>
            <div class="grafico-container">
                <div id="grafico_sinal_saida_fase" style="width:100%;height:400px;"></div>
            </div>
            <div class="grafico-container">
                <div id="grafico_sinal_recebido" style="width:100%;height:400px;"></div>
            </div>
            <br><br>
            <script>
                <% if (dadosFormulario.getFrequencia() != 0) { %>
                // Gráfico - Sinal Emitido
                function GraficoSinalEmitido() {
                    var tempoSinalEmitido = <%= Arrays.toString((double[])request.getAttribute("tempoSinalEmitido")) %>;
                    var amplitudeSinalEmitido = <%= Arrays.toString((double[])request.getAttribute("amplitudeSinalEmitido")) %>;

                    const traceSinalEmitido = {
                        x: tempoSinalEmitido,
                        y: amplitudeSinalEmitido,
                        type: 'scatter',
                        line: {color: '#007bff'}
                    };
                    const layoutSinalEmitido = {
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

                    Plotly.newPlot('grafico_sinal_emitido', [traceSinalEmitido], layoutSinalEmitido);
                }
                GraficoSinalEmitido();

                // Gráfico - Sinal de Entrada (Amplitude / Fase)
                function GraficoSinalEntrada() {
                    var a0 = <%= request.getAttribute("amplitudeSinalEntrada") %>;
                    var vetor_An = <%= Arrays.toString((double[])request.getAttribute("vetor_An")) %>;
                    var vetor_phi_n = <%= Arrays.toString((double[])request.getAttribute("vetor_phi_n")) %>;
                    var frequenciaSinalEntrada = ${frequenciaSinalEntradaSaida};

                    let traceSinalEntradaAmplitude = {
                        x: frequenciaSinalEntrada,
                        y: [a0, ...vetor_An],
                        type: 'bar',
                        mode: 'lines+markers',
                        marker: {color: '#007bff'}
                    };
                    let layoutSinalEntradaAmplitude = {
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
                        yaxis: {title: 'Amplitude'},
                        showlegend: false
                    };

                    let traceSinalEntradaFase = {
                        x: frequenciaSinalEntrada,
                        y: [0, ...vetor_phi_n.map(phi => (180 / Math.PI) * phi)],
                        type: 'bar',
                        mode: 'lines+markers',
                        marker: {color: '#007bff'}
                    };
                    let layoutSinalEntradaFase = {
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
                        yaxis: {title: 'Fase (°)'},
                        showlegend: false
                    };

                    Plotly.newPlot('grafico_sinal_entrada_amplitude', [traceSinalEntradaAmplitude], layoutSinalEntradaAmplitude);
                    Plotly.newPlot('grafico_sinal_entrada_fase', [traceSinalEntradaFase], layoutSinalEntradaFase);
                }
                GraficoSinalEntrada();


                // Gráfico - Sinal de Resposta (Módulo / Fase)
                function GraficoSinalResposta() {
                    var moduloResposta = <%= Arrays.toString((double[])request.getAttribute("moduloResposta")) %>;
                    var faseResposta = <%= Arrays.toString((double[])request.getAttribute("faseResposta")) %>;
                    var frequenciaResposta = <%= Arrays.toString((double[])request.getAttribute("frequenciaResposta")) %>;

                    let traceSinalRespostaModulo = {
                        x: frequenciaResposta,
                        y: moduloResposta,
                        mode: 'lines',
                        name: 'Módulo da Resposta em Frequência',
                        line: {color: '#007bff'}
                    };
                    let layoutSinalRespostaModulo = {
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
                        yaxis: {title: 'Módulo'},
                        autosize: true,
                        grid: true
                    };

                    let traceSinalRespostaFase = {
                        x: frequenciaResposta,
                        y: faseResposta,
                        mode: 'lines',
                        name: 'Fase da Resposta em Frequência',
                        line: {color: '#007bff'}
                    };
                    let layoutSinalRespostaFase = {
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
                        yaxis: {title: 'Fase (°)'},
                        autosize: true,
                        grid: true
                    };

                    Plotly.newPlot('grafico_sinal_resposta_modulo', [traceSinalRespostaModulo], layoutSinalRespostaModulo);
                    Plotly.newPlot('grafico_sinal_resposta_fase', [traceSinalRespostaFase], layoutSinalRespostaFase);
                }
                GraficoSinalResposta();


                // Gráfico - Sinal de Saída (Amplitude / Fase)
                function GraficoSinalSaida() {
                    var vetor_An_sinal_de_saida = <%= Arrays.toString((double[])request.getAttribute("vetor_An_sinal_de_saida")) %>;
                    var vetor_phi_n_sinal_de_saida = <%= Arrays.toString((double[])request.getAttribute("vetor_phi_n_sinal_de_saida")) %>;
                    var a0_saida = <%= request.getAttribute("amplitudeSinalSaida") %>;
                    var frequenciaSinalSaida = ${frequenciaSinalEntradaSaida};

                    let traceSinalSaidaAmplitude = {
                        x: frequenciaSinalSaida,
                        y: [a0_saida, ...vetor_An_sinal_de_saida],
                        type: 'bar',
                        mode: 'lines+markers',
                        name: 'Sinal de Saída (Amplitude)',
                        marker: {color: '#007bff'}
                    };
                    let layoutSinalSaidaAmplitude = {
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
                        yaxis: {title: 'Amplitude'},
                        grid: true
                    };

                    let traceSinalSaidaFase = {
                        x: frequenciaSinalSaida,
                        y: [0, ...vetor_phi_n_sinal_de_saida.map(phi => (180 / Math.PI) * phi)],
                        type: 'bar',
                        mode: 'lines+markers',
                        name: 'Sinal de Saída (Fase)',
                        marker: {color: '#007bff'}
                    };
                    let layoutSinalSaidaFase = {
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
                        yaxis: {title: 'Fase (°)'},
                        grid: true
                    };

                    Plotly.newPlot('grafico_sinal_saida_amplitude', [traceSinalSaidaAmplitude], layoutSinalSaidaAmplitude);
                    Plotly.newPlot('grafico_sinal_saida_fase', [traceSinalSaidaFase], layoutSinalSaidaFase);
                }
                GraficoSinalSaida();


                // Gráfico - Sinal Recebido
                function GraficoSinalRecebido() {
                    var tempoSinalRecebido = JSON.parse("${tempoSinalRecebidoJSON}");
                    var amplitudeSinalRecebido = JSON.parse("${amplitudeSinalRecebidoJSON}");

                    let traceSinalRecebido = {
                        x: tempoSinalRecebido,
                        y: amplitudeSinalRecebido,
                        mode: 'lines',
                        name: 'Sinal Recebido',
                        line: {color: 'red'}
                    };
                    let layoutSinalRecebido = {
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
                        yaxis: {title: 'Amplitude'},
                        grid: true
                    };

                    Plotly.newPlot('grafico_sinal_recebido', [traceSinalRecebido], layoutSinalRecebido);
                }
                GraficoSinalRecebido();
                <% } %>
            </script>
        </main>
        <footer class="bg-dark text-light py-4">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 text-md-left text-center mb-3 mb-md-0">
                        <h5>Sobre Nós</h5>
                        <p>Somos alunos do curso de Engenharia de Computação (EC7), da Faculdade Engenheiro Salvador Arena (FESA), e ficamos responsáveis pela criação e implementação desse Simulador de Canal de Comunicação</p>
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