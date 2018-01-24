package com.socgen.bip.action;
 
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.DownloadFileForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author K. Hazard - 06/10/2004
 * 
 * Action de mise à jour des Actualites chemin : Administration/Gestion des
 * actualites pages : bActuAd.jsp et mActuAd.jsp pl/sql : actualite.sql
 */
public class DownloadFileAction extends AutomateAction implements BipConstantes {

	private static String PACK_DOWNLOAD = "file.download.proc";

	private static String PACK_DELETE = "file.supprimer.proc";

	
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProctest)
			throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = null;

		String signatureMethode = "consulter(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);

		// On récupère la clé pour trouver le nom de la procédure stockée dans
		// bip_proc.properties
		DownloadFileForm bipForm = (DownloadFileForm) form;
		// On exécute la procédure stockée
		try {
			vParamOut = jdbc.getResult(
					hParamProctest, configProc, PACK_DOWNLOAD);
			try {
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					ParametreProc paramOut = (ParametreProc) e.nextElement();

					if (paramOut.getNom().equals("curseur")) {
						// Récupération du Ref Cursor
						ResultSet rset = (ResultSet) paramOut.getValeur();

						try {
							if (rset.next()) {
								bipForm.setBlob_fichier((Blob)(rset
										.getObject(1)));
								bipForm.setNom_fichier(rset.getString(2));
								bipForm.setMime_fichier(rset.getString(3));
								bipForm.setSize_fichier(rset.getInt(4));
								bipForm.setMsgErreur(null);

								String filename = bipForm.getNom_fichier();
								Blob blob =bipForm.getBlob_fichier();
								// construction du fichier en sortie.
								response.setContentType(bipForm
										.getMime_fichier());
								response.setHeader("Content-Disposition",
										"attachment; filename=\"" + filename
												+ "\";");
								response.setHeader("Cache-Control", "");
								response.setHeader("Pragma", "");
								response.setHeader("Expires", "");
								
								response.setContentLength((int)blob.length());

								try {
									OutputStream os = response
											.getOutputStream();
									InputStream is = blob.getBinaryStream();
									int count;
									byte buf[] = new byte[(int)blob.length()];
									while ((count = is.read(buf)) > -1) {
										os.write(buf, 0, count);
									}
									is.close();
									os.flush();
									os.close();
								} catch (Exception ex) {
									logBipUser
											.debug("DownloadFileAction-consulter() --> SQLException-OutputStream :"
													+ ex.getMessage());
									// Erreur de lecture du resultSet
									errors.add(ActionErrors.GLOBAL_ERROR,
											new ActionError("11217"));
									 jdbc.closeJDBC(); return mapping.findForward("error");
								}
							} // if
						}// try
						catch (SQLException sqle) {
							logBipUser
									.debug("DownloadFileAction-consulter() --> SQLException-rset.next() :"
											+ sqle.getMessage());
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}// catch
						finally {
							try {
								if (rset != null)
									rset.close();
							}// try
							catch (SQLException sqle) {
								logBipUser
										.debug("DownloadFileAction-consulter() --> SQLException-rset.close() :"
												+ sqle.getMessage());
								// Erreur de lecture du resultSet
								errors.add(ActionErrors.GLOBAL_ERROR,
										new ActionError("11217"));
								 jdbc.closeJDBC(); return mapping.findForward("error");
							}// catch
						}// finally
					}
				}// for
				message = jdbc.recupererResult(vParamOut, "consulter");
			} catch (BaseException be) {
				logBipUser
						.debug("DownloadFileAction-consulter() --> BaseException :"
								+ be);
				logBipUser
						.debug("DownloadFileAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				logService
						.debug("DownloadFileAction-consulter() --> BaseException :"
								+ be);
				logService
						.debug("DownloadFileAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on récupère le message
				((AutomateForm) form).setMsgErreur(message);
				logBipUser.debug("DownloadFileAction-consulter() -->message :"
						+ message);
			}

		} catch (BaseException be) {
			logService
					.debug("DownloadFileAction-consulter() --> BaseException :"
							+ be);
			logService.debug("DownloadFileAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser
					.debug("DownloadFileAction-consulter() --> BaseException :"
							+ be);
			logBipUser.debug("DownloadFileAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((AutomateForm) form).setMsgErreur(message);
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return PAS_DE_FORWARD;
	}// consulter

	protected String recupererCle(String mode) {

		String cle = PACK_DELETE;
		  return cle;
	}

}
