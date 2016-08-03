package org.boomslang.dsl.feature.tests.formatter

import org.boomslang.dsl.feature.FeatureStandaloneSetup
import org.boomslang.dsl.feature.feature.BFeaturePackage
import org.boomslang.dsl.feature.tests.FeatureInjectorProviderCustom
import com.google.inject.Inject
import org.eclipse.xtext.formatting.INodeModelFormatter
import org.eclipse.xtext.junit4.AbstractXtextTests
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.resource.XtextResource
import org.junit.Ignore
import org.junit.Test
import org.junit.runner.RunWith

/**
 * Simple class to test formatting
 * The test files must be on the classpath
 */
@RunWith(XtextRunner)
@InjectWith(FeatureInjectorProviderCustom)
class FormatterTest extends AbstractXtextTests {

//	@Inject
//	protected Provider<XtextResourceSet> resourceSetProvider

	@Inject
	extension INodeModelFormatter formatter

	@Inject
	extension ParseHelper<BFeaturePackage> featureParser

	override void setUp() throws Exception {
		super.setUp()
		with(new FeatureStandaloneSetup)
	}

	/**
     * Formatter test
     */
    @Ignore("Difficulties with Xtext formatter because of wiki-like syntax (rule that parses everything until newline)")
	@Test def public void testComponentFormatter() {
		val String expected = "LoginFeature1Scenario.formatted.feature".readFileIntoString
		val model = "LoginFeature1Scenario.formatted.feature".readFileIntoString.parse
		val rootNode = (model.eResource as XtextResource).parseResult.rootNode
		val String actual = rootNode.format(0, rootNode.totalLength).formattedText
		assertEquals("Formatting is different", expected, actual);
	}

}
