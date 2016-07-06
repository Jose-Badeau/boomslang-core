package org.boomslang.core.container;

import java.util.Collection;
import java.util.Iterator;

import org.eclipse.core.runtime.IPath;
import org.eclipse.jdt.core.IClasspathEntry;
import org.eclipse.jdt.core.JavaCore;

public class ContainerUtils {

	public static IClasspathEntry createClasspathContainer(IPath containerId, String hint, Collection<String> selectedLibs) {
		IPath path = containerId;
		path = path.append(collectionToCommaString(selectedLibs));
		if (hint != null)
			path = path.append(hint);
		return JavaCore.newContainerEntry(path);
	}

	public static String collectionToCommaString(Collection<String> bundleSelection) {
		StringBuffer stringBuffer = new StringBuffer();
		for (Iterator<String> it = bundleSelection.iterator(); it.hasNext();) {
			if (stringBuffer.length() > 0)
				stringBuffer.append(",");
			stringBuffer.append(it.next().toString());
		}
		return stringBuffer.toString();
	}

}
