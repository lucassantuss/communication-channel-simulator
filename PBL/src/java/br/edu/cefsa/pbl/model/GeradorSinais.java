package br.edu.cefsa.pbl.model;

import java.util.ArrayList;
import java.util.List;

public class GeradorSinais {

    public static List<List<Double>> gerarSinalEmitido(String tipoSinal, Integer frequencia) {

        List<Double> t1 = new ArrayList<>();
        List<Double> sinal = new ArrayList<>();

        double t_i = -3;
        double t_f = 3;
        double passo = 0.00001;
        Integer f0 = frequencia;
        double periodo = 1 / f0;

        for (double t = t_i; t <= t_f; t += passo) {
            t1.add(t);

            double valor = switch (tipoSinal) {
                case "quadrada" ->
                    SinalEmitido.ondaQuadrada(t, f0);
                case "triangular" ->
                    SinalEmitido.ondaTriangular(t, periodo);
                case "dente_serra" ->
                    SinalEmitido.ondaDenteSerra(t, periodo);
                case "senoidal_retificada" ->
                    SinalEmitido.ondaSenoidalRetificada(t, f0);
                default ->
                    0.0; // Valor padrão se o tipo de sinal não for reconhecido
            };

            sinal.add(valor);
        }

        List<List<Double>> resultado = new ArrayList<>();
        resultado.add(t1);
        resultado.add(sinal);

        return resultado;
    }

    public static List<List<Double>> gerarSinalEntrada(String tipoSinal) {

        int N = 50;
        double[] vetor_An = new double[N];
        double[] vetor_phi_n = new double[N];

        switch (tipoSinal) {
            case "quadrada" ->
                SinalEntrada.ondaQuadrada(N, vetor_An, vetor_phi_n);
            case "dente_serra" ->
                SinalEntrada.ondaDenteSerra(N, vetor_An, vetor_phi_n);
            case "triangular" ->
                SinalEntrada.ondaTriangular(N, vetor_An, vetor_phi_n);
            case "senoidal_retificada" ->
                SinalEntrada.ondaSenoidalRetificada(N, vetor_An, vetor_phi_n);
            default -> {
            }
        }

        List<List<Double>> resultado = new ArrayList<>();
        resultado.add(Helper.convertArrayToList(vetor_An));
        resultado.add(Helper.convertArrayToList(vetor_phi_n));

        return resultado;
    }

    public static List<List<Double>> gerarSinalResposta(
            String tipoCanal, Integer frequenciaCorte0,
            Integer frequenciaCorte1, Integer frequenciaCorte2) {

        List<List<Double>> resultado = new ArrayList<>();
        List<Double> modulo = new ArrayList<>();
        List<Double> fase = new ArrayList<>();
        List<Double> frequencias = new ArrayList<>();

        double f_final = 50;
        for (double i = 0; i < f_final; i += 0.001) {
            frequencias.add(i);
        }

        if (tipoCanal.equals("passa_baixas") && frequenciaCorte0 != null) {
            for (double freq : frequencias) {
                modulo.add(SinalResposta.moduloPassaBaixas(freq, frequenciaCorte0));
                fase.add((180 / Math.PI) * SinalResposta.fasePassaBaixas(freq, frequenciaCorte0));
            }
        } else if (tipoCanal.equals("passa_faixas") && frequenciaCorte1 != null && frequenciaCorte2 != null) {
            for (double freq : frequencias) {
                modulo.add(SinalResposta.moduloPassaFaixas(freq, frequenciaCorte1, frequenciaCorte2));
                fase.add((180 / Math.PI) * SinalResposta.fasePassaFaixas(freq, frequenciaCorte1, frequenciaCorte2));
            }
        }

        resultado.add(modulo);
        resultado.add(fase);
        resultado.add(frequencias);

        return resultado;
    }

    public static List<List<Double>> gerarSinalSaida(
            String tipoSinal, double f0,
            Integer frequenciaCorte0) {

        int N = 50;
        double[] vetor_An_sinal_de_saida = new double[N];
        double[] vetor_phi_n_sinal_de_saida = new double[N];

        switch (tipoSinal) {
            case "quadrada" ->
                SinalSaida.ondaQuadrada(N, frequenciaCorte0, f0, vetor_An_sinal_de_saida, vetor_phi_n_sinal_de_saida);
            case "dente_serra" ->
                SinalSaida.ondaDenteSerra(N, frequenciaCorte0, f0, vetor_An_sinal_de_saida, vetor_phi_n_sinal_de_saida);
            case "triangular" ->
                SinalSaida.ondaTriangular(N, frequenciaCorte0, f0, vetor_An_sinal_de_saida, vetor_phi_n_sinal_de_saida);
            case "senoidal_retificada" ->
                SinalSaida.ondaSenoidalRetificada(N, frequenciaCorte0, f0, vetor_An_sinal_de_saida, vetor_phi_n_sinal_de_saida);
            default -> {
            }
        }

        List<List<Double>> resultado = new ArrayList<>();
        resultado.add(Helper.convertArrayToList(vetor_An_sinal_de_saida));
        resultado.add(Helper.convertArrayToList(vetor_phi_n_sinal_de_saida));

        return resultado;
    }
}