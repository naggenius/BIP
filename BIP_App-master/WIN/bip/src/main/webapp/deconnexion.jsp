<%@taglib uri="/WEB-INF/sso.tld" prefix="sso" %>
<!-- Déconnexion SSO -->
<sso:SsoCloseSession/>
<%
try {
	// pour vider l'utilisateur de la session
    session.removeAttribute("UserBip");
	// retour sur la home page
	response.sendRedirect(request.getContextPath());
} catch (java.io.IOException io) {
	throw new JspTagException("Problème lors de la redirection vers la page d'accueil");
}
%>