"
This form counts files on each subsystem and shows it to you.
"
Class {
	#name : #BoleeSubsystemCount,
	#superclass : #SpPresenter,
	#instVars : [
		'table1',
		'model'
	],
	#classInstVars : [
		'selectedModel'
	],
	#category : #Bolee
}

{ #category : #layout }
BoleeSubsystemCount class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #table1;
		  yourself
]

{ #category : #examples }
BoleeSubsystemCount class >> open [
	<example>
	
	^ self new open
]

{ #category : #protocol }
BoleeSubsystemCount class >> open: model [
	| inst |
	selectedModel := model.
	inst := self new setModel: model.
	inst open.
]

{ #category : #counting }
BoleeSubsystemCount >> countSubsystems [
   |firstD secondD allTags tagsFound|
   model := (model allWithType: FamixCPreprocHeaderFile) asMooseGroup.
	firstD := OrderedDictionary new.
	secondD := OrderedDictionary new.
	allTags := (((model select: [ :f | f name ~= '.' ]) flatCollect: [ :x | 
		             x tags ]) select: [ :f | 
		            f name matchesRegex: '^((?!OTH).)*$' ]) asSet.
	allTags do: [ :tag | 
		tagsFound := (model select: [ :f | f tags isNotEmpty ]) select: [ :f | 
					 f tags first name includesSubstring: tag name ].
		firstD
			at:  tagsFound size 
			put: tag].
		firstD keys sorted do: [ :item | secondD at: (firstD at: item) put: item  ].
	   secondD := secondD associations sorted: [ :a :b | a value > b value ].
	^secondD.
]

{ #category : #'morphic ui' }
BoleeSubsystemCount >> initialExtent [
	^ 480 @ 340
]

{ #category : #initialization }
BoleeSubsystemCount >> initializePresenter [
	table1 := self newTable.

]

{ #category : #initialization }
BoleeSubsystemCount >> initializeWindow: aWindowPresenter [
   |sublist dic|
	sublist := self countSubsystems.
	dic := sublist asDictionary.
	sublist isNotNil ifTrue: [ 
		table1
			addColumn:
				(SpStringTableColumn title: 'Subsystem' evaluated: #name);
			addColumn: (SpStringTableColumn
					 title: 'File count'
					 evaluated: [ :item | dic at: item ]);
			       items: (sublist collect: #key);
			beResizable ].
		
	aWindowPresenter
		title: self title;
		initialExtent: self initialExtent.
]

{ #category : #initialization }
BoleeSubsystemCount >> setModel: aModel [
	model := aModel.
]

{ #category : #accessing }
BoleeSubsystemCount >> title [
^'Bolée - File count by subsystem'
]
