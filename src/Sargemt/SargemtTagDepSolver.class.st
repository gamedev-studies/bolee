Class {
	#name : #SargemtTagDepSolver,
	#superclass : #Object,
	#instVars : [
		'selectedModel',
		'engineName'
	],
	#category : #Sargemt
}

{ #category : #building }
SargemtTagDepSolver >> buildDotFile: listOfDicts [
   |sourceTag dependedTags dotFileLines targetTag|
   dotFileLines := OrderedCollection new.
   dotFileLines add: 'digraph "source tree" {',(Character cr asString).
	listOfDicts do: [ :item | 
		sourceTag := item keys first.
		dependedTags := item at: sourceTag.
		sourceTag := sourceTag copyReplaceAll: (engineName,'-') with: ''. 
		dependedTags do: [ :tag | 
			targetTag := tag copyReplaceAll: (engineName,'-') with: ''. 
			dotFileLines add: sourceTag,'->',targetTag,(Character cr asString). ]
	].
   dotFileLines add: '}'.
	^dotFileLines.

]

{ #category : #running }
SargemtTagDepSolver >> run: model engineName: name [
	| tagNames taggedEntities result |
	selectedModel := model.
	self setEngineName: name.
	tagNames := selectedModel tags collect: [ :e | e name asString ].
	taggedEntities := selectedModel select: [ :f | f tags isNotEmpty ].
	result := tagNames collect: [ :tag | self searchTagDeps: taggedEntities tag: tag  ].
	self saveSolverResult: (self buildDotFile: result).
	^ result.
	
]

{ #category : #building }
SargemtTagDepSolver >> saveSolverResult: list [
|file|
file := (engineName,'.dot') asFileReference.
file writeStreamDo: [ :stream | stream << list ].

]

{ #category : #building }
SargemtTagDepSolver >> searchTagDeps: entities tag: aTag [

	| isOfATag allOutOpposites allOutOppositesWithTags oppTags resultDict|
	isOfATag := entities select: [ :f | 
		            f tags first name includesSubstring: aTag ].
	allOutOpposites := isOfATag flatCollect: [ :f | 
		                   f queryAllOutgoing opposites ].
	allOutOppositesWithTags := allOutOpposites select: [ :f | 
		                           f tags isNotEmpty ].
	oppTags := (allOutOppositesWithTags collect: [ :f | f tags first name ])
		           asSet.
	resultDict := Dictionary new.
	resultDict at: aTag put: (oppTags select: [ :item | item ~= aTag ]).
	^ resultDict.
]

{ #category : #initialization }
SargemtTagDepSolver >> setEngineName: name [
	engineName := name.
]
