package com.socgen.bip.exception;

/**
 * @author RSRH/ICH/GMO Equipe Bip
 * @author user
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class ReportException extends BipException
{
	public static final int REPORT_DEFAULT	= 21000;
	public static final int REPORT_SERVER	= 21001;
	public static final int REPORT_BADPARAM	= 21002;
	public static final int REPORT_FAILURE	= 21003;
	public static final int REPORT_ASYNC		= 21004;
	public static final int REPORT_PROCHISTO	= 21005;
	
	public ReportException(int codeErreur, Throwable erreurSource)
	{
		super(codeErreur, erreurSource);
	}
	
	public ReportException(int codeErreur, Throwable erreurSource, Object [] params)
	{
		super(codeErreur, erreurSource, params);
	}
}
