"
Baseline of Sargemt
"
Class {
	#name : #BaselineOfSargemt,
	#superclass : #BaselineOf,
	#category : #BaselineOfSargemt
}

{ #category : #baselines }
BaselineOfSargemt >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
        "Packages"
	        self FamixCpp: spec.
		self GroupTagger: spec.
		self Roassal3Exporters: spec.
    ]

]

{ #category : #dependencies }
BaselineOfSargemt >> FamixCpp: spec [

	spec
		baseline: 'FamixCpp'
		with: [ spec repository: 'github://moosetechnology/Famix-Cpp:main' ]
        
]

{ #category : #dependencies }
BaselineOfSargemt >> GroupTagger: spec [

	spec
		baseline: 'GroupTagger'
		with: [ spec repository: 'github://gamedev-studies/group-tagger:main' ]
        
]

{ #category : #dependencies }
BaselineOfSargemt >> Roassal3Exporters: spec [

	spec
		baseline: 'Roassal3Exporters'
		with: [ spec repository: 'github://ObjectProfile/Roassal3Exporters' ]
        
]

project
	^ super project
		loadType: #atomic;
		yourself
