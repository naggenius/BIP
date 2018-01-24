package com.socgen.bip.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import org.apache.struts.action.ActionForm;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.AuditImmoForm;
import com.socgen.bip.service.dto.SyntheseImmoDto;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

public class SyntheseImmoDtoReader implements BipConstantes{
	 private static String PACK_SELECT = "immo.synthese.proc";
	 
		public SyntheseImmoDtoReader() { 
		}

		public Collection getSyntheseImmoExcell(Hashtable hParamProc, ActionForm form) throws Exception{
			if("true".equals(((AuditImmoForm)form).getPerim())){
				PACK_SELECT = "immo.synthese.perim.proc";
			}else if("mo".equals(((AuditImmoForm)form).getPerim())){
				PACK_SELECT = "immo.synthese.mo.proc";
			}else{
				PACK_SELECT = "immo.synthese.proc";
			}
			JdbcBip jdbc = new JdbcBip(); 
			Vector vParamOut = new Vector();
			ParametreProc paramOut;
			Config configProc = ConfigManager.getInstance(BIP_PROC);
			ResultSet rset = null;
			Collection syntheseResult = new ArrayList();
			
			//hParamProc.put("centreFrais", (String)hParamProc.get("centreFrais"));
			
			try {
				 vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT);
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();
					if (paramOut.getNom().equals("moismens")) {
						AuditImmoForm bipForm = (AuditImmoForm) form;
						bipForm.setMoismens((String)paramOut.getValeur());					
						}
					
					if (paramOut.getNom().equals("dplib")) {
						AuditImmoForm bipForm = (AuditImmoForm) form;
						bipForm.setDplib((String)paramOut.getValeur());					
						}
					
					if (paramOut.getNom().equals("libprojet")) {
						AuditImmoForm bipForm = (AuditImmoForm) form;
						bipForm.setLibprojet((String)paramOut.getValeur());					
						}
					
					if (paramOut.getNom().equals("message")) {
						AuditImmoForm bipForm = (AuditImmoForm) form;
						bipForm.setMsgErreur((String)paramOut.getValeur());					
						}
					
					if (paramOut.getNom().equals("curseur")) {
						rset = (ResultSet) paramOut.getValeur();
					 	//try {
							 while (rset.next()) {
								 SyntheseImmoDto syntheseImmoDto = (SyntheseImmoDto) readCurrent(rset,((AuditImmoForm)form).getPerim());
								 syntheseResult.add(syntheseImmoDto);
							}
							if (rset != null){
								jdbc.closeJDBC(); 
								rset.close();
								} 
					//------------------ ATTENTION -----------------------------------
				    //NE pas faire comme les autres DTO Reader 
				    //il ne faut pas catcher l'erreur et la remonter via le throws de la méthode
				    //sinon on perd beaucoup plus de temps àrechercher l'erreur
						 //} //try
						/* catch (SQLException sqle) {
						 	jdbc.closeJDBC(); 
						 	return  new ArrayList();
						 } */
					} //if
				} //for
			} 	catch (BaseException be) {
									
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					String message = BipException.getMessageFocus(
							BipException.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((AuditImmoForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); 

				} 
				
			} 
			jdbc.closeJDBC();  
			return syntheseResult;
		}

		protected SyntheseImmoDto readCurrent(ResultSet rs, String mode) throws SQLException {
			SyntheseImmoDto elt = new SyntheseImmoDto();
			if(!"mo".equals(mode)){
				elt.setIcpi(rs.getString(1));
				elt.setIlibel(rs.getString(2));//KRA PPM 61879 : debut
				elt.setStatut(rs.getString(3));
				elt.setDatstatut(rs.getString(4));
	            elt.setAnnee(rs.getString(5));
	            elt.setJh(rs.getDouble(6));
	            elt.setEuros(rs.getDouble(7));//KRA PPM 61879 : fin
			}else{
				elt.setComposant(rs.getString(1));
				elt.setIlibel(rs.getString(2));//KRA PPM 61879 : debut
				elt.setStatut(rs.getString(3));
				elt.setDatstatut(rs.getString(4));
				elt.setIcpi(rs.getString(5));
	            elt.setAnnee(rs.getString(6));
	            elt.setJh(rs.getDouble(7));
	            elt.setEuros(rs.getDouble(8));//KRA PPM 61879 : fin
			}
		    
			return elt;
		}
		
}
