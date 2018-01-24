<%@ page import="com.socgen.bip.commun.BipStatistiquePage,com.socgen.bip.user.UserBip,com.socgen.bip.menu.item.BipMenuInfoItem,java.util.Vector,java.util.Enumeration" %>
<%
String stat_weborama    = (String) application.getAttribute(com.socgen.bip.commun.BipConstantes.STATISTIQUE_PAGE);
String id_weborama      = (String) application.getAttribute(com.socgen.bip.commun.BipConstantes.ID_WEBORAMA);
String webo_zone_groupe = (String) application.getAttribute(com.socgen.bip.commun.BipConstantes.WEBO_ZONE_GROUPE);

if ( (stat_weborama != null) && (stat_weborama.equals("ACTIVE")) ) {
	BipStatistiquePage bsp = BipStatistiquePage.getInstance();
	if ( (bsp.getHTrace(id_webo_page)!=null) && (bsp.getHTrace(id_webo_page).equals("O")) ) {
		UserBip userWebo = (UserBip) session.getAttribute("UserBip");
		// cas particulier de la page d'accueil (id=1) où la zone ne doit pas être le menu
		String webo_zone = "Accueil";
		String webo_page = "Accueil general";
		if (id_webo_page.intValue()!=1) {
			webo_zone = userWebo.getCurrentMenu().getId();
			webo_page = id_webo_page.toString();
		}
		String webo_contenu = "";
		if (bsp.getHTraceAction(id_webo_page).equals("O") && (formWebo!=null)) {
			webo_contenu = formWebo.getAction();
		}
%>

<!--DEBUT WEBOSCOPE BIP -->
<!-- NE MODIFIER QUE WEBO_ZONE ET WEBO_PAGE-->
<script language="javascript">
var WEBO_ID = <%= id_weborama %>;
var WEBO_ZONE = "<%= webo_zone %>";
var WEBO_PAGE = "<%= webo_page %>";
var WEBO_ZONE_GROUPE = "<%= webo_zone_groupe %>";
var WEBO_PAGE_GROUPE = WEBO_ID ;
var WEBO_CONTENU1 = "<%= webo_contenu %>";

// Profondeur Frame
<%	if (id_webo_page.intValue()<1000) { %>
var WEBO_ACC = 0;
<%	} else { %>
var WEBO_ACC = 1;
<%	} %>

webo_ok=0;
</script>
<script language="javascript" src="/js/weboscope.js"></SCRIPT>
<SCRIPT>
if(webo_ok==1){webo_bn2_groupe(WEBO_ZONE,WEBO_PAGE, WEBO_ID, WEBO_ZONE_GROUPE, WEBO_PAGE_GROUPE, WEBO_ACC, WEBO_CONTENU1);}
</script>
<!-- FIN WEBOSCOPE COPYRIGHT WEBORAMA-->

<%
	}
}
%>
