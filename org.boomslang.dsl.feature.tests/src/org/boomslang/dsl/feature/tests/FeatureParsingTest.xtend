/*
 * generated by Xtext 2.10.0
 */
package org.boomslang.dsl.feature.tests

import com.google.inject.Inject
import org.boomslang.dsl.feature.feature.BFeaturePackage
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.resource.XtextResourceSet
import org.junit.Test
import org.junit.runner.RunWith

import org.eclipse.emf.common.util.URI
import org.eclipse.xtext.junit4.AbstractXtextTests

@RunWith(XtextRunner)
@InjectWith(FeatureInjectorProviderCustom)
class FeatureParsingTest extends AbstractXtextTests{

	@Inject
	extension ParseHelper<BFeaturePackage> parser

	@Inject
	extension ValidationTestHelper

	@Inject
	XtextResourceSet xtextResourceSet

	@Test
	def void testParseMinimalSample() {
		'feature/samples/Minimal.feature'.readFileIntoString().parse().assertNoErrors
	}

	@Test
	def void testInvalid() {
		val issues = 'feature/samples/Invalid.feature'.readFileIntoString.parse.validate
		assertEquals(1, issues.size)
		assertTrue(issues.get(0).message.contains("mismatched input '<EOF>' expecting"))
	}
	
	@Test
	def void testFormSimpleReferences(){
		xtextResourceSet.loadScreen("screen/Simple.screen")
		'feature/samples/Simple.feature'.readFileIntoString().parse(xtextResourceSet).assertNoErrors
	}
	
	@Test
	def void testFormInComponentReferences(){
		xtextResourceSet.loadScreen("SimpleComponent.screen")
		'feature/samples/SimpleComponent.feature'.readFileIntoString().parse(xtextResourceSet).assertNoErrors
	}
	
	@Test
	def void testFormInReusedComponentReferences(){
		xtextResourceSet.loadScreen("SimpleComponent.screen")
		xtextResourceSet.loadScreen("screen/UseSimpleComponent.screen")
		'feature/samples/UseSimpleComponent.feature'.readFileIntoString().parse(xtextResourceSet).assertNoErrors
	}
	
	@Test
	def void testFormInMultipleReusedComponentsReferences(){
		xtextResourceSet.loadScreen("SimpleComponent.screen")
		xtextResourceSet.loadScreen("SimpleContactComponent.screen")
		xtextResourceSet.loadScreen("screen/MultiComponent.screen")
		'feature/samples/MultiComponent.feature'.readFileIntoString().parse(xtextResourceSet).assertNoErrors
	}
	
	/**
	 * Name with pending .screen
	 */
	def loadScreen(XtextResourceSet xtextResourceSet, String name) {
		xtextResourceSet.getResource(URI.createURI("classpath:/"+name), true).load(null)
	}


}
