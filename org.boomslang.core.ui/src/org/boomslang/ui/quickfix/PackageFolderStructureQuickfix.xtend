package org.boomslang.ui.quickfix

import org.boomslang.core.BPackage
import org.boomslang.core.validation.PackageFolderStructureValidator
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.Path
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.ui.editor.model.edit.IModificationContext
import org.eclipse.xtext.ui.editor.quickfix.IssueResolutionAcceptor
import org.eclipse.xtext.validation.Issue

class PackageFolderStructureQuickfix {

	/**
	 * Provides solutions to align the declared package name with the folder structure
	 * that the data type declaration is located in.
	 */
	def public void alignPackageAndFolder(Issue issue, IssueResolutionAcceptor acceptor) {
		verifyIssueCode(issue)
		
		val suggestedName = issue.getData()?.get(0)
		val currentPathString = issue.getData()?.get(1)
		val suggestedPathString = issue.getData()?.get(2)
		
		// rename package declaration in file
		val msgPack = "Rename package declaration"
		val descPack = "Rename package to '" + suggestedName + "'"
		acceptor.accept(issue, msgPack, descPack, "package_obj.gif",
			[ EObject element, IModificationContext context |
				val pack = element as BPackage
				pack.name = suggestedName
			],2)

		val workspaceRoot = ResourcesPlugin.getWorkspace().getRoot()

		val IPath currentPath = new Path(currentPathString)
		val IFile currentFile = workspaceRoot.getFile(currentPath)

		val IPath suggestedPath = new Path(suggestedPathString)
		val IFile suggestedFile = workspaceRoot.getFile(suggestedPath)

		val msgFile = "Move file"
		val descFile = '''
		Move file «currentPath.lastSegment» to 
		to folder '«suggestedFile.projectRelativePath»'«»'''

		acceptor.accept(issue, msgFile, descFile, "correction_move.gif",
			[ EObject element, IModificationContext context |
				//Make sure that the target path exists
				val targetFolder = workspaceRoot.getFolder(suggestedPath.removeLastSegments(1))
				targetFolder.createFolderWithParents
				currentFile.move(suggestedFile.fullPath, true, true, null)
				if (currentFile.parent.members.empty) {
					currentFile.parent.delete(false, null)
				}
			],1)
	}

	/**
	 * create a folder and make parent folder if needed
	 */
	def void createFolderWithParents(IFolder folder) {
		val parent = folder.parent
		switch parent {
			IFolder: createFolderWithParents(parent)
		}
		if (!folder.exists) {
			folder.create(true, true, null)
		}
	}

	/**
	 * Throws an exception if issue code is not the one for package folder structure issues 
	 */
	def protected verifyIssueCode(Issue issue) {
		if (issue.code != PackageFolderStructureValidator::PACKAGE_FOLDER_STRUCTURE) {
			throw new Exception(
				"Quickfix for PackageFolderStructureValidator::PACKAGE_FOLDER_STRUCTURE" +
					" invoked with issue that has code " + issue.code)
		}

	}

}
