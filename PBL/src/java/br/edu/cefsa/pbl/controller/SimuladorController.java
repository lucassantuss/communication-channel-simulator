package br.edu.cefsa.pbl.controller;

import br.edu.cefsa.pbl.model.CanalComunicacao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SimuladorController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tipoSinal = request.getParameter("tipo_sinal");
        int frequencia = Integer.parseInt(request.getParameter("frequencia"));
        String tipoCanal = request.getParameter("tipo_canal");
        int frequenciaCorte = Integer.parseInt(request.getParameter("frequencia_corte"));

        CanalComunicacao canal = new CanalComunicacao(tipoSinal, frequencia, tipoCanal, frequenciaCorte);

        // TODO
        // Passar os dados como parametros do QueryString para a pagina de resultados
        // Redireciona para a página de resultados
        request.getRequestDispatcher("processar.jsp").forward(request, response);
    }
}
