package br.edu.cefsa.pbl.model;

public class SinalSaida {

    public static void ondaQuadrada(int N, double f0, String tipoCanal,
            double frequenciaCorte0, double frequenciaCorte1, double frequenciaCorte2,
            double[] vetor_An_sinal_de_saida, double[] vetor_phi_n_sinal_de_saida) {

        for (int n = 1; n <= N; n++) {
            if (n % 2 == 0) {
                vetor_An_sinal_de_saida[n - 1] = 0;
                vetor_phi_n_sinal_de_saida[n - 1] = 0;
            } else {
                double An_entrada = 4 / (Math.PI * n);
                double phi_n_entrada = -Math.PI / 2;

                if (tipoCanal.equals("passa_baixas")) {
                    vetor_phi_n_sinal_de_saida[n - 1] = phi_n_entrada + SinalResposta.fasePassaBaixas(n * f0, frequenciaCorte0);
                    vetor_An_sinal_de_saida[n - 1] = An_entrada * SinalResposta.moduloPassaBaixas(n * f0, frequenciaCorte0);
                } else if (tipoCanal.equals("passa_faixas")) {
                    vetor_phi_n_sinal_de_saida[n - 1] = phi_n_entrada + SinalResposta.fasePassaFaixas(n * f0, frequenciaCorte1, frequenciaCorte2);
                    vetor_An_sinal_de_saida[n - 1] = An_entrada * SinalResposta.moduloPassaFaixas(n * f0, frequenciaCorte1, frequenciaCorte2);
                }
            }
        }
    }

    public static void ondaDenteSerra(int N, double f0, String tipoCanal,
            double frequenciaCorte0, double frequenciaCorte1, double frequenciaCorte2,
            double[] vetor_An_sinal_de_saida, double[] vetor_phi_n_sinal_de_saida) {

        for (int n = 1; n <= N; n++) {
            double An_entrada = 1 / (Math.PI * n);
            double phi_n_entrada = Math.PI / 2;

            if (tipoCanal.equals("passa_baixas")) {
                vetor_An_sinal_de_saida[n - 1] = An_entrada * SinalResposta.moduloPassaBaixas(n * f0, frequenciaCorte0);
                vetor_phi_n_sinal_de_saida[n - 1] = phi_n_entrada + SinalResposta.fasePassaBaixas(n * f0, frequenciaCorte0);
            } else if (tipoCanal.equals("passa_faixas")) {
                vetor_An_sinal_de_saida[n - 1] = An_entrada * SinalResposta.moduloPassaFaixas(n * f0, frequenciaCorte1, frequenciaCorte2);
                vetor_phi_n_sinal_de_saida[n - 1] = phi_n_entrada + SinalResposta.fasePassaFaixas(n * f0, frequenciaCorte1, frequenciaCorte2);
            }
        }
    }

    public static void ondaTriangular(int N, double f0, String tipoCanal,
            double frequenciaCorte0, double frequenciaCorte1, double frequenciaCorte2,
            double[] vetor_An_sinal_de_saida, double[] vetor_phi_n_sinal_de_saida) {

        for (int n = 1; n <= N; n++) {
            if (n % 2 == 0) {
                vetor_An_sinal_de_saida[n - 1] = 0;
                vetor_phi_n_sinal_de_saida[n - 1] = 0;
            } else {
                double An_entrada = 8 / (Math.PI * Math.PI * n * n);
                double phi_n_entrada = -Math.PI / 2;

                if (tipoCanal.equals("passa_baixas")) {
                    vetor_An_sinal_de_saida[n - 1] = An_entrada * SinalResposta.moduloPassaBaixas(n * f0, frequenciaCorte0);
                    vetor_phi_n_sinal_de_saida[n - 1] = phi_n_entrada + SinalResposta.fasePassaBaixas(n * f0, frequenciaCorte0);
                } else if (tipoCanal.equals("passa_faixas")) {
                    vetor_An_sinal_de_saida[n - 1] = An_entrada * SinalResposta.moduloPassaFaixas(n * f0, frequenciaCorte1, frequenciaCorte2);
                    vetor_phi_n_sinal_de_saida[n - 1] = phi_n_entrada + SinalResposta.fasePassaFaixas(n * f0, frequenciaCorte1, frequenciaCorte2);
                }
            }
        }
    }

    public static void ondaSenoidalRetificada(int N, double f0, String tipoCanal,
            double frequenciaCorte0, double frequenciaCorte1, double frequenciaCorte2,
            double[] vetor_An_sinal_de_saida, double[] vetor_phi_n_sinal_de_saida) {

        for (int n = 1; n <= N; n++) {
            if (n == 1) {
                double An_entrada = 2 / Math.PI;
                double phi_n_entrada = -Math.PI / 2;

                if (tipoCanal.equals("passa_baixas")) {
                    vetor_phi_n_sinal_de_saida[n - 1] = phi_n_entrada + SinalResposta.fasePassaBaixas(n * f0, frequenciaCorte0);
                    vetor_An_sinal_de_saida[n - 1] = An_entrada * SinalResposta.moduloPassaBaixas(n * f0, frequenciaCorte0);
                } else if (tipoCanal.equals("passa_faixas")) {
                    vetor_phi_n_sinal_de_saida[n - 1] = phi_n_entrada + SinalResposta.fasePassaFaixas(n * f0, frequenciaCorte1, frequenciaCorte2);
                    vetor_An_sinal_de_saida[n - 1] = An_entrada * SinalResposta.moduloPassaFaixas(n * f0, frequenciaCorte1, frequenciaCorte2);
                }
            } else {
                vetor_An_sinal_de_saida[n - 1] = 0;
                vetor_phi_n_sinal_de_saida[n - 1] = 0;
            }
        }
    }

    public static double amplitude(String tipoCanal, String tipoSinal,
            double frequenciaCorte0, double frequenciaCorte1,
            double frequenciaCorte2) {

        double a0 = SinalEntrada.amplitude(tipoSinal);
        double a0_saida = 0;

        if (tipoCanal.equals("passa_baixas") && frequenciaCorte0 != 0) {
            a0_saida = a0 * SinalResposta.moduloPassaBaixas(0, frequenciaCorte0);
        } else if (tipoCanal.equals("passa_faixas") && frequenciaCorte1 != 0 && frequenciaCorte2 != 0) {
            a0_saida = a0 * SinalResposta.moduloPassaFaixas(0, frequenciaCorte1, frequenciaCorte2);
        }

        return a0_saida;
    }
}
