package com.socgen.bip.metier;

import java.util.Hashtable;
import java.util.Vector;

import com.socgen.bip.user.UserBip;

public class Job {

	private String jobId;
	private Vector listeReportsEnum;
	private UserBip userBip;
	private Hashtable paramsJob;
	private String schema;
	private String type_job;
	
	public Job(String jobId, Vector listeReportsEnum, UserBip userBip, Hashtable paramsJob, String schema, String type_job) {
		this.jobId = jobId;
		this.listeReportsEnum = listeReportsEnum;
		this.userBip = userBip;
		this.paramsJob = paramsJob;
		this.schema = schema;
		this.type_job = type_job;
	}

	public String getJobId() {
		return jobId;
	}

	public void setJobId(String jobId) {
		this.jobId = jobId;
	}

	public Vector getListeReportsEnum() {
		return listeReportsEnum;
	}

	public void setListeReportsEnum(Vector listeReportsEnum) {
		this.listeReportsEnum = listeReportsEnum;
	}

	public Hashtable getParamsJob() {
		return paramsJob;
	}

	public void setParamsJob(Hashtable paramsJob) {
		this.paramsJob = paramsJob;
	}

	public String getSchema() {
		return schema;
	}

	public void setSchema(String schema) {
		this.schema = schema;
	}

	public String getType_job() {
		return type_job;
	}

	public void setType_job(String type_job) {
		this.type_job = type_job;
	}

	public UserBip getUserBip() {
		return userBip;
	}

	public void setUserBip(UserBip userBip) {
		this.userBip = userBip;
	}

}
