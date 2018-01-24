<%@taglib uri="/WEB-INF/sso.tld" prefix="sso" %>
<!-- D�connexion SSO -->
<sso:SsoCloseSession/>
<%
try {
	// pour vider l'utilisateur de la session
    session.removeAttribute("UserBip");
	// retour sur la home page
	response.sendRedirect(request.getContextPath());
} catch (java.io.IOException io) {
	throw new JspTagException("Probl�me lors de la redirection vers la page d'accueil");
}
%>