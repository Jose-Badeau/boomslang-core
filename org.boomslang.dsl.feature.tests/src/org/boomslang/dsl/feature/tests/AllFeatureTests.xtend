package org.boomslang.dsl.feature.tests

import org.boomslang.dsl.feature.tests.formatter.FormatterTest
import org.boomslang.dsl.feature.tests.parser.ParseTest
import org.junit.runner.RunWith
import org.junit.runners.Suite

@RunWith(Suite)
@Suite.SuiteClasses(#[FormatterTest, ParseTest])
class AllFeatureTests {
}
