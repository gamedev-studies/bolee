"
This class collects all files from a folder hierarchy in a FamixCPreproc model. It receives a container entity as starting point, and descends into the container's children recursively.
"
Class {
	#name : #BoleeEntitySearcher,
	#superclass : #Object,
	#instVars : [
		'searchResults'
	],
	#category : #Bolee
}

{ #category : #searching }
BoleeEntitySearcher >> collectAllFilesIn: container [

	| foldersFound |
	foldersFound := container children select: [ :e |
		                e className includesSubstring: 'FamixCPreprocFolder' ].
	searchResults ifNil: [ 
		searchResults := OrderedCollection new.
		 ].
	searchResults add: (container children select: [ :e |
			 e className includesSubstring: 'FamixCPreprocCFile' ]).

	foldersFound isNotEmpty ifTrue: [
		foldersFound do: [ :folder | self collectAllFilesIn: folder ] ].
	^ (searchResults flatCollect: [ :item | item ]) asSet
]

{ #category : #searching }
BoleeEntitySearcher >> collectAllFilesIn: container byName: aName [

	| foldersFound |
	foldersFound := container children select: [ :e |
		                e className includesSubstring: 'FamixCPreprocFolder' ].
	searchResults ifNil: [ 
		searchResults := OrderedCollection new.
		 ].
	searchResults add: (container children select: [ :e |
			 e className includesSubstring: 'FamixCPreprocCFile' ]).

	foldersFound isNotEmpty ifTrue: [
		foldersFound do: [ :folder | self collectAllFilesIn: folder ] ].
	 searchResults := (searchResults flatCollect: [ :item | item ]) asSet.
	 ^ searchResults select: [ :file | file name includesSubstring: aName ].


]
