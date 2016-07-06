package org.boomslang.core.services

import java.util.List
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.Path
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.jdt.core.IJavaProject
import org.eclipse.jdt.core.IPackageFragmentRoot
import org.eclipse.jdt.core.JavaCore

/**
 * Convenience methods for getting the source folders in a Java project
 */
class JavaProjectFolderUtil {

	/**
	 * @return the root paths of source folders in the Java project where
	 * the resource of {@code object} is located. If the {@code object} is not
	 * located in an Eclipse project with the Java nature, it returns an empty list.
	 *   
	 */
	def List<IPath> getSrcPaths(EObject object) {
		val result = <IPath>newArrayList
		val eclipseResource = object.eResource.getIResource()
		val project = eclipseResource?.project
		if (!project.isNatureEnabled("org.eclipse.jdt.core.javanature")) {
			return result
		}
		val IJavaProject javaProject = JavaCore.create(project)
		return javaProject.packageFragmentRoots.filter[kind == IPackageFragmentRoot.K_SOURCE].map[
			correspondingResource.fullPath].toList

	}

	/**
	 * Copied from code under EPL:
	 * http://dev.eclipse.org/svnroot/modeling/org.eclipse.mdt.papyrus/trunk/sandbox/Moka/org.eclipse.papyrus.moka/src/org/eclipse/papyrus/moka/debug/MokaBreakpoint.java
	 * 
	 * Convenience method returning the IResource corresponding to a Resource
	 * 
	 * @param resource The Resource from which the corresponding IResource has to be retrieved
	 * @return the IResource corresponding to the Resource
	 */
	def public IResource getIResource(Resource resource) {
		if (resource == null)
			return null;
		val String uriPath = resource.getURI().toPlatformString(true);
		if (uriPath == null) // FIXME this is not a Platform scheme
			return null;
		val IResource iresource = ResourcesPlugin.getWorkspace().getRoot().getFile(new Path(uriPath));
		if (iresource != null) {
			if (iresource.exists()) {
				return iresource;
			}
		}
		return null;
	}

}
