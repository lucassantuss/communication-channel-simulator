/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.edu.cefsa.pbl.model;

import java.util.HashMap;

/**
 *
 * @author Renanzed
 */
public class Calculo {
    private HashMap<String, Double> valores;

    public Calculo() {
        this.valores = new HashMap<>();
    }

    public void adicionarValor(String chave, double valor) {
        this.valores.put(chave, valor);
    }

    public double getSoma(String chave1, String chave2) {
        double valor1 = this.valores.get(chave1);
        double valor2 = this.valores.get(chave2);
        return soma(valor1, valor2);
    }

    private double soma(double a, double b) {
        return a + b;
    }
}
