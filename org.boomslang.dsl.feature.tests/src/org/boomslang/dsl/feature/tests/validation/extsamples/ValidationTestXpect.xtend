package org.boomslang.dsl.feature.tests.validation.extsamples

import org.eclipse.xtext.XtextStandaloneSetup
import org.junit.runner.RunWith
import org.xpect.runner.XpectRunner
import org.xpect.runner.XpectTestFiles
import org.xpect.setup.XpectSetup
import org.xpect.xtext.lib.setup.XtextWorkspaceSetup

@RunWith(XpectRunner)
@XpectSetup( #[ XtextStandaloneSetup, XtextWorkspaceSetup ])
@XpectTestFiles(fileExtensions=#["feature"])
class ValidationTestXpect {
	// test whether Xpect picked up the registration from plugin.xml correctly with 
	// IEmfFileExtensionInfo.Registry.INSTANCE.toString()
}