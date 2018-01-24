package com.socgen.bip.rbip.commun.controller;

import java.util.Date;
import java.util.Map;
import java.util.Set;

import org.threeten.bp.Instant;
import org.threeten.bp.LocalDate;
import org.threeten.bp.ZoneId;

import com.socgen.bip.commun.MonthAndYearFunctional;
import com.socgen.bip.commun.ValidityLineInformation;
import com.socgen.bip.rbip.commun.loader.RBipData;

public class CommonDataForRBipLineProcessing {

	private Set<String> idLignesBipAvecStructuresSR;
	private Map<String, ValidityLineInformation> validityLinesInformationByidLigne;
	private Set<String> idLignesBipAvecCdpValides;
	private MonthAndYearFunctional monthAndYearFunctional;
	private Map <String,Set<String>> validFFbyLigneBipId;
	private Map<String,Set<Date>> retroData;

	// REJET GLOBAL pour la ligne Bip XXXX car elle est inexistante
	// REJET GLOBAL pour la ligne Bip XXXX car elle est fermée
	// REJET pour la ligne C6WE, ressource 53614, activité 010108 et début de période consommée 01/02/2016 : la ligne Bip CVKK désignée par FF est inexistante ou fermée
	private CommonDataForRBipLineProcessing() {
	}

	public static class Builder {

		private Set<String> idLignesBipAvecStructuresSR;
		private Map<String, ValidityLineInformation> validityLinesInformationByidLigne;
		private Set<String> idLignesBipAvecCdpValides;
		private MonthAndYearFunctional monthAndYearFunctional;
		private Map <String,Set<String>> validFFbyLigneBipId;
		private Map<String,Set<Date>> retroData;

		public Builder validFFbyLigneBipId(Map <String,Set<String>> validFFbyLigneBipId) {
			this.validFFbyLigneBipId = validFFbyLigneBipId;
			return this;

		}
		
		public Builder retroData(Map<String,Set<Date>> retroData) {
			this.retroData = retroData;
			return this;

		}
				
		public Builder idLignesBipAvecStructures(Set<String> idLignesBipAvecStructureSR) {
			this.idLignesBipAvecStructuresSR = idLignesBipAvecStructureSR;
			return this;

		}

		public Builder validityLinesInformationByidLigne(Map<String, ValidityLineInformation> validityLinesInformationByidLigne) {
			this.validityLinesInformationByidLigne = validityLinesInformationByidLigne;
			return this;
		}

		public Builder idLignesBipAvecCdpValides(Set<String> idLignesBipAvecCdpValides) {
			this.idLignesBipAvecCdpValides = idLignesBipAvecCdpValides;
			return this;
		}

		public CommonDataForRBipLineProcessing build() {
			CommonDataForRBipLineProcessing commonDataForRBipLineProcessing = new CommonDataForRBipLineProcessing();
			commonDataForRBipLineProcessing.idLignesBipAvecStructuresSR = idLignesBipAvecStructuresSR;
			commonDataForRBipLineProcessing.validityLinesInformationByidLigne = validityLinesInformationByidLigne;
			commonDataForRBipLineProcessing.idLignesBipAvecCdpValides = idLignesBipAvecCdpValides;
			commonDataForRBipLineProcessing.monthAndYearFunctional = monthAndYearFunctional;
			commonDataForRBipLineProcessing.validFFbyLigneBipId = validFFbyLigneBipId;
			commonDataForRBipLineProcessing.retroData = retroData;
			return commonDataForRBipLineProcessing;
		}

		public Builder monthAndYearFunctional( MonthAndYearFunctional monthAndYearFunctional) {
			this.monthAndYearFunctional = monthAndYearFunctional;
			return this;
		}

	}

	/*BIP-355 Outsourcing not allowed for non-productive BIP Line- STARTS*/
	public boolean validFFbyLigneBipIdCheck(String idLigneBip, String stacheType) {
		if(!validFFbyLigneBipId.isEmpty()){
			if (validFFbyLigneBipId.containsKey(idLigneBip)){
				Set<String> stacheTypeSet = validFFbyLigneBipId.get(idLigneBip);
				if (stacheTypeSet.contains(stacheType)){
					return false;
				}
			}
		}			
		return true;
	}
	/*BIP-355 Outsourcing not allowed for non-productive BIP Line- ENDS*/
	
	public boolean retroDataCheck(String ident, Date consoDate) {
		if(!retroData.isEmpty()){
			if (retroData.containsKey(ident)){
				Set<Date> consoDateSet = retroData.get(ident);
				if (consoDateSet.contains(consoDate)){
					return false;
				}
			}
		}			
		return true;
	}
	
	public boolean isStructureSr(String idLigneBip) {
		return idLignesBipAvecStructuresSR.contains(idLigneBip);
	}

	public boolean isCdpValide(String idLigneBip) {
		return idLignesBipAvecCdpValides.contains(idLigneBip);
	}

	public boolean isLigneInexistante(RBipData rBipData) {
		return isLigneInexistance(rBipData.getIdLigne());
	}

	private boolean isLigneInexistance(String idLigne) {
		if (validityLinesInformationByidLigne.containsKey(idLigne)) {
			return false;
		}

		return true;
	}


	public boolean isLigneBipFermee(RBipData rBipData) {
		return isLigneBipFermee(rBipData.getIdLigne(),  rBipData.getDateSaisie());
	}

	private boolean isLigneBipFermee(String idLigneBip, Date dateSaisieOldApi ) {
		ValidityLineInformation validityLineInformation = validityLinesInformationByidLigne.get(idLigneBip);
		
		LocalDate dateStatutLigneBip = validityLineInformation.getDateStatut();
		if (dateStatutLigneBip == null) {
			return false;
		}
		 
		LocalDate dateSaisie = Instant.ofEpochMilli(dateSaisieOldApi.getTime()).atZone(ZoneId.systemDefault()).toLocalDate();
	
		if ((dateSaisie.getMonthValue() <= dateStatutLigneBip.getMonthValue() && dateSaisie.getYear() <= dateStatutLigneBip.getYear()) 
				&&
				(dateStatutLigneBip.getMonthValue()>= monthAndYearFunctional.getMonthFunctional() && dateStatutLigneBip.getYear()>= monthAndYearFunctional.getYearFunctional())) {
			return false;
		}
		return true;
	}

	public boolean isLigneBipFFInexistante(RBipData rBipData) {
		
		if (!rBipData.isSousTraitance()){
			return false;
		}
		
		return isLigneInexistance(rBipData.extractIdLigneBipFromSousTacheType());
	}

	public boolean isLigneBipFFFermee(RBipData rBipData) {
		if (!rBipData.isSousTraitance()){
			return false;
		}
			
		return isLigneBipFermee(rBipData.extractIdLigneBipFromSousTacheType(),  rBipData.getDateSaisie());
	}


	// public boolean getRejetGlobalValide(RBipData rBipData) {
	//
	// Date dateSaisieOldApi = rBipData.getDateSaisie();
	// LocalDate dateSaisie = Instant.ofEpochMilli(dateSaisieOldApi.getTime()).atZone(ZoneId.systemDefault()).toLocalDate();
	//
	// if ((dateSaisie.isBefore(dateStatutLigneBip) || !dateSaisie.isAfter(dateStatutLigneBip))) {
	//
	//
	//
	//
	// // ligne en propre
	// boolean isValide = checkLineBipValide(rBipData.getIdLigne(), dateSaisie );
	//
	// if (!isValide) {
	// return false;
	// }
	//
	// if (isValide && !rBipData.isSousTraitance()) {
	// return true;
	// }
	//
	// // si sous traitance
	// return checkLineBipValide(rBipData.extractIdLigneBipFromSousTacheType(), dateSaisie);
	//
	// }
	//
	// private boolean checkLineBipValide(String idLigneBip, LocalDate dateSaisieInput) {
	// ValidityLineInformation validityLineInformation = validityLinesInformationByidLigne.get(idLigneBip);
	//
	// LocalDate dateStatutLigneBip = validityLineInformation.getDateStatut();
	//
	// if (dateStatutLigneBip == null) {
	// return true;
	// }
	//
	// else {
	//
	// // if (dateSaisieInput <= validityLineInformation.getDateStatut() && dateSaisieInput.getYear() == functionalYear) {
	//
	// //&& dateSaisieInput.getYear() == functionalMonth.getYear()) {
	// return true;
	// }
	//
	// return false;
	// }
	// }

}
