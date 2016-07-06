package org.boomslang.generator.mapping;

import org.eclipse.xtext.service.AbstractGenericModule;

import org.boomslang.generator.extensionpoint.BGeneratorContributionHandler;
import org.boomslang.generator.interfaces.IBoomGenerator;

public class BMappingGeneratorModule extends AbstractGenericModule {
	public Class<? extends org.eclipse.xtext.generator.IGenerator> bindIGenerator() {
		Class<? extends IBoomGenerator> candidate = new BGeneratorContributionHandler()
				.getCustomMappingGeneratorOrNull();
		if (candidate != null) {
			return candidate;
		}
		return null;
	}
}
