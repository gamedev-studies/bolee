Class {
	#name : #SargemtForm,
	#superclass : #SpPresenter,
	#instVars : [
		'menu',
		'list',
		'page',
		'selectedPage',
		'inputProjectPath',
		'btnProjectPath',
		'inputCSVPath',
		'btnCSVPath',
		'inputXMLPath',
		'btnXMLPath',
		'generateMSEButton',
		'btnGen',
		'feedbackMessage',
		'inputProjectName',
		'feedbackLabel',
		'feedbackList',
		'feedbackMessages',
		'droplistColormap',
		'checkboxAutotag'
	],
	#category : #Sargemt
}

{ #category : #layout }
SargemtForm class >> defaultLayout [
	^ SpBoxLayout newVertical
	   "vertical padding"
		add: '' withConstraints: [ :constraints | constraints height: 10 ]; 
		add:
			(SpBoxLayout newHorizontal
				add: #inputProjectName; yourself)
			withConstraints: [ :constraints | constraints height: 40 ];
		add:
			(SpBoxLayout newHorizontal
				add: #inputProjectPath; 
				add:
					(SpBoxLayout newVertical
						add: #btnProjectPath
						withConstraints: [ :constraints | constraints height: 25 ])
					withConstraints: [ :constraints | constraints width: 25 ])
			withConstraints: [ :constraints | constraints height: 40 ];
		add:
			(SpBoxLayout newHorizontal
				add: #inputCSVPath;
				add:
					(SpBoxLayout newVertical
						add: #btnCSVPath
						withConstraints: [ :constraints | constraints height: 25 ])
					withConstraints: [ :constraints | constraints width: 25 ])
			withConstraints: [ :constraints | constraints height: 40 ];
		add:
			(SpBoxLayout newHorizontal
				add: #inputXMLPath;
				add:
					(SpBoxLayout newVertical
						add: #btnXMLPath
						withConstraints: [ :constraints | constraints height: 25 ])
					withConstraints: [ :constraints | constraints width: 25 ])
			withConstraints: [ :constraints | constraints height: 40 ];		
		add:
			(SpBoxLayout newHorizontal add: 'Colormap' withConstraints: [ :constraints | constraints width: 100 ]; add: #droplistColormap; yourself)
			withConstraints: [ :constraints | constraints height: 25 ];
		add:
			(SpBoxLayout newHorizontal)
			withConstraints: [ :constraints | constraints height: 10 ];
		add:
			(SpBoxLayout newHorizontal add: #checkboxAutotag; yourself)
			withConstraints: [ :constraints | constraints height: 25 ];
	   add:
			(SpBoxLayout newHorizontal)
			withConstraints: [ :constraints | constraints height: 10 ];
	   add:
			(SpBoxLayout newHorizontal add: #feedbackLabel; yourself)
			withConstraints: [ :constraints | constraints height: 20 ];
		add:
			(SpBoxLayout newHorizontal add: #feedbackList; yourself)
			withConstraints: [ :constraints | constraints height: 100 ];
	   add:
			(SpBoxLayout newHorizontal)
			withConstraints: [ :constraints | constraints height: 10 ];
		add:
			(SpBoxLayout newHorizontal add: #btnGen; yourself)
			withConstraints: [ :constraints | constraints height: 40 ];
			yourself
]

{ #category : #examples }
SargemtForm class >> open [
	<example>
	
	^ self new open
]

{ #category : #generate }
SargemtForm >> generateModel [
	|projectName projectPath XMLPath CSVPath colormapSelected colormapDict importer tagger|
	
	projectName := inputProjectName input text.
	projectPath := inputProjectPath input text.
	XMLPath := inputXMLPath input text.
	CSVPath := inputCSVPath input text.
	colormapSelected := droplistColormap selection selectedIndex.
	colormapDict := (Dictionary newFrom: { 'RANDOM' -> '#666666' })
	
    "Create model using XML and metamodels".
    importer := FamixCPreprocImporter new rootFolder: projectPath ; runOn: XMLPath.

	"instantiate a new tagger and settings"
	tagger := GroupTagger new.

	"set index of the Moose model you want to query"
	tagger setModel: importer model.

	"set tag colors and project name"
	colormapSelected == 1
	ifTrue: [ colormapDict := Dictionary newFrom: { 'AUD' -> '#f0e442'. 'OMP' -> '#ff0000'. 'HID' -> '#ea9999'. 'DEB' -> '#cccccc'. 'SGC' -> '#009e73'. 'LLR' -> '#00b816'. 'VFX' -> '#b8f100'. 'FES' -> '#6de900'. 'PLA' -> '#8288f1'. 'GMP' -> '#af93f8'. 'SDK' -> '#f8beff'. 'SKA' -> '#fce5cd'. 'PHY' -> '#fbbc04'. 'RES' -> '#efefef'. 'COR' -> '#4fc8e5'. 'EDI' -> '#56b4e9'. 'NIL' -> '#646464' } ].
	
	colormapSelected == 2
	ifTrue: [ colormapDict := Dictionary newFrom: { 'AUD' -> '#fcdad7'. 'OMP' -> '#ffffff'. 'HID' -> '#ffffff'. 'DEB' -> '#ffffff'. 'SGC' -> '#ffffff'. 'LLR' -> '#9c0f02'. 'VFX' -> '#ffffff'. 'FES' -> '#fcdad7'. 'PLA' -> '#ffffff'. 'GMP' -> '#fcdad7'. 'SDK' -> '#ffffff'. 'SKA' -> '#fcdad7'. 'PHY' -> '#fcdad7'. 'RES' -> '#9c0f02'. 'COR' -> '#9c0f02'. 'EDI' -> '#9c0f02'. 'NIL' -> '#646464' } ].
	
	tagger setColorMap: colormapDict.
	tagger setProjectName: projectName.

	"set autotagging to false"
	tagger setAutotagFolderContents: checkboxAutotag state.
	
	"search the model for each path_from_root, tag file/folder with respective subsystem"
   tagger initialize: CSVPath  recursive: true.

	btnGen disable.
	SargemtPostGenForm open: importer model.

]

{ #category : #layout }
SargemtForm >> initialExtent [
	^ 520 @ 460
]

{ #category : #initialization }
SargemtForm >> initializePresenter [
   self verifyPaths.
	btnProjectPath  action: [ self selectProjectPath ].
	btnCSVPath action: [ self selectCSVPath  ].
	btnXMLPath action: [ self selectXMLPath ].
	inputProjectName input whenTextChangedDo: [ self verifyPaths ].
	inputProjectPath input whenTextChangedDo: [ self verifyPaths ].
	inputCSVPath input whenTextChangedDo: [ self verifyPaths  ].
	inputXMLPath input whenTextChangedDo: [ self verifyPaths  ].
	btnGen action: [ self generateModel ].
]

{ #category : #initialization }
SargemtForm >> initializeWidgets [
   feedbackMessages := OrderedCollection new.
	inputProjectName := self
		instantiate:
			(SpLabeledPresenter label: 'Project name'
				input:
					(self newTextInput
						autoAccept: true;
						placeholder: 'e.g. MyEngine')).	

	inputProjectPath := self
		instantiate:
			(SpLabeledPresenter label: 'Project path'
				input:
					(self newTextInput
						autoAccept: true;
						placeholder: 'No path selected')).			
	btnProjectPath := self newButton
		icon: (self iconNamed: 'glamorousOpen').
	"====="
	inputCSVPath := self
		instantiate:
			(SpLabeledPresenter label: 'Subsystems CSV'
				input:
					(self newTextInput
						autoAccept: true;
						placeholder: 'No path selected')).			
	btnCSVPath := self newButton
		icon: (self iconNamed: 'glamorousOpen').
	"====="
	inputXMLPath := self
		instantiate:
			(SpLabeledPresenter label: 'Includes XML'
				input:
					(self newTextInput
						autoAccept: true;
						placeholder: 'No path selected')).			
	btnXMLPath := self newButton
		icon: (self iconNamed: 'glamorousOpen').
	"====="
	btnGen := self newButton
		label: 'Generate'.
	"====="	
	feedbackLabel := self
		instantiate:
			(SpLabelPresenter new
				label: 'Analyser errors, resolve all before model generation').	
	feedbackList := self 
	    instantiate: 
	       (SpFilteringListPresenter new 
	          items: feedbackMessages).		
	"====="		
	droplistColormap := self 
	    instantiate: 
	       (SpDropListPresenter new 
				 help: 'Select a colormap';
	          items: #('gregory1' 'emergent1' 'random')).	
	"====="		
	checkboxAutotag := self 
	    instantiate: 
	       (SpCheckBoxPresenter new label: 'Tag folder contents automatically?'; state: true).	
	self focusOrder
	   add: inputProjectName;
		add: inputProjectPath;
		add: inputCSVPath;
		add: inputXMLPath;
		add: droplistColormap;
		add: checkboxAutotag.
]

{ #category : #initialization }
SargemtForm >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: self title;
		initialExtent: self initialExtent
]

{ #category : #selection }
SargemtForm >> selectCSVPath [
	| reference lastPath |
	lastPath := inputCSVPath input text.
	lastPath isEmpty 
		ifTrue: [ lastPath := FileLocator home ].
	reference := UIManager default chooseFullFileNameMatching: nil.
		
	reference
		ifNotNil: [ inputCSVPath input text: reference ]
]

{ #category : #selection }
SargemtForm >> selectProjectPath [
	| reference lastPath |
	lastPath := inputProjectPath input text.
	lastPath isEmpty 
		ifTrue: [ lastPath := FileLocator home ].
	reference := UIManager default
		chooseExistingFileReference: 'Select the project folder'
		extensions: ''
		path: lastPath.
	reference
		ifNotNil: [ inputProjectPath input text: reference pathString ]
]

{ #category : #selection }
SargemtForm >> selectXMLPath [
	| reference lastPath |
	lastPath := inputXMLPath input text.
	lastPath isEmpty 
		ifTrue: [ lastPath := FileLocator home ].
	reference := UIManager default chooseFullFileNameMatching: nil.
	reference
		ifNotNil: [ inputXMLPath input text: reference ]
]

{ #category : #initialization }
SargemtForm >> title [
^'SARGE - Software Architecture Recovery for Game Engines'
]

{ #category : #validation }
SargemtForm >> verifyPaths [
    |feedbackMessagesToShow|
    feedbackMessagesToShow := OrderedCollection new.
    inputProjectName input text isEmpty
				ifTrue: [ feedbackMessagesToShow add: '- Project name is empty' ].
	
	inputProjectPath input text asFileReference exists
				& inputProjectPath input text isNotEmpty
				ifFalse: [ feedbackMessagesToShow add: '- Project path is empty' ].
	
    inputCSVPath input text asFileReference isFile 
			& inputCSVPath input text isNotEmpty
			& (inputCSVPath input text includesSubstring: '.csv')
				ifFalse: [ feedbackMessagesToShow add: '- Subsystem CSV path is empty or not pointing to a CSV file' ].
	
    inputXMLPath input text asFileReference exists
			& inputXMLPath input text isNotEmpty 
			& (inputXMLPath input text includesSubstring: '.xml') 
			   ifFalse: [ feedbackMessagesToShow add: '- Include XML path is empty or not pointing to a XML file' ].
	feedbackList items: feedbackMessagesToShow.
	feedbackMessagesToShow isEmpty ifTrue: [ btnGen enable ] ifFalse: [btnGen disable].

]
