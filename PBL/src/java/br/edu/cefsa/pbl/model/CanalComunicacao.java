package br.edu.cefsa.pbl.model;

public class CanalComunicacao {
    private String tipoSinal;
    private int frequencia;
    private String tipoCanal;
    private int frequenciaCorte;

    public CanalComunicacao() {}

    public CanalComunicacao(String tipoSinal, int frequencia, String tipoCanal, int frequenciaCorte) {
        this.tipoSinal = tipoSinal;
        this.frequencia = frequencia;
        this.tipoCanal = tipoCanal;
        this.frequenciaCorte = frequenciaCorte;
    }

    public String getTipoSinal() {
        return tipoSinal;
    }

    public void setTipoSinal(String tipoSinal) {
        this.tipoSinal = tipoSinal;
    }

    public int getFrequencia() {
        return frequencia;
    }

    public void setFrequencia(int frequencia) {
        this.frequencia = frequencia;
    }

    public String getTipoCanal() {
        return tipoCanal;
    }

    public void setTipoCanal(String tipoCanal) {
        this.tipoCanal = tipoCanal;
    }

    public int getFrequenciaCorte() {
        return frequenciaCorte;
    }

    public void setFrequenciaCorte(int frequenciaCorte) {
        this.frequenciaCorte = frequenciaCorte;
    }
}