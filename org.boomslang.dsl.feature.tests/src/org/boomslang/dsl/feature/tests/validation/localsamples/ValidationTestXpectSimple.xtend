package org.boomslang.dsl.feature.tests.validation.localsamples

import org.junit.runner.RunWith
import org.xpect.runner.XpectRunner
import org.xpect.runner.XpectTestFiles
import org.xpect.xtext.lib.tests.ValidationTest

@RunWith(XpectRunner)
// TODO activated XpectSetup -> validation tests not working
// @XpectSetup( #[ XtextStandaloneSetup,XtextWorkspaceSetup])
    
@XpectTestFiles(fileExtensions=#["feature"])
class ValidationTestXpectSimple extends ValidationTest {

	// test whether Xpect picked up the registration from plugin.xml correctly with 
	// IEmfFileExtensionInfo.Registry.INSTANCE.toString()

}
