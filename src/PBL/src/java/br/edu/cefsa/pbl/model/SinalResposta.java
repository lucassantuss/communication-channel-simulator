package br.edu.cefsa.pbl.model;

public class SinalResposta {

    public static double moduloPassaBaixas(double f, double f_c) {
        return 1 / Math.sqrt(1 + Math.pow(f / f_c, 2));
    }

    public static double fasePassaBaixas(double f, double f_c) {
        return Math.atan(-f / f_c);
    }

    public static double moduloPassaFaixas(double f, double f1, double f2) {
        double f0 = Math.sqrt(f1 * f2);
        double bw = f2 - f1;

        return (f / f0) / Math.sqrt(1 + Math.pow((f * bw / (f0 * f0)), 2));
    }

    public static double fasePassaFaixas(double f, double f1, double f2) {
        double f0 = Math.sqrt(f1 * f2);
        double bw = f2 - f1;
        
        return Math.atan((f * bw) / (f0 * f0 - f * f)) - Math.PI / 2;
    }
}