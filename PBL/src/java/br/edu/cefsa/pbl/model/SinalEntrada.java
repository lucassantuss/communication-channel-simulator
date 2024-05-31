package br.edu.cefsa.pbl.model;

public class SinalEntrada {

    public static void ondaQuadrada(int N, double[] vetor_An, double[] vetor_phi_n) {
        // Para uma onda quadrada, os componentes ímpares (n ímpar)
        // têm amplitude 4 / (π * n) e uma fase de -π/2
        // Enquanto os componentes pares têm amplitude e fase zero.
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
        // Para uma onda dente de serra, todos os componentes têm 
        // amplitude 1 / (π * n) e uma fase de π/2.
        for (int n = 1; n <= N; n++) {
            double An = 1 / (Math.PI * n);
            double phi_n = Math.PI / 2;

            vetor_An[n - 1] = An;
            vetor_phi_n[n - 1] = phi_n;
        }
    }

    public static void ondaTriangular(int N, double[] vetor_An, double[] vetor_phi_n) {
        // Para uma onda triangular, os componentes ímpares (n ímpar)
        // têm amplitude 8 / (π² * n²) e uma fase de -π/2
        // Enquanto os componentes pares têm amplitude e fase zero.
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
        // Para uma onda senoidal retificada, apenas o componente de frequência
        // fundamental (n=1) tem amplitude 2 / π e uma fase de -π/2
        // Enquanto todos os outros componentes têm amplitude e fase zero.
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
