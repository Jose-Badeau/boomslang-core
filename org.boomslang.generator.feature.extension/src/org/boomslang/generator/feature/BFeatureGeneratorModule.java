package org.boomslang.generator.feature;

import org.eclipse.xtext.service.AbstractGenericModule;

import org.boomslang.generator.extensionpoint.BGeneratorContributionHandler;
import org.boomslang.generator.interfaces.IBoomGenerator;


public class BFeatureGeneratorModule extends AbstractGenericModule {
	
	/**
	 * Custom generator
	 */
	public Class<? extends org.eclipse.xtext.generator.IGenerator> bindIGenerator() {
		Class<? extends IBoomGenerator> candidate = new BGeneratorContributionHandler()
				.getCustomFeatureGeneratorOrNull();
		if (candidate != null) {
			return candidate;
		}
		return null;
	}
}
