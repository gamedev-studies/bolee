Class {
	#name : #SargemtPostGenForm,
	#superclass : #SpPresenter,
	#instVars : [
		'btnInspectFiles',
		'btnInspectFolders',
		'btnTagBrowser',
		'model'
	],
	#category : #Sargemt
}

{ #category : #layout }
SargemtPostGenForm class >> defaultLayout [
	^ SpBoxLayout newVertical
	   "vertical padding"
		add: '' withConstraints: [ :constraints | constraints height: 10 ]; 
		add:
			(SpBoxLayout newHorizontal add: #btnInspectFiles; yourself)
			withConstraints: [ :constraints | constraints height: 40 ];
		add:
			(SpBoxLayout newHorizontal add: #btnInspectFolders; yourself)
			withConstraints: [ :constraints | constraints height: 40 ];
		add:
			(SpBoxLayout newHorizontal add: #btnTagBrowser; yourself)
			withConstraints: [ :constraints | constraints height: 40 ];
			yourself.
]

{ #category : #examples }
SargemtPostGenForm class >> open [
	<example>
	
	^ self new open
]

{ #category : #'morphic ui' }
SargemtPostGenForm >> initialExtent [
	^ 520 @ 460
]

{ #category : #initialization }
SargemtPostGenForm >> initializePresenter [
	btnInspectFiles action: [ self inspectFiles ].
	btnInspectFolders action: [ self inspectFolders  ].
	btnTagBrowser action: [ self openTagBrowser ].
]

{ #category : #initialization }
SargemtPostGenForm >> initializeWidgets [

	btnInspectFiles := self newButton label: 'Inspect all files'.
	btnInspectFolders := self newButton label: 'Inspect top level folders'.
	btnTagBrowser := self newButton label: 'Open tag browser'.
	self focusOrder
	   add: btnInspectFiles;
		add: btnInspectFolders;
		add: btnTagBrowser.
]

{ #category : #initialization }
SargemtPostGenForm >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: self title;
		initialExtent: self initialExtent.
	model := MooseModel root last.
]

{ #category : #'as yet unclassified' }
SargemtPostGenForm >> inspectFiles [
	MiInspectorBrowser inspect: (model allWithType: FamixCPreprocHeaderFile) asMooseGroup.
]

{ #category : #'as yet unclassified' }
SargemtPostGenForm >> inspectFolders [
	MiInspectorBrowser inspect:  (((model allWithType: FamixCPreprocFolder) select: [ :f | f name ~= '.']) select: [ :f | f parentFolder name = '.']) asMooseGroup.
]

{ #category : #'as yet unclassified' }
SargemtPostGenForm >> openTagBrowser [
	MiTagBrowser open.
]

{ #category : #accessing }
SargemtPostGenForm >> title [
^'SARGE - What do you want to do now?'
]
