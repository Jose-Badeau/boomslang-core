package org.boomslang.dsl.feature.tests.parser

import org.boomslang.dsl.feature.feature.BFeaturePackage
import org.boomslang.dsl.feature.tests.FeatureInjectorProviderCustom
import com.google.inject.Inject
import org.eclipse.emf.common.util.URI
import org.eclipse.xtext.junit4.AbstractXtextTests
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.resource.XtextResourceSet
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(FeatureInjectorProviderCustom))
class ParseTest extends AbstractXtextTests {

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
	def void testParseMaxSample() {
		xtextResourceSet.loadLoginScreen()
		'feature/samples/Login.feature'.readFileIntoString().parse(xtextResourceSet).assertNoErrors
	}

	@Test
	def void testInvalid() {
		val issues = 'feature/samples/Invalid.feature'.readFileIntoString.parse.validate
		assertEquals(1, issues.size)
		assertTrue(issues.get(0).message.contains("mismatched input '<EOF>' expecting"))
	}
	
	def loadLoginScreen(XtextResourceSet xtextResourceSet) {
		xtextResourceSet.getResource(URI.createURI("classpath:/screen/Login.screen"), true).load(null)
	}

}
