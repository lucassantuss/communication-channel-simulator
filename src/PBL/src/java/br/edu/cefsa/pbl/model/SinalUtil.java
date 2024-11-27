package br.edu.cefsa.pbl.model;

import java.util.ArrayList;
import java.util.List;

public class SinalUtil {

    public static List<Integer> frequenciaSinalEntradaSaida() {

        List<Integer> frequencias = new ArrayList<>();
        int f_final = 50;

        for (int i = 0; i <= f_final; i++) {
            frequencias.add(i);
        }

        return frequencias;
    }

    public static String descricaoTipoSinal(String tipoSinal) {

        return switch (tipoSinal) {
            case "quadrada" ->
                "Onda Quadrada";
            case "triangular" ->
                "Onda Triangular";
            case "dente_serra" ->
                "Onda Dente-de-Serra";
            case "senoidal_retificada" ->
                "Onda Senoidal Retificada";
            default ->
                "Onda não identificada";
        };
    }

    public static String descricaoTipoCanal(String tipoCanal) {

        return switch (tipoCanal) {
            case "passa_baixas" ->
                "Canal Passa-Baixas";
            case "passa_faixas" ->
                "Canal Passa-Faixas";
            default ->
                "Canal não identificado";
        };
    }
}