package br.edu.cefsa.pbl.model;

public class SinalEmitido {

    public static double ondaQuadrada(double t, Integer f0) {
        return Math.sin(2 * Math.PI * f0 * t) >= 0 ? 1 : -1;
    }

    public static double ondaTriangular(double t, double periodo) {
        // Usado para que t_mod esteja sempre entre 0 e 'periodo'
        double t_mod = ((t % periodo) + periodo) % periodo;

        if (t_mod < periodo / 2) {
            return 4 * t_mod / periodo - 1;
        } else {
            return -4 * t_mod / periodo + 3;
        }        
    }

    public static double ondaDenteSerra(double t, double periodo) {
        return 2 * (t / periodo - Math.floor(0.5 + t / periodo));
    }

    public static double ondaSenoidalRetificada(double t, Integer f0) {
        return Math.abs(Math.sin(2 * Math.PI * f0 * t));
    }
}