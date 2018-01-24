package com.socgen.bip.db;

public class IdLineIdentification {

	private String idline;
	private String idStep;
	private String idTask;
	private String idSubTask;

	public IdLineIdentification(String idline, String idStep, String idTask, String idSubTask) {
		this.idline = idline;
		this.idStep = idStep;
		this.idTask = idTask;
		this.idSubTask = idSubTask;
	}

	public IdLineIdentification(String idline) {
		this.idline = idline;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((idStep == null) ? 0 : idStep.hashCode());
		result = prime * result + ((idSubTask == null) ? 0 : idSubTask.hashCode());
		result = prime * result + ((idTask == null) ? 0 : idTask.hashCode());
		result = prime * result + ((idline == null) ? 0 : idline.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		IdLineIdentification other = (IdLineIdentification) obj;
		if (idStep == null) {
			if (other.idStep != null)
				return false;
		} else if (!idStep.equals(other.idStep))
			return false;
		if (idSubTask == null) {
			if (other.idSubTask != null)
				return false;
		} else if (!idSubTask.equals(other.idSubTask))
			return false;
		if (idTask == null) {
			if (other.idTask != null)
				return false;
		} else if (!idTask.equals(other.idTask))
			return false;
		if (idline == null) {
			if (other.idline != null)
				return false;
		} else if (!idline.equals(other.idline))
			return false;
		return true;
	}

}
