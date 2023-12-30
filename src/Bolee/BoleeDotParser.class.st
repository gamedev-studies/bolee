"
This class does parsing and cleaning of DOT files, outputting a FamixCPreprocModel as result.
"
Class {
	#name : #BoleeDotParser,
	#superclass : #Object,
	#instVars : [
		'basePath',
		'model',
		'separator',
		'modelRootFolder',
		'installAfterGeneration'
	],
	#category : #Bolee
}

{ #category : #accessing }
BoleeDotParser >> basePath: path [

	basePath := path
]

{ #category : #removing }
BoleeDotParser >> cleanLinePath: path [
	^ basePath,((path copyReplaceAll: '"' with: '') trimBoth). 
]

{ #category : #generating }
BoleeDotParser >> createEntity: part lastParent: lastParent type: entityType [

	| entitiesWithName newEntity |
	entitiesWithName := lastParent children select: [ :e |
		                    e name includesSubstring: part ].
	entitiesWithName isEmpty
		ifTrue: [
			newEntity := entityType new
				             name: part;
				             parentFolder: lastParent ]
		ifFalse: [ newEntity := entitiesWithName first ].

	"lastParent := newEntity "
	^ newEntity
]

{ #category : #generating }
BoleeDotParser >> createModelRelationships: paths [

	| searcher allFiles sourcePath targetPath sourceFile targetFile |
	searcher := BoleeEntitySearcher new.
	allFiles := searcher collectAllFilesIn: modelRootFolder.
	sourcePath := './' , (paths at: 1).
	targetPath := './' , (paths at: 2).
	sourceFile := allFiles select: [ :file | file fullName equalsTo: sourcePath ].
	targetFile := allFiles select: [ :file | file fullName equalsTo: targetPath ].

	(sourceFile isNotEmpty and: targetFile isNotEmpty) ifTrue: [
		FamixCPreprocInclude new
			mooseModel: model;
			included: sourceFile anyOne;
			includedBy: targetFile anyOne ].

	^ model
]

{ #category : #generating }
BoleeDotParser >> createModelStructure: paths [

	| parts lastParent entityType |
	paths do: [ :path |
		parts := path splitOn: '/'.
		lastParent := modelRootFolder.
		parts do: [ :part |
			(part equalsTo: '.') ifFalse: [
				entityType := self determineType: part.
				lastParent := self
					              createEntity: part
					              lastParent: lastParent
					              type: entityType ] ] ].
	model
]

{ #category : #accessing }
BoleeDotParser >> determineType: part [

	^ (part includesSubstring: '.')
		  ifTrue: [ ^ FamixCPreprocCFile ]
		  ifFalse: [ ^ FamixCPreprocFolder ]
]

{ #category : #searching }
BoleeDotParser >> getPathsFromLine: line [

	| parts result |
	result := OrderedCollection new.
	parts := line splitOn: '->'.
	result add: (self cleanLinePath: (parts at: 1)).
	result add: (self cleanLinePath: (parts at: 2)).
	^ result.
	
]

{ #category : #searching }
BoleeDotParser >> getSeparator: rawText [
	| search |
	search := rawText findString: '/'.
	search > 0 ifTrue: [ ^ '/' ] ifFalse: [ ^ '\' ].
]

{ #category : #accessing }
BoleeDotParser >> installAfterGeneration: value [
	installAfterGeneration := value
]

{ #category : #removing }
BoleeDotParser >> removeStyling: lines [

	| nodeLines posCut dotNoStyles  |
	"remove styling lines, keep only node relationships"
	nodeLines := lines select: [ :item | item includesSubstring: '->' ].

	"keep line content, remove styling details"
	dotNoStyles := lines collect: [ :line |
		               posCut := line findString: '[pos'.
			            posCut <= 0 ifTrue: [ posCut := 1 ].
		               line first: posCut - 1 ].

	^ dotNoStyles select: [ :line | line isNotEmpty ]
]

{ #category : #running }
BoleeDotParser >> run: path [
	^ self run: path encoding: 'UTF8'.

]

{ #category : #running }
BoleeDotParser >> run: path encoding: encoding [

	| fileStream lines pathPairs rawContents basePathSeparator |
	"load DOT file"
	fileStream := path asFileReference readStreamEncoded: encoding.
	rawContents := fileStream contents.
	basePath ifNil: [
		Error new signal: 'You must inform a valid base absolute path.' ].

	"get path separator and check consistency"
	separator := self getSeparator: rawContents.
	basePathSeparator := self getSeparator: basePath.
	separator == basePathSeparator ifFalse: [
		Error new signal:
			'The base path separators should be the same used in the file to be parsed.' ].

	"divide file into lines, remove unecessary lines with styling"
	lines := rawContents splitOn: ';'.
	lines := self removeStyling: lines.

	"build a model based on the DOT file, line by line"
	self setupNewModel.
	pathPairs := lines collect: [ :line | self getPathsFromLine: line ].
	pathPairs do: [ :pair | self createModelStructure: pair ].

	"create relationships between files"
	pathPairs do: [ :pair | self createModelRelationships: pair ].
	
	"install after generation if set to do so"
	installAfterGeneration ifTrue: [ model installWithCache: false ].

	^ model
]

{ #category : #generating }
BoleeDotParser >> setupNewModel [
   |basePathParts|
	model := FamixCPreprocModel new.
	basePathParts := basePath splitOn: '/'.
	model name: (basePathParts at: (basePathParts size - 1)).
	modelRootFolder := FamixCPreprocFolder new name: '.'.
	model add: modelRootFolder
]
