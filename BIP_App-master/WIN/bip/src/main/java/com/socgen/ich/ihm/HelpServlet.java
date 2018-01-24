package com.socgen.ich.ihm;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.socgen.bip.commun.action.BipAction;
/**
 * Servlet réalisant une fonction d'aide contextuelle générique.
 * Creation date: (02/01/01 10:01:24)
 * @author: Yoann Grandgirard
 */
public class HelpServlet  extends HttpServlet {
	protected java.lang.String res = "ich_help";
/**
 * Constructeur par défaut.
 */
public HelpServlet() {
	super();
}
/**
 * Renvoie simplement vers la méthode service.
 * @param request javax.servlet.http.HttpServletRequest
 * @param response javax.servlet.http.HttpServletResponse
 */
public void doGet(HttpServletRequest request,HttpServletResponse response) {
	service(request,response);
}
/**
 * Renvoie simplement vers la méthode service.
 * @param request javax.servlet.http.HttpServletRequest
 * @param response javax.servlet.http.HttpServletResponse
 */
public void doPost(HttpServletRequest request, HttpServletResponse response) {
	service(request,response);
}
/**
 * Méthode générique d'appel d'une page d'aide contextuelle.
 * @param request javax.servlet.http.HttpServletRequest
 * @param response javax.servlet.http.HttpServletResponse
 */
public void service(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) {
	String page ="none";
	String titre = request.getParameterValues("TITRE")[0];
	java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(res);
	try {
		page = rb.getString(titre);
	} catch (Exception e) {
		BipAction.logBipUser.error("Error. Check the code", e);
	}
	try {
		response.sendRedirect(rb.getString("ROOT_HELP")+page);
	} catch (java.io.IOException e) {
		BipAction.logBipUser.error("Error. Check the code", e);
	}
}
}
