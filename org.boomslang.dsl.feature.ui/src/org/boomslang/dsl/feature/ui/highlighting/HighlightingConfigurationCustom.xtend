package org.boomslang.dsl.feature.ui.highlighting

import org.eclipse.swt.graphics.RGB
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfigurationAcceptor

class HighlightingConfigurationCustom extends DefaultHighlightingConfiguration {

	public static val String ANNOTATION_STYLE = "ANNOTATION_STYLE"

	override public void configure(IHighlightingConfigurationAcceptor acceptor) {
		super.configure(acceptor)
		acceptor.acceptDefaultHighlighting(ANNOTATION_STYLE, ANNOTATION_STYLE, annotationTextStyle)
	}

	def annotationTextStyle() {
		defaultTextStyle.copy => [
			color = new RGB(0x7d, 0x7d, 0x7d)
		]
	}

}
