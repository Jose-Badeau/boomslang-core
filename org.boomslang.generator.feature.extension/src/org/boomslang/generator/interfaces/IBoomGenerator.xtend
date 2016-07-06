package org.boomslang.generator.interfaces

import org.eclipse.xtext.generator.IGenerator
 
/**
 * This is the generator interface for Boomslang web test projects.
 */
interface IBoomGenerator extends IGenerator {
	
	/**
	 * This method returns a short description for a generator. 
	 * 
	 * The generator may use it in generated files so that an end user 
	 * may see which generator produced the file.
	 * 
	 * @return a short description of this generator, suitable for 
	 * inclusion in comments of generated files
	 */
	def CharSequence getShortDescription() 
	
}