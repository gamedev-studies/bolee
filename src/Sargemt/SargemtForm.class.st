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
		'feedbackLabel'
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
			(SpBoxLayout newHorizontal add: #feedbackLabel; yourself)
			withConstraints: [ :constraints | constraints height: 20 ];
		add:
			(SpBoxLayout newHorizontal add: #feedbackMessage; yourself)
			withConstraints: [ :constraints | constraints height: 50 ];
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

{ #category : #'as yet unclassified' }
SargemtForm >> generateModel [
	Transcript show: 'lets go'.
]

{ #category : #layout }
SargemtForm >> initialExtent [
	^ 520 @ 330
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
	feedbackMessage := self
		instantiate:
			(SpTextPresenter new
				text: '';
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
	reference := UIManager default chooseFullFileNameMatching: nil.
		
	reference
		ifNotNil: [ inputCSVPath input text: reference ]
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SargemtForm >> verifyPaths [
    |newFeedbackMsgText|
    newFeedbackMsgText := ''.
    inputProjectName input text isEmpty
				ifTrue: [ newFeedbackMsgText := newFeedbackMsgText , 'The project name is empty. ' ].
	
	inputProjectPath input text asFileReference exists
				& inputProjectPath input text isNotEmpty
				ifFalse: [ newFeedbackMsgText := newFeedbackMsgText , 'Project path is invalid. ' ].
	
    inputCSVPath input text asFileReference isFile 
			& inputCSVPath input text isNotEmpty
				ifFalse: [ newFeedbackMsgText := newFeedbackMsgText , 'Include XML path is invalid. ' ].
	
    inputXMLPath input text asFileReference exists
				& inputXMLPath input text isNotEmpty
				ifFalse: [ newFeedbackMsgText := newFeedbackMsgText , 'Subsystem CSV path is invalid. ' ].
	feedbackMessage text: newFeedbackMsgText.
	feedbackMessage text isEmpty ifTrue: [ btnGen enable ] ifFalse: [btnGen disable].

]
