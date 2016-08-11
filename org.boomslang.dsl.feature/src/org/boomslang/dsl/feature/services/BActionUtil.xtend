package org.boomslang.dsl.feature.services

import org.boomslang.dsl.feature.feature.BCommandAction
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2

class BActionUtil {
	def isCommandActionContext(EObject element){
		EcoreUtil2.getContainerOfType(element,BCommandAction)!=null
	}
	
	def isAssertionActionContext(EObject element){
		EcoreUtil2.getContainerOfType(element,BCommandAction)!=null
	}
}