package org.boomslang.dsl.mapping.tests

import org.boomslang.dsl.mapping.tests.MappingInjectorProvider
import com.google.inject.Injector
import org.boomslang.wireframesketcher.model.xtext.BoomslangWFSModelResourceFactory
import org.boomslang.wireframesketcher.model.xtext.ScreenEmfSupport
import org.eclipse.emf.ecore.resource.Resource
import org.boomslang.wireframesketcher.model.xtext.ScreenStandaloneSetupGenerated

class MappingInjectorProviderCustom extends MappingInjectorProvider {

	override protected Injector internalCreateInjector() {
		new ScreenEmfSupport().preInvoke()
		new ScreenStandaloneSetupGenerated().createInjectorAndDoEMFRegistration
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("screen", new BoomslangWFSModelResourceFactory())
	    super.internalCreateInjector()
	}
	
}