package org.boomslang.core.contentassist

import org.boomslang.core.services.JavaProjectFolderUtil
import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject

class CoreProposalProvider {
    @Inject extension JavaProjectFolderUtil

    def String completeBPackage_Name(EObject model) {
        if (model == null) {
            return ""
        }
        val currentFullPath = model.eResource.IResource.fullPath
        val srcPaths = model.getSrcPaths
        if (srcPaths.nullOrEmpty) {
            return ""
        }

        // check which src path this model element is in
        for (srcPath : srcPaths) {
            if (currentFullPath.toString.startsWith(srcPath.toString)) {
                val suggestedPath = currentFullPath.removeFirstSegments(srcPath.segmentCount).removeLastSegments(1).
                    toString
                val suggestedPackageName = suggestedPath.replaceAll("/", ".")
                return suggestedPackageName
            }
        }
    }
}
