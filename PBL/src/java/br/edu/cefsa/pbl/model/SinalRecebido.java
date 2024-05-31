package br.edu.cefsa.pbl.model;

import java.util.ArrayList;
import java.util.List;

public class SinalRecebido {

    public static List<Double> tempo() {
        List<Double> tempo = new ArrayList<>();
        double tempoInicial = -3;
        double tempoFinal = 3;
        double passo = 0.00001;

        for (double i = tempoInicial; i < tempoFinal; i += passo) {
            tempo.add(-i);
        }

        return tempo;
    }

    public static double[] amplitude(
            Integer N,
            List<Double> t,
            Integer f0,
            double a0_saida,
            double[] vetor_An_sinal_de_saida,
            double[] vetor_phi_n_sinal_de_saida
    ){
        double[] amplitude = new double[t.size()];
        for (int i = 0; i < amplitude.length; i++) {
            amplitude[i] = a0_saida;
        }

        for (int n = 1; n <= N; n++) {
            for (int i = 0; i < t.size(); i++) {
                amplitude[i] += vetor_An_sinal_de_saida[n - 1] * Math.cos(2 * Math.PI * n * f0 * t.get(i) + vetor_phi_n_sinal_de_saida[n - 1]);
            }
        }

        return amplitude;
    }
}