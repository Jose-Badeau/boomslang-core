package org.boomslang.dsl.feature.tests

import org.boomslang.dsl.feature.tests.parser.ParseTest
import org.junit.runner.RunWith
import org.junit.runners.Suite
import org.eclipse.xtext.junit4.InjectWith
import org.boomslang.dsl.feature.tests.formatter.FormatterTest

@InjectWith(typeof(FeatureInjectorProviderCustom))
@RunWith(Suite)
@Suite.SuiteClasses(#[ParseTest,FormatterTest])
class AllFeatureTests {
}
