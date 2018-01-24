package com.socgen.bip.metier;

import java.util.LinkedList;

/**
 * Objet m�tier repr�sentant un rapport concat�n�
 * @author X119481
 *
 */
public class ReportConcat {
	/**
	 * Liste des sous rapports
	 */
	LinkedList<Report> listeReport;
	/**
	 * Rapport issu de la concat�nation
	 */
	Report reportResult;
	
	public ReportConcat(LinkedList<Report> listeReport, Report reportResult) {
		this.listeReport = listeReport;
		this.reportResult = reportResult;
	}
	
	public LinkedList<Report> getListeReport() {
		return listeReport;
	}
	public void setListeReport(LinkedList<Report> listeReport) {
		this.listeReport = listeReport;
	}
	public Report getReportResult() {
		return reportResult;
	}
	public void setReportResult(Report reportResult) {
		this.reportResult = reportResult;
	}
}
