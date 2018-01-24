package com.socgen.ich.ihm;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.socgen.bip.commun.action.BipAction;
/**
 * Servlet générique réalisant la fonction de plein écran.
 * Creation date: (02/01/01 10:01:24)
 * @author: Yoann Grandgirard
 */
public class FullScreenServlet  extends HttpServlet {
/**
 * Constructeur par défaut.
 */
public FullScreenServlet() {
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
 * Cette méthode met simplement à jour un paramètre dans la session.
 * Ce dernier (qui est un attribut d'un ContextBean) indique si l'on se trouve en mode plein écran ou en mode normal.
 * @param request javax.servlet.http.HttpServletRequest
 * @param response javax.servlet.http.HttpServletResponse
 */
public void service(HttpServletRequest request, HttpServletResponse response) {
	HttpSession session = request.getSession(true);
	ContextBean cb;
	if (session.getAttribute("CONTEXT") == null) {
		cb = new ContextBean();
		cb.setFullScreen(true);
		session.setAttribute("CONTEXT",cb);
	} else {
		cb = (ContextBean) session.getAttribute("CONTEXT");
		cb.setFullScreen(!cb.isFullScreen());
	}
	try {
		response.sendRedirect(request.getHeader("referer"));
	} catch (IOException e) {
		BipAction.logBipUser.error("Error. Check the code", e);
	}
}
}
