package br.edu.cefsa.pbl.model;

import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import java.util.ArrayList;
import java.util.List;

public class Helper {

    public static String serializeArrayToJson(double[] array) {

        // Cria o JsonArrayBuilder
        JsonArrayBuilder jsonArrayBuilder = Json.createArrayBuilder();

        // Adiciona os elementos do array ao JsonArrayBuilder
        for (double value : array) {
            jsonArrayBuilder.add(value);
        }

        // Cria o JsonArray
        JsonArray jsonArray = jsonArrayBuilder.build();

        // Retorna o JSON como uma string
        return jsonArray.toString();
    }

    public static String serializeListToJson(List<Double> list) {
        // Cria o JsonArrayBuilder
        JsonArrayBuilder jsonArrayBuilder = Json.createArrayBuilder();

        // Adiciona os elementos da lista ao JsonArrayBuilder
        for (Double value : list) {
            jsonArrayBuilder.add(value);
        }

        // Cria o JsonArray
        JsonArray jsonArray = jsonArrayBuilder.build();

        // Retorna o JSON como uma string
        return jsonArray.toString();
    }

    public static List<Double> convertArrayToList(double[] array) {
        List<Double> list = new ArrayList<>();

        for (double value : array) {
            list.add(value);
        }

        return list;
    }
}
