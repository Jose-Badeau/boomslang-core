/*
 * generated by Xtext
 */
package org.boomslang.dsl.feature.scoping

import com.google.inject.Inject
import com.wireframesketcher.model.Screen
import org.boomslang.dsl.feature.feature.BComboWrapper
import org.boomslang.dsl.feature.feature.BScenario
import org.boomslang.dsl.feature.feature.BWidgetWrapper
import org.boomslang.dsl.feature.feature.FeaturePackage
import org.boomslang.dsl.feature.services.WidgetTypeRefUtil
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import org.eclipse.xtext.scoping.impl.FilteringScope

/**
 * This class contains custom scoping description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#scoping
 * on how and when to use it 
 *
 */
class FeatureScopeProvider extends AbstractDeclarativeScopeProvider {

	@Inject extension WidgetTypeRefUtil

	def IScope scope_BStringOrParam_param(EObject ctx, EReference ref) {
		allowParamOfParentScenario(ctx, ref)
	}
	
	def IScope scope_BIntOrParam_param(EObject ctx, EReference ref) {
		allowParamOfParentScenario(ctx, ref)
	}

	def IScope scope_BIntOrStringOrParam_param(EObject ctx, EReference ref) {
		allowParamOfParentScenario(ctx, ref)
	}

	def IScope scope_BWidgetWrapper_widget(BWidgetWrapper ctx, EReference ref) {
		allowElementsInItsBWidgetContainer(ctx, ref)
	}

	def IScope scope_BWidgetWrapper_widget(EObject ctx, EReference ref) {
		allowElementsInItsBWidgetContainer(ctx, ref)
	}

	def IScope scope_BComboWrapper_list(BComboWrapper ctx, EReference ref) {
		allowElementsInItsBWidgetContainer(ctx, ref)
	}

	def IScope scope_BComboWrapper_list(EObject ctx, EReference ref) {
		allowElementsInItsBWidgetContainer(ctx, ref)
	}
	
	def IScope scope_BTreeWrapper_tree(EObject ctx, EReference ref) {
		allowElementsInItsBWidgetContainer(ctx, ref)
	}

	/**
	 * Elements in the DSL may 
	 * 1) be contained inside of BWidgetContainers and 
	 * 2) reference wireframe model elements
	 * If that is the case, only wireframe model elements of the WidgetContainer of the BWidgetContainer are allowed.
	 * If the BWidgetContainer does not reference any WidgetContainer, the BWidgetContainer of the BWidgetContainer
	 * will be checked (e.g. a BPostCondition (a BWidgetContainer) is contained in BTestCode (also a BWidgetContainer).
	 * 
	 * This method filters the default scope containing wireframe model elements so that only model elements are allowed 
	 * that have the same WidgetContainer as the given dslObject.
	 * Same
	 * @param dslObject - an object in the DSL that is contained (directly or indirectly) in a BWidgetContainer
	 * @param ref - the dslObject's reference to a wireframe model element
	 */
	def IScope allowElementsInItsBWidgetContainer(EObject dslObject, EReference ref) {
		val originalScope = delegateGetScope(dslObject, ref)
		
		//TODO make the widgetContainerOfNearestContext method return a list. 
		val allowedWidgetContainer = dslObject.widgetContainerOfNearestContext

		if (allowedWidgetContainer == null) {
			return IScope.NULLSCOPE
		}

		return new FilteringScope(originalScope,
			[ candidate |
				val objectOrProxy = candidate.EObjectOrProxy
				val EObject candidateEObject = if (objectOrProxy.eIsProxy) {
						EcoreUtil.resolve(objectOrProxy, dslObject);
					} else {
						objectOrProxy
					}
				val candidateContainer = EcoreUtil2.getContainerOfType(candidateEObject, Screen)
				return  allowedWidgetContainer.contains(candidateContainer)
			])
	}

	/**
	 * In a scenario (e.g. in commands or assertions), params may be referenced. Only params
	 * of the scenario should be referenceable, and not params of other scenarios. 
	 * 
	 * @return a scope containing all parameters of a scenario that is the parent of the given {@code dslObject}
	 * 
	 * @param dslObject - an object in the DSL that is contained (directly or indirectly) in a BWidgetContainer
	 * @param ref - the dslObject's reference to a wireframe model element
	 */
	def IScope allowParamOfParentScenario(EObject dslObject, EReference ref) {
		val originalScope = delegateGetScope(dslObject, ref)

		val parentScenario = EcoreUtil2.getContainerOfType(dslObject, BScenario)
		if (parentScenario == null) {
			return IScope.NULLSCOPE
		}
		return new FilteringScope(originalScope,
			[ candidate |
				val objectOrProxy = candidate.EObjectOrProxy
				val EObject candidateEObject = if (objectOrProxy.eIsProxy) {
						EcoreUtil.resolve(objectOrProxy, dslObject);
					} else {
						objectOrProxy
					}
				return candidate.EClass == FeaturePackage.Literals.BPARAMETER &&
					candidateEObject.eContainer() == parentScenario
			])

	}

}