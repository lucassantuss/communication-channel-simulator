package br.edu.cefsa.pbl.model;

public class SinalEntrada {

    public static void ondaQuadrada(int N, double[] vetor_An, double[] vetor_phi_n) {
        for (int n = 1; n <= N; n++) {
            double An, phi_n;

            if (n % 2 == 0) {
                An = 0;
                phi_n = 0;
            } else {
                An = 4 / (Math.PI * n);
                phi_n = -Math.PI / 2;
            }

            vetor_An[n - 1] = An;
            vetor_phi_n[n - 1] = phi_n;
        }
    }

    public static void ondaDenteSerra(int N, double[] vetor_An, double[] vetor_phi_n) {
        for (int n = 1; n <= N; n++) {
            double An = 1 / (Math.PI * n);
            double phi_n = Math.PI / 2;

            vetor_An[n - 1] = An;
            vetor_phi_n[n - 1] = phi_n;
        }
    }

    public static void ondaTriangular(int N, double[] vetor_An, double[] vetor_phi_n) {
        for (int n = 1; n <= N; n++) {
            double An, phi_n;

            if (n % 2 == 0) {
                An = 0;
                phi_n = 0;
            } else {
                An = 8 / (Math.PI * Math.PI * n * n);
                phi_n = -Math.PI / 2;
            }

            vetor_An[n - 1] = An;
            vetor_phi_n[n - 1] = phi_n;
        }
    }

    public static void ondaSenoidalRetificada(int N, double[] vetor_An, double[] vetor_phi_n) {
        for (int n = 1; n <= N; n++) {
            double An, phi_n;

            if (n == 1) {
                An = 2 / Math.PI;
                phi_n = -Math.PI / 2;
            } else {
                An = 0;
                phi_n = 0;
            }

            vetor_An[n - 1] = An;
            vetor_phi_n[n - 1] = phi_n;
        }
    }

    public static double amplitude(String tipoSinal) {
        return tipoSinal.equals("dente_serra") ? 0.5 : 0;
    }
}