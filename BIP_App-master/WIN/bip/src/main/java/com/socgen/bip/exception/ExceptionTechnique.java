package com.socgen.bip.exception;

public class ExceptionTechnique extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2831631001299823021L;

	public ExceptionTechnique(Exception e) {
		super(e);
	}

	public ExceptionTechnique(String msg) {
		super(msg);
	}

}
