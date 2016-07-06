package org.boomslang.core;

import org.eclipse.core.runtime.ILog;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Platform;
import org.eclipse.core.runtime.Status;

public class Logger {

	public static final int OK = IStatus.OK;

	public static final int ERROR = IStatus.ERROR;

	public static final int CANCEL = IStatus.CANCEL;

	public static final int INFO = IStatus.INFO;

	public static final int WARNING = IStatus.WARNING;

	private static ILog log;

	static {
		log = Platform.getLog(Platform.getBundle(Activator.PLUGIN_ID));
	}

	public static void log(int severity, Throwable e) {
		Status s = new Status(severity, Activator.PLUGIN_ID, IStatus.OK,
				e.getMessage(), e);
		log.log(s);
	}

	public static void log(int severity, String msg) {
		Status s = new Status(severity, Activator.PLUGIN_ID, IStatus.OK, msg,
				null);
		log.log(s);
	}

}
