package br.edu.cefsa.pbl.model;

public class SinalResposta {

    public static double moduloPassaBaixas(double f, double f_c) {
        return 1 / Math.sqrt(1 + Math.pow(f / f_c, 2));
    }

    public static double fasePassaBaixas(double f, double f_c) {
        return Math.atan(-f / f_c);
    }

    public static double moduloPassaFaixas(double f, double f1, double f2) {
        return (1 / (f2 - f1)) * (1 / (1 + Math.pow(f / f1, 2))) * (1 / (1 + Math.pow(f / f2, 2)));
    }

    public static double fasePassaFaixas(double f, double f1, double f2) {
        return (-90 - Math.atan((f * (f1 + f2)) / (f1 * f2 - Math.pow(f, 2))));
    }
}