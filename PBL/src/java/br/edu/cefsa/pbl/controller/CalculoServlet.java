package br.edu.cefsa.pbl.controller;

import br.edu.cefsa.pbl.model.Calculo;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/calcular")
public class CalculoServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");

        PrintWriter out = response.getWriter();

        double valor1 = Double.parseDouble(request.getParameter("valor1"));
        double valor2 = Double.parseDouble(request.getParameter("valor2"));
        
        Calculo calculo = new Calculo();
        calculo.adicionarValor("X", valor1);
        calculo.adicionarValor("Y", valor2);

        double resultado = calculo.getSoma("X", "Y");

        out.println("<html>");
        out.println("<head>");
        out.println("<title>Resultado da Soma</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>O resultado da soma é: " + resultado + "</h1>");
        out.println("</body>");
        out.println("</html>");
    }
}