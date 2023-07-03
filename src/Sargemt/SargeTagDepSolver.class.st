Class {
	#name : #SargeTagDepSolver,
	#superclass : #Object,
	#instVars : [
		'selectedModel'
	],
	#category : #Sargemt
}

{ #category : #running }
SargeTagDepSolver >> run: model [

	| tagNames taggedEntities result|
	selectedModel := model.
	tagNames := selectedModel tags collect: [ :e | e name asString ].
	taggedEntities := selectedModel select: [ :f | f tags isNotEmpty ].
	result := tagNames collect: [ :tag | self searchTagDeps: taggedEntities tag: tag  ].
	^ result.
	
]

{ #category : #running }
SargeTagDepSolver >> searchTagDeps: entities tag: aTag [

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
