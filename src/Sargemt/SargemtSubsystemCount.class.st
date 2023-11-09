"
This form counts files on each subsystem and shows it to you.
"
Class {
	#name : #SargemtSubsystemCount,
	#superclass : #SpPresenter,
	#instVars : [
		'table1',
		'model'
	],
	#classInstVars : [
		'selectedModel'
	],
	#category : #Sargemt
}

{ #category : #layout }
SargemtSubsystemCount class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #table1;
		  yourself
]

{ #category : #examples }
SargemtSubsystemCount class >> open [
	<example>
	
	^ self new open
]

{ #category : #protocol }
SargemtSubsystemCount class >> open: model [
	| inst |
	selectedModel := model.
	inst := self new setModel: model.
	inst open.
]

{ #category : #counting }
SargemtSubsystemCount >> countSubsystems [
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
SargemtSubsystemCount >> initialExtent [
	^ 480 @ 340
]

{ #category : #initialization }
SargemtSubsystemCount >> initializePresenter [
	table1 := self newTable.

]

{ #category : #initialization }
SargemtSubsystemCount >> initializeWindow: aWindowPresenter [
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
SargemtSubsystemCount >> setModel: aModel [
	model := aModel.
]

{ #category : #accessing }
SargemtSubsystemCount >> title [
^'SARGE - File count by subsystem'
]
