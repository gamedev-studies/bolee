"
This class does parsing and cleaning of DOT files, outputting a FamixCPreprocModel as result.
"
Class {
	#name : #BoleeDotParser,
	#superclass : #Object,
	#instVars : [
		'filePath',
		'rawContents',
		'cleanContents'
	],
	#category : #Bolee
}

{ #category : #'as yet unclassified' }
BoleeDotParser >> createModelRelationships: lines [
^ nil
]

{ #category : #'as yet unclassified' }
BoleeDotParser >> createModelStructure: lines [
   "a"
	| model myRoot paths parts lastParent tem niu |
	model := FamixCPreprocModel new.
	myRoot := FamixCPreprocFolder new name: '.'.
	model add: myRoot.

	paths := { './caca/queque/quiqui/quiqui.cpp'.
	         './caca/queque/popo.h' }.

	paths do: [ :path |
		parts := path splitOn: '/'.
		lastParent := myRoot.
		parts do: [ :part |
			Transcript show: 'is there a ' , part , '?'.
			Transcript cr.
			(part equalsTo: '.') ifFalse: [
				tem := lastParent children select: [ :e |
					       e name includesSubstring: part ].
				tem isEmpty
					ifTrue: [
						Transcript show: 'create ' , part.
						Transcript cr.
						niu := FamixCPreprocFolder new
							       name: part;
							       parentFolder: lastParent.
						lastParent := niu ]
					ifFalse: [
						Transcript show: 'go into ' , part.
						Transcript cr.
						lastParent := tem first ] ] ] ].
	model
]

{ #category : #removing }
BoleeDotParser >> removeBreaks: text [
^ text
]

{ #category : #removing }
BoleeDotParser >> removeStyling: text [

	| istrim lines cutPos |
	istrim := 'D:\Projects\bolee-parser\tendel.gv' asFileReference
		          readStreamEncoded: 'UTF16'.
	lines := istrim contents splitOn: ';'.
	lines := lines select: [ :item | item includesSubstring: '->' ].
	cutPos := (lines at: 1) findString: '[pos'.
	(lines at: 1) first: cutPos - 1
	"a"
]

{ #category : #running }
BoleeDotParser >> run: path [
	^ path
]
