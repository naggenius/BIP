package com.socgen.bip.form;

import java.util.Hashtable;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author DISC/SUP Equipe Bip
 * @author B.AARAB
 *
 * Classe ActionForm spécifique aux extractions de la BIP
 * Le parametre action permette de lancer<br>
 * n'importe quel synthese locale d'édition de la BIP
 */
public class ChangeCFForm extends AutomateForm
{	
	/**
	 * Valeur de action
	 */
	private String action;
	
	/**
		 * Valeur du centre de frais
		 */
	private String centre_Frais;
		
	/**
			 * Valeur la liste des centres de frais
			 */
	private String liste_Centres_Frais;		
			
	/**
				 * Valeur du filiale
				 */
	private String filcode;			
		

	/**
	 * @return
	 */
	public String getAction()
	{
		return action;
	}

	/**
		 * @return
		 */
	public String getCentre_Frais()
	{
		return centre_Frais;
	}


	/**
			 * @return
			 */
   public String getListe_Centres_Frais()
	{
		return liste_Centres_Frais;
	}

	/**
				 * @return filcode
				 */
	public String getFilCode()
   {
			return filcode;
	}
  

	/**
	 * @param string
	 */
	public void setAction(String string)
	{
		action = string;
	}
	
	/**
		 * @param string
		 */
	public void setCentre_Frais(String string)
	{
		centre_Frais = string;
	}
		
		
	/**
			 * @param string
			 */
	public void setListe_Centres_Frais(String string)
	{
		liste_Centres_Frais = string;
	}
			
	/**
				 * @param string
				 */
	public void setFilCode(String string)
	{
		filcode = string;
	}	
		
	
	   /**
		 * @see com.socgen.bip.commun.form.ReportForm#putParamsToHash(Hashtable)
		 */
		public Hashtable putParamsToHash(Hashtable hP_paramsJob)
		{
			if ( (centre_Frais != null) && (centre_Frais.length() >= 1) )
				hP_paramsJob.put("centre_Frais", centre_Frais);
			if ( (liste_Centres_Frais != null) && (liste_Centres_Frais.length() >= 1) )
				hP_paramsJob.put("liste_Centres_Frais", liste_Centres_Frais);
				
			return hP_paramsJob;	
			
		}
	
		

}
