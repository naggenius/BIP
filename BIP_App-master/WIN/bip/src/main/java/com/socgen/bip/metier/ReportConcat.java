package com.socgen.bip.metier;

import java.util.LinkedList;

/**
 * Objet métier représentant un rapport concaténé
 * @author X119481
 *
 */
public class ReportConcat {
	/**
	 * Liste des sous rapports
	 */
	LinkedList<Report> listeReport;
	/**
	 * Rapport issu de la concaténation
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
