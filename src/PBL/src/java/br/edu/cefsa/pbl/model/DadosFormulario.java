package br.edu.cefsa.pbl.model;

public class DadosFormulario {
    private String tipoSinal;
    private int frequencia;
    private String tipoCanal;
    private Integer frequenciaCorte0;
    private Integer frequenciaCorte1;
    private Integer frequenciaCorte2;

    public DadosFormulario(String tipoSinal, int frequencia, String tipoCanal, Integer frequenciaCorte0, Integer frequenciaCorte1, Integer frequenciaCorte2) {
        this.tipoSinal = tipoSinal;
        this.frequencia = frequencia;
        this.tipoCanal = tipoCanal;
        this.frequenciaCorte0 = frequenciaCorte0;
        this.frequenciaCorte1 = frequenciaCorte1;
        this.frequenciaCorte2 = frequenciaCorte2;
    }

    public DadosFormulario() {}

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

    public Integer getFrequenciaCorte0() {
        return frequenciaCorte0;
    }

    public void setFrequenciaCorte0(Integer frequenciaCorte0) {
        this.frequenciaCorte0 = frequenciaCorte0;
    }

    public Integer getFrequenciaCorte1() {
        return frequenciaCorte1;
    }

    public void setFrequenciaCorte1(Integer frequenciaCorte1) {
        this.frequenciaCorte1 = frequenciaCorte1;
    }

    public Integer getFrequenciaCorte2() {
        return frequenciaCorte2;
    }

    public void setFrequenciaCorte2(Integer frequenciaCorte2) {
        this.frequenciaCorte2 = frequenciaCorte2;
    }
}