package org.boomslang.dsl.feature.scoping

import org.boomslang.dsl.feature.feature.BParameter
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName
import org.boomslang.dsl.feature.feature.BScenario
import com.wireframesketcher.model.Item

class FeatureQualifiedNameProvider extends DefaultDeclarativeQualifiedNameProvider {
	
	/**
	 * Like in SQL, parameters are referenced with a leading "@"-sign 
	 * This (better) differentiates them from literal strings
	 */
	def QualifiedName qualifiedName(BParameter bParam) {
		if (bParam == null || bParam.name.nullOrEmpty) {
			return null
		}
		val paramQName = QualifiedName.create("@" + bParam.name); 
		return paramQName.prefixWithParentName(bParam);  
	}
	
	/**
	 * Replace spaces with underscores ("_") in qualified names of scenarios 
	 */
	def QualifiedName qualifiedName(BScenario bScenario) {
		if (bScenario == null || bScenario.name.nullOrEmpty) {
			return null
		}
		val qName = QualifiedName.create(bScenario.name.replaceAll("\\s", "_").replaceAll('''^"''', "").
			replaceAll('''"$''',""))
		return qName.prefixWithParentName(bScenario);
	}
	
	/**
	 * Returns the simple name of a tab, or - if not set - a name derived from the tab items display text.
	 * This avoids importing qualified names for tabs. Tabs are used only in the context of a tabbed pane.
	 * Using the item text property allows leaving the name null, as the default WFS screen editor does not support editing the name.
	 */
	def QualifiedName simpleName(Item tabItem) {
		var itemName = tabItem.name
		if (itemName == null) {
			itemName = tabItem.text.replaceAll("\\s", "_").replaceAll('''^"''', "").replaceAll('''"$''',"")
		}
		val qName = QualifiedName.create(itemName)
		return qName;
	}
	
	
	/**
	 * Prefixes the given qualifiedName with the fully qualified name of the
	 * first parent that has a fully qualified name.
	 */
	def QualifiedName prefixWithParentName(QualifiedName baseQualifiedName, EObject base) {
		var EObject temp = base;
		while (temp.eContainer() != null) {
			temp = temp.eContainer();
			val QualifiedName parentsQualifiedName = getFullyQualifiedName(temp);
			if (parentsQualifiedName != null) {
						return parentsQualifiedName.append(baseQualifiedName);
			}
		}
	}
	
	
}