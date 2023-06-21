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
		'inputProjectName'
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
			(SpBoxLayout newHorizontal add: #btnGen; yourself)
			withConstraints: [ :constraints | constraints height: 40 ];
			yourself
]

{ #category : #examples }
SargemtForm class >> open [
	<example>
	
	^ self new open
]

{ #category : #layout }
SargemtForm >> initialExtent [
	^ 505 @ 250 + 190
]

{ #category : #initialization }
SargemtForm >> initializePresenter [
	btnProjectPath  action: [ self selectProjectPath ].
	btnCSVPath action: [ self selectCSVPath  ].
	btnXMLPath action: [ self selectXMLPath  ].
	inputProjectPath input whenTextChangedDo: [ self verifyPaths ].
	inputCSVPath input whenTextChangedDo: [ self verifyPaths  ].
	inputXMLPath input whenTextChangedDo: [ self verifyPaths  ].
]

{ #category : #initialization }
SargemtForm >> initializeWidgets [
	inputProjectName := self
		instantiate:
			(SpLabeledPresenter label: 'Project name'
				input:
					(self newTextInput
						autoAccept: true;
						placeholder: 'Some name')).	

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
	feedbackMessage := self
		instantiate:
			(SpTextPresenter new
				text: 'a';
				disable).	
	"====="		
	self focusOrder
	   add: inputProjectName;
		add: inputProjectPath;
		add: inputCSVPath;
		add: inputXMLPath.
]

{ #category : #initialization }
SargemtForm >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: self title;
		initialExtent: self initialExtent
]

{ #category : #'as yet unclassified' }
SargemtForm >> selectCSVPath [
	| reference lastPath |
	lastPath := inputCSVPath input text.
	lastPath isEmpty 
		ifTrue: [ lastPath := FileLocator home ].
	reference := UIManager default
		chooseExistingFileReference: 'Select subsystem CSV file'
		extensions: ''
		path: lastPath.
		
	reference
		ifNotNil: [ inputCSVPath input text: reference pathString ]
]

{ #category : #'as yet unclassified' }
SargemtForm >> selectProjectPath [
	| reference lastPath |
	lastPath := inputProjectPath input text.
	lastPath isEmpty 
		ifTrue: [ lastPath := FileLocator home ].
	reference := UIManager default
		chooseExistingFileReference: 'Select a project folder'
		extensions: ''
		path: lastPath.
	reference
		ifNotNil: [ inputProjectPath input text: reference pathString ]
]

{ #category : #'as yet unclassified' }
SargemtForm >> selectXMLPath [
	| reference lastPath |
	lastPath := inputXMLPath input text.
	lastPath isEmpty 
		ifTrue: [ lastPath := FileLocator home ].
	reference := UIManager default
		chooseExistingFileReference: 'Select an include XML file'
		extensions: ['xml']
		path: lastPath.
	reference
		ifNotNil: [ inputXMLPath input text: reference pathString ]
]

{ #category : #initialization }
SargemtForm >> title [
^'SARGE - Software Architecture Recovery for Game Engines'
]

{ #category : #'as yet unclassified' }
SargemtForm >> verifyPaths [
	| green red normalColor newFeedbackMsgText |
	normalColor := Smalltalk ui theme backgroundColor.
	green := normalColor mixed: 0.8 with: Color green.
	red := normalColor mixed: 0.8 with: Color red.
	newFeedbackMsgText := ''.
	inputCSVPath input
		color:
			(inputCSVPath input text asFileReference exists
				& inputCSVPath input text isNotEmpty
				ifTrue: [ green ]
				ifFalse: [ newFeedbackMsgText := newFeedbackMsgText , 'Project path is invalid.'. red ]).
	inputCSVPath input
		color:
			(inputCSVPath input text asFileReference isFile
				ifTrue: [ green ]
				ifFalse: [ newFeedbackMsgText := newFeedbackMsgText , 'Include XML path is invalid.'. red ]).
	inputXMLPath input
		color:
			(inputXMLPath input text asFileReference exists
				& inputXMLPath input text isNotEmpty
				ifTrue: [ green ]
				ifFalse: [ newFeedbackMsgText := newFeedbackMsgText , 'Subsystem CSV path is invalid.'. red ]).
	feedbackMessage text: newFeedbackMsgText; color: (newFeedbackMsgText isEmpty ifTrue:[ normalColor ] ifFalse:[ red]).

]
