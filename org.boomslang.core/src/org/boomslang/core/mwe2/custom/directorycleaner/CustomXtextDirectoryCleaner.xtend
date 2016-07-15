package org.boomslang.core.mwe2.custom.directorycleaner

import com.google.inject.Inject
import com.google.inject.Injector
import java.io.File
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.xtext.generator.XtextDirectoryCleaner
import org.eclipse.xtext.xtext.generator.model.project.IXtextProjectConfig

class CustomXtextDirectoryCleaner extends XtextDirectoryCleaner {
	
	@Inject IXtextProjectConfig config

	@Accessors(PUBLIC_SETTER)
	boolean enabled = true
	@Accessors(PUBLIC_SETTER)
	boolean useDefaultExcludes = true
	
	List<String> excludes = newArrayList
	List<String> extraDirectories = newArrayList

	override void addExtraDirectory(String directory) {
		extraDirectories += directory
	}

	override void addExclude(String exclude) {
		excludes += exclude
	}

	override void clean() {
		if (!enabled)
			return;
			
		val directories = newArrayList
		directories += (config.enabledProjects.map[srcGen] + #[config.runtime.ecoreModel]).filterNull.map[path].filter[new File(it).isDirectory]
		directories += extraDirectories
		
		val delegate = new CustomDirectoryCleaner
		delegate.useDefaultExcludes = useDefaultExcludes
		excludes.forEach[delegate.addExclude(it)]

		directories.forEach[delegate.cleanFolder(it)]
	}
	
	override initialize(Injector injector) {
		injector.injectMembers(this)
	}
}
		