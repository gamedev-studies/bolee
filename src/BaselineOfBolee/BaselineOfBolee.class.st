"
Baseline of Bolee
"
Class {
	#name : #BaselineOfBolee,
	#superclass : #BaselineOf,
	#category : #BaselineOfBolee
}

{ #category : #baselines }
BaselineOfBolee >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
        "Packages"
	        self FamixCpp: spec.
		self GroupTagger: spec.
		self Roassal3Exporters: spec.

		spec package: 'Bolee'
			with: [ spec requires: #( 'FamixCpp' 'GroupTagger' 'Roassal3Exporters' ) ].
    ]

]

{ #category : #dependencies }
BaselineOfBolee >> FamixCpp: spec [

	spec
		baseline: 'FamixCpp'
		with: [ spec repository: 'github://moosetechnology/Famix-Cpp:main' ]
        
]

{ #category : #dependencies }
BaselineOfBolee >> GroupTagger: spec [

	spec
		baseline: 'GroupTagger'
		with: [ spec repository: 'github://gamedev-studies/group-tagger:main' ]
        
]

{ #category : #dependencies }
BaselineOfBolee >> Roassal3Exporters: spec [

	spec
		baseline: 'Roassal3Exporters'
		with: [ spec repository: 'github://ObjectProfile/Roassal3Exporters' ]
        
]

{ #category : #accessing }
BaselineOfBolee >> project [

	^ super project
		loadType: #atomic;
		yourself
]
