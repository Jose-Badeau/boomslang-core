/*
 * generated by Xtext 2.10.0
 */
package org.boomslang.dsl.feature.tests

import org.boomslang.core.BPackage
import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(FeatureInjectorProvider)
class FeatureParsingTest{

	@Inject
	ParseHelper<BPackage> parseHelper

	@Test 
	def void loadModel() {
		val result = parseHelper.parse('''
			Hello Xtext!
		''')
		Assert.assertNotNull(result)
	}
 
}