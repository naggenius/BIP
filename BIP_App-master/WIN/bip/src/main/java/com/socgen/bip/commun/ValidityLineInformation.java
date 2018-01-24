package com.socgen.bip.commun;

import org.threeten.bp.LocalDate;

public class ValidityLineInformation {
	
	private LocalDate dateStatut;
	private String typeProjet;
	
	public ValidityLineInformation(LocalDate dateStatut, String typeProjet) {
		this.dateStatut = dateStatut;
		this.typeProjet = typeProjet;
	}

	public LocalDate getDateStatut() {
		return dateStatut;
	}

	public String getTypeProjet() {
		return typeProjet;
	}

}
