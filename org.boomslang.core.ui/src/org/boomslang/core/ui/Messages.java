package org.boomslang.core.ui;


import org.eclipse.osgi.util.NLS;

public class Messages extends NLS {
	private static final String BUNDLE_NAME = "org.boomslang.geb.ui.messages"; //$NON-NLS-1$

	public static String ContainerPageName;

	public static String ContainerPageTitle;

	public static String ContainerPageDesc;

	static {
		// initialize resource bundle
		NLS.initializeMessages(BUNDLE_NAME, Messages.class);
	}

	private Messages() {
	}
}
