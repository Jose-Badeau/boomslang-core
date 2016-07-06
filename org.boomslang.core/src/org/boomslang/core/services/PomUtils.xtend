package org.boomslang.core.services

import org.boomslang.core.BNamedModelElement
import com.google.inject.Inject
import java.io.File
import java.util.List
import java.util.jar.JarFile
import java.util.regex.Pattern
import org.apache.maven.model.Model
import org.apache.maven.model.io.xpp3.MavenXpp3Reader
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ExtensibleURIConverterImpl

/**
 * This class provides functionality related to extracting pom.xml information
 */
class PomUtils {

    @Inject ExtensibleURIConverterImpl uriconverter
    
    @Inject MavenXpp3Reader mavenXpp3Reader
	
	/**
	 * @return The URI of the pom.xml file related to the input parameter (which is for a example a model element in an Eclipse Maven project),
	 * or {@code null} if it could not be found
	 */
	def dispatch URI getMavenPomUri(BNamedModelElement modelElement) {
		if (modelElement.eResource == null) {
			return null
			// throw new Exception('The model element ' + modelElement + ' is not contained in a EMF resource, can not retrieve its Maven version.')
		}
		val uriCandidate = modelElement.eResource.URI
		if (uriCandidate == null) {
			return null
			// throw new Exception('URI for EMF Resource ' + modelElement.eResource + 'was null.')
		}
		uriCandidate.mavenPomUri
	}
	
	def dispatch URI getMavenPomUri(URI uri) {
		val trimmedUri = uri.trimFragment
		if (trimmedUri.archive) {
			return trimmedUri.trimSegments(trimmedUri.segmentCount).getPomUriFromArchiveUri				
		} else {
			return trimmedUri.getPomUriFromNonArchiveUri
		}
	}
	
	/**
	 * Recursive method to search for maven version info given an uri.<p> 
	 * 
	 * @param uri - uri (no trailing fragments "#fragment") to use for search for 
	 * maven artifacts to extract maven version
	 */
	def protected getPomUriFromNonArchiveUri(URI uri) {
		for (i : 0..uri.segmentCount) {
			val candidateUri = uri.trimSegments(i).appendSegment("pom.xml")
			if (uriconverter.exists(candidateUri, newHashMap)) {
				return candidateUri
			}
		}
		return null
		// throw new Exception('Not successful in extracting a pom.xml uri from model uri ' + uri)
	}
	
	def protected getPomUriFromArchiveUri(URI archiveUri) {
		if (!archiveUri.archive) {
			throw new Exception('Expected an archive URI, but got ' + archiveUri)
		}
		val pat = "(?:archive:)?file:(/[^!]*)!/?" 
		val matcher = Pattern::compile(pat).matcher(archiveUri.toString)
		if (!matcher.matches) { 
			throw new Exception('Expected an archive uri that matches ' + pat + ', but got ' + archiveUri)
		}
		val file = new File(matcher.group(1))
		if (!file.exists) {
			throw new Exception('Archive file does not exist: ' + file + '\n archive URI was ' + archiveUri)
		}
		val jarfile = new JarFile(file)
		val entries = jarfile.entries
		while (entries.hasMoreElements) {
			val entry = entries.nextElement
			if (entry.name.endsWith('/pom.xml')) {
				return URI::createURI('archive:' + URI::createFileURI(file.absolutePath) + '!/' + entry.name)
			}
		}
		return null
		// throw new Exception('Version collector could not extract version from archive ' + file)
	}
	
	/**
	 * For a given model element, locates the pom.xml and returns the registered src-paths,
	 * or an empty list if no source paths could be found.<p/>
	 * 
	 * Implementation note:
	 * Currently, only one source path is computed, the one inside the <build>-tag
	 * TODO the src folders added with 
	 * http://mojo.codehaus.org/build-helper-maven-plugin/add-source-mojo.html
	 * should also be considered
	 */
	def List<URI> getMvnSrcUris(BNamedModelElement it) {
		mavenPomUri.mvnSrcUris
	}
	
	/**
	 * Currently, only "platform:/"-uris are supported
	 */
	def List<URI> getMvnSrcUris(URI it) {
		val result = <URI>newArrayList() 
		if (!it.platform) {
			return result
		}
		val pomUri = mavenPomUri
		if (!pomUri.platform) {
			return result
		}
		val inputStream = uriconverter.createInputStream(mavenPomUri)
		val Model model = mavenXpp3Reader.read(inputStream)
		val srcDir = model?.build?.sourceDirectory
		if (srcDir != null) {
		   result.add(pomUri.trimSegments(1).appendSegments(srcDir.split("/")))
		}
		val srcTestDir = model?.build?.testSourceDirectory
		if (srcTestDir != null) {
			result.add(pomUri.trimSegments(1).appendSegments(srcDir.split("/")))
		}
		return result
	}
}