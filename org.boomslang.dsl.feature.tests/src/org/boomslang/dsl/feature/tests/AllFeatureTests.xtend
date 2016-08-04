package org.boomslang.dsl.feature.tests

import org.boomslang.dsl.feature.tests.formatter.FormatterTest
import org.eclipse.xtext.junit4.InjectWith
import org.junit.runner.RunWith
import org.junit.runners.Suite

@InjectWith(typeof(FeatureInjectorProviderCustom))
@RunWith(Suite)
@Suite.SuiteClasses(#[FeatureParsingTest,FormatterTest])
class AllFeatureTests {
}
