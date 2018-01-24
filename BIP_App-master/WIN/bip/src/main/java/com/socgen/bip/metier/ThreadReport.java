package com.socgen.bip.metier;

/**
 * @author E.GREVREND
 * La classe lance la g�n�ration du report qui lui est associ�.
 * Aurait pu etre une inner-class de ReportManager.
 */
public class ThreadReport extends Thread
{
	/**
	 * report dont va s'occuper la classe
	 */
	private Report report;
	
	/**
	 * Constucteur appel� par ReportManager.
	 */
	protected ThreadReport(Report report)
	{
		super();
		
		/*if (logService.isDebugEnabled())
			ReportManager.logService.debug("ThreadReport.new " + report.toString());*/

		this.report = report;
	}

	/**
	 * On lance le build du report. Une fois le traitement termin� on retire le report de la liste des traitements en cours.
	 */	
	public void run ()
	{
		report.build();
		
		/*if (logService.isDebugEnabled())
			ReportManager.logService.debug("ThreadReport.run Termine : "+ report.toString());*/
		
		ReportManager.getInstance().removeCurrentReport(report);
	}
}
