package org.boomslang.generator.interfaces

import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.generator.IFileSystemAccess

interface IBoomAggregateGenerator extends org.boomslang.generator.interfaces.IBoomGenerator {

	def void doGenerate(ResourceSet input, IFileSystemAccess fsa)	

} 