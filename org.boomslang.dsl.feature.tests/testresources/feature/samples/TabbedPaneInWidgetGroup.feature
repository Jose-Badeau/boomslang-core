package feature.samples

import org.simple.TabbedPaneInWidgetGroupComp
import org.simple.TabbedPaneInWidgetGroupComp.TabbedPane3
import org.simple.TabbedPaneInWidgetGroupComp.TabbedPane3.*
import screen.parts.tabbedpaneingroup.FirstTab
import screen.parts.tabbedpaneingroup.SecondTab


Feature TabbedPaneInWidgetGroup
	As a "Tester"
	I want to "Make sure that the grammar works with tabbed panes even if they are inside a widget group in the component"
	In order to "ensure that the language is ok"


	Scenario "Select a tab in a tabbed pane that is inside a widget group"
		Given I am on the TabbedPaneInWidgetGroupComp ::FirstTab screen
		when I from the TabbedPane3 tabbedpane I select the Second_Tab tab
		and I from the Toggle button I click
		then I am on the SecondTab screen 
		then the TabbedPane3 tabbedpane selected tab is Second_Tab tab
		
	
//		Given I am on the TabbedPaneInWidgetGroupComp :: FirstTab screen
//		when I from the TabbedPane3 tabbedpane I select the Second_Tab tab
//		and I from the Toggle button I click  
//		then the TabbedPane3 tabbedpane selected tab is Second_Tab tab 
