Class {
	#name : #SargemtPostGenForm,
	#superclass : #SpPresenter,
	#instVars : [
		'btnInspectFiles',
		'btnInspectFolders',
		'btnTagBrowser',
		'model',
		'labelFileCount',
		'labelFolderCount',
		'labelIncludeCount',
		'labelTagCount',
		'btnFindSource',
		'btnDistMap',
		'btnArchMap'
	],
	#category : #Sargemt
}

{ #category : #layout }
SargemtPostGenForm class >> defaultLayout [
	^ SpBoxLayout newVertical
	   "vertical padding"
		add: '' withConstraints: [ :constraints | constraints height: 10 ];  
		add: ('Model generation successful for ' , MooseModel root last name) withConstraints: [ :constraints | constraints height: 20 ];  
		add: (SpBoxLayout newHorizontal 
				add: #labelFileCount; 
				add: #labelFolderCount; 
				add: #labelIncludeCount; 
				add: #labelTagCount; yourself)
				withConstraints: [ :constraints | constraints height: 30 ];
		add:
			(SpBoxLayout newHorizontal add: #btnInspectFiles; yourself)
			withConstraints: [ :constraints | constraints height: 40 ];
		add:
			(SpBoxLayout newHorizontal add: #btnInspectFolders; yourself)
			withConstraints: [ :constraints | constraints height: 40 ];
		add:
			(SpBoxLayout newHorizontal add: #btnFindSource; yourself)
			withConstraints: [ :constraints | constraints height: 40 ];
		add:
			(SpBoxLayout newHorizontal add: #btnTagBrowser; yourself)
			withConstraints: [ :constraints | constraints height: 40 ];
		add:
			(SpBoxLayout newHorizontal add: #btnDistMap; yourself)
			withConstraints: [ :constraints | constraints height: 40 ];
		add:
			(SpBoxLayout newHorizontal add: #btnArchMap; yourself)
			withConstraints: [ :constraints | constraints height: 40 ];
			yourself.
]

{ #category : #examples }
SargemtPostGenForm class >> open [
	<example>
	
	^ self new open
]

{ #category : #protocol }
SargemtPostGenForm class >> open: model [
	| inst |
	inst := self new setModel: model.
	inst open.
]

{ #category : #compute }
SargemtPostGenForm >> countTags [
^((model select: [ :f | f name ~= '.'])  flatCollect: [ :x | x tags ]) asSet size asString
]

{ #category : #search }
SargemtPostGenForm >> findSource [
| srcFolder |
srcFolder := (self getTopLevelFolders flatCollect: [ :f | f children ]) select: [ :f | f name matchesRegex: 'src|source|Source|engine|Engine|code|Code' ].
srcFolder isEmpty
ifTrue: [ MiInspectorBrowser inspect: srcFolder ]
ifFalse: [ MiInspectorBrowser inspect: srcFolder first ]


]

{ #category : #search }
SargemtPostGenForm >> getTopLevelFolders [
^(((model allWithType: FamixCPreprocFolder) select: [ :f | f name ~= '.']) select: [ :f | f parentFolder name = '.']) asMooseGroup
]

{ #category : #'morphic ui' }
SargemtPostGenForm >> initialExtent [
	^ 520 @ 350
]

{ #category : #initialization }
SargemtPostGenForm >> initializePresenter [
	btnInspectFiles action: [ self inspectFiles ].
	btnInspectFolders action: [ self inspectFolders  ].
	btnFindSource action: [ self findSource ].
	btnTagBrowser action: [ self openTagBrowser ].
	btnDistMap  action: [ self openDistMap ].
	btnArchMap  action: [ self openArchMap ].
]

{ #category : #initialization }
SargemtPostGenForm >> initializeWidgets [

	btnInspectFiles := self newButton label: 'Inspect all files'.
	btnInspectFolders := self newButton label: 'Inspect top level folders'.
	btnFindSource := self newButton label: 'Inspect source folder'.
	btnTagBrowser := self newButton label: 'Open tag browser'.
	btnDistMap := self newButton label: 'Open distribution map'.
	btnArchMap := self newButton label: 'Open architectural map'.
	labelFileCount := self instantiate: (SpLabelPresenter new label: '').	
	labelFolderCount := self instantiate: (SpLabelPresenter new label: '').	
	labelIncludeCount := self instantiate: (SpLabelPresenter new label: '').	
	labelTagCount := self instantiate: (SpLabelPresenter new label: '').	
	self focusOrder
	   add: btnInspectFiles;
		add: btnInspectFolders;
		add: btnFindSource;
		add: btnTagBrowser;
		add: btnDistMap;
		add: btnArchMap.
]

{ #category : #initialization }
SargemtPostGenForm >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: self title;
		initialExtent: self initialExtent.
	labelFileCount label: 'Files: ' , (model allWithType: FamixCPreprocHeaderFile) size asString.
	labelFolderCount label: 'Folders: ' , (model allWithType: FamixCPreprocFolder) size asString.
	labelIncludeCount label: 'Includes: ' , (model allWithType: FamixCPreprocInclude) size asString.
	labelTagCount label: 'Tags: ', self countTags .
]

{ #category : #inspecting }
SargemtPostGenForm >> inspectFiles [
	MiInspectorBrowser inspect: (model allWithType: FamixCPreprocHeaderFile) asMooseGroup.
]

{ #category : #inspecting }
SargemtPostGenForm >> inspectFolders [
	MiInspectorBrowser inspect:  self getTopLevelFolders.
]

{ #category : #inspecting }
SargemtPostGenForm >> openArchMap [	
	MiArchitecturalMapBrowser open.
]

{ #category : #inspecting }
SargemtPostGenForm >> openDistMap [
	MiDMBrowser open.
]

{ #category : #inspecting }
SargemtPostGenForm >> openTagBrowser [
	MiTagBrowser open.
]

{ #category : #initialization }
SargemtPostGenForm >> setModel: aModel [
	model := aModel.
]

{ #category : #accessing }
SargemtPostGenForm >> title [
^'SARGE - What do you want to do now?'
]