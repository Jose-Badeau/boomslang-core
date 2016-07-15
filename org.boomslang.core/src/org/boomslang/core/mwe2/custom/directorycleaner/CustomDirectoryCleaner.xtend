package org.boomslang.core.mwe2.custom.directorycleaner

import java.io.File
import java.util.Collection
import java.util.HashSet
import org.eclipse.emf.mwe.utils.DirectoryCleaner

class CustomDirectoryCleaner extends DirectoryCleaner {

	private final Collection<File> customExcludes = new HashSet<File>();

	override addExclude(String exclude) {
		super.addExclude(exclude)
		//Wrap exluded path into a file to make comparison OS independent
		customExcludes += new File(exclude)
	}

	override isExcluded(File path) {
		if (!super.isExcluded(path)) {
			return customExcludes.filter[path.path.startsWith(it.path)].size > 0
		}
		return false;
	}
	
	override cleanFolder(String path){
		var f = new File(path);
		if (!f.exists()){
			return	
		}
		super.cleanFolder(path)
	}

}
