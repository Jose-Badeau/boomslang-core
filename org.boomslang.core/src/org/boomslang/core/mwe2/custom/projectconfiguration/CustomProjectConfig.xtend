package org.boomslang.core.mwe2.custom.projectconfiguration

import java.util.List
import org.eclipse.xtext.xtext.generator.model.project.StandardProjectConfig
import org.eclipse.xtext.xtext.generator.model.project.SubProjectConfig

/**
 * Used by mwe2 Workflow from Feature and Mapping DSL. Only put in this project because the xtend-gen folder is cleaned before every maven build.
 * Thereby, also the CustomProjectConfig.java is deleted and the mwe2 Workflow fails. Besides that the implementation is completely the same
 * for Feature and Mapping DSL and can therefore be re-used.
 */
class CustomProjectConfig extends StandardProjectConfig { 
	 
	List<SubProjectConfig> additionalProjects=newArrayList
	
	override getAllProjects() {
		val allProjects = newArrayList
		allProjects += super.allProjects 
		allProjects+=additionalProjects
		return allProjects  
	}
	
	def addSubProject(SubProjectConfig subProjectConfig){
		additionalProjects+=subProjectConfig	
	}
	
}
