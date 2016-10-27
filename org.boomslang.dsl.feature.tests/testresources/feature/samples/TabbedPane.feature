package feature.samples
import org.simpleA
import org.simpleA.TabbedPaneComp
import parts.simple.SimpleTab2
import org.simpleA.TabbedPaneComp.TabbedPaneSimple.*
import parts.simple2.SimpleTab1


Feature TabbedPane
	As a "Tester"
	I want to "Make sure that the grammar works with tabbed panes"
	In order to "ensure that the language is ok"


	Scenario "Select a tab in a tabbed pane"
		Given I am on the tab TabbedPaneComp :: SimpleTab2
		when I from the TabbedPaneSimple tabbedpane I select the Tab1 tab
		and I from the SaveAll button I click  
		then the TabbedPaneSimple tabbedpane selected tab is Tab1 tab 

	Scenario "Select a tab in a tabbed pane 2"
		Given I am on the tab org.simpleB.TabbedPaneComp :: SimpleTab1
		when I from the org.simpleB.TabbedPaneComp.SaveAll button I click 
		then I am on the tab TabbedPaneComp :: parts.simple.SimpleTab1
		
		when I from the TabbedPaneSimple tabbedpane I select the Tab1 tab
		then the TabbedPaneSimple tabbedpane selected tab is Tab1 tab
		