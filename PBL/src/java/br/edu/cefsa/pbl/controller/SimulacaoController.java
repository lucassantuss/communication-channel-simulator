package br.edu.cefsa.pbl.controller;

import br.edu.cefsa.pbl.model.Helper;
import br.edu.cefsa.pbl.model.GeradorSinais;
import br.edu.cefsa.pbl.model.SinalRecebido;
import br.edu.cefsa.pbl.model.SinalEntrada;
import br.edu.cefsa.pbl.model.SinalUtil;
import br.edu.cefsa.pbl.model.SinalSaida;
import br.edu.cefsa.pbl.model.DadosFormulario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet("/SimulacaoController")
public class SimulacaoController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Recebe os parâmetros do formulário
        DadosFormulario dadosFormulario = new DadosFormulario();
        dadosFormulario.setTipoSinal(request.getParameter("tipo_sinal"));
        dadosFormulario.setFrequencia(Integer.parseInt(request.getParameter("frequencia")));
        dadosFormulario.setTipoCanal(request.getParameter("tipo_canal"));

        if (dadosFormulario.getTipoCanal().equals("passa_baixas")) {
            dadosFormulario.setFrequenciaCorte0(Integer.parseInt(request.getParameter("frequencia_corte0")));
            dadosFormulario.setFrequenciaCorte1(0);
            dadosFormulario.setFrequenciaCorte2(0);
        } else if (dadosFormulario.getTipoCanal().equals("passa_faixas")) {
            dadosFormulario.setFrequenciaCorte1(Integer.parseInt(request.getParameter("frequencia_corte1")));
            dadosFormulario.setFrequenciaCorte2(Integer.parseInt(request.getParameter("frequencia_corte2")));
            dadosFormulario.setFrequenciaCorte0(0);
        }

        // Obtem a descrição do tipo de Sinal
        String descricaoTipoSinal = SinalUtil.descricaoTipoSinal(dadosFormulario.getTipoSinal());
        // Obtem a descrição do tipo de Canal
        String descricaoTipoCanal = SinalUtil.descricaoTipoCanal(dadosFormulario.getTipoCanal());
        // Define os atributos para passar para a página JSP
        request.setAttribute("dadosFormulario", dadosFormulario);
        request.setAttribute("descricaoTipoSinal", descricaoTipoSinal);
        request.setAttribute("descricaoTipoCanal", descricaoTipoCanal);

        // Gráfico - Sinal Emitido
        List<List<Double>> sinalEmitido = GeradorSinais.gerarSinalEmitido(
                dadosFormulario.getTipoSinal(),
                dadosFormulario.getFrequencia()
        );

        // Converte as listas de Double para arrays de double
        double[] tempoSinalEmitido = sinalEmitido.get(0).stream().mapToDouble(Double::doubleValue).toArray();
        double[] amplitudeSinalEmitido = sinalEmitido.get(1).stream().mapToDouble(Double::doubleValue).toArray();

        request.setAttribute("tempoSinalEmitido", tempoSinalEmitido);
        request.setAttribute("amplitudeSinalEmitido", amplitudeSinalEmitido);

        // Gráficos - Sinal de Entrada (Amplitude / Fase)
        List<List<Double>> sinalEntrada = GeradorSinais.gerarSinalEntrada(
                dadosFormulario.getTipoSinal()
        );

        // Converte as listas de Double para arrays de double
        double[] vetor_An = sinalEntrada.get(0).stream().mapToDouble(Double::doubleValue).toArray();
        double[] vetor_phi_n = sinalEntrada.get(1).stream().mapToDouble(Double::doubleValue).toArray();

        request.setAttribute("vetor_An", vetor_An);
        request.setAttribute("vetor_phi_n", vetor_phi_n);

        // Gráficos - Sinal de Resposta (Módulo / Fase)
        List<List<Double>> sinalResposta = GeradorSinais.gerarSinalResposta(
                dadosFormulario.getTipoCanal(),
                dadosFormulario.getFrequenciaCorte0(),
                dadosFormulario.getFrequenciaCorte1(),
                dadosFormulario.getFrequenciaCorte2()
        );

        // Converte as listas de Double para arrays de double
        double[] moduloResposta = sinalResposta.get(0).stream().mapToDouble(Double::doubleValue).toArray();
        double[] faseResposta = sinalResposta.get(1).stream().mapToDouble(Double::doubleValue).toArray();
        double[] frequenciaResposta = sinalResposta.get(2).stream().mapToDouble(Double::doubleValue).toArray();

        request.setAttribute("moduloResposta", moduloResposta);
        request.setAttribute("faseResposta", faseResposta);
        request.setAttribute("frequenciaResposta", frequenciaResposta);

        // Gráficos - Sinal de Saída (Amplitude / Fase)
        List<List<Double>> sinalSaida = GeradorSinais.gerarSinalSaida(
                dadosFormulario.getTipoCanal(),
                dadosFormulario.getTipoSinal(),
                dadosFormulario.getFrequencia(),
                dadosFormulario.getFrequenciaCorte0(),
                dadosFormulario.getFrequenciaCorte1(),
                dadosFormulario.getFrequenciaCorte2()
        );

        // Converte as listas de Double para arrays de double
        double[] vetor_An_sinal_de_saida = sinalSaida.get(0).stream().mapToDouble(Double::doubleValue).toArray();
        double[] vetor_phi_n_sinal_de_saida = sinalSaida.get(1).stream().mapToDouble(Double::doubleValue).toArray();

        request.setAttribute("vetor_An_sinal_de_saida", vetor_An_sinal_de_saida);
        request.setAttribute("vetor_phi_n_sinal_de_saida", vetor_phi_n_sinal_de_saida);

        // Obtem as amplitudes dos sinais de entrada e de saida
        double amplitudeSinalEntrada = SinalEntrada.amplitude(
                dadosFormulario.getTipoSinal()
        );

        double amplitudeSinalSaida = SinalSaida.amplitude(
                dadosFormulario.getTipoCanal(),
                dadosFormulario.getTipoSinal(),
                dadosFormulario.getFrequenciaCorte0(),
                dadosFormulario.getFrequenciaCorte1(),
                dadosFormulario.getFrequenciaCorte2()
        );

        request.setAttribute("amplitudeSinalEntrada", amplitudeSinalEntrada);
        request.setAttribute("amplitudeSinalSaida", amplitudeSinalSaida);

        // Obtem as frequencias dos sinais de entrada e de saida
        List<Integer> frequenciaSinalEntradaSaida = SinalUtil.frequenciaSinalEntradaSaida();

        request.setAttribute("frequenciaSinalEntradaSaida", frequenciaSinalEntradaSaida);

        // Obtem o tempo do sinal recebido
        List<Double> tempoSinalRecebido = SinalRecebido.tempo();

        // Serializa a lista para JSON
        String tempoSinalRecebidoJSON = Helper.serializeListToJson(tempoSinalRecebido);
        request.setAttribute("tempoSinalRecebidoJSON", tempoSinalRecebidoJSON);

        // Obtem a amplitude do sinal recebido
        double[] amplitudeSinalRecebido = SinalRecebido.amplitude(
                50,
                tempoSinalRecebido,
                dadosFormulario.getFrequencia(),
                amplitudeSinalSaida,
                vetor_An_sinal_de_saida,
                vetor_phi_n_sinal_de_saida
        );

        // Serializa o array para JSON
        String amplitudeSinalRecebidoJSON = Helper.serializeArrayToJson(amplitudeSinalRecebido);
        request.setAttribute("amplitudeSinalRecebidoJSON", amplitudeSinalRecebidoJSON);

        // Encaminha para a página JSP
        request.getRequestDispatcher("simulacao.jsp").forward(request, response);
    }
}
