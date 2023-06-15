Class {
	#name : #SargemtForm,
	#superclass : #SpPresenter,
	#instVars : [
		'menu',
		'list',
		'page',
		'selectedPage'
	],
	#category : #Sargemt
}

{ #category : #examples }
SargemtForm class >> open [
	<example>
	
	^ self new open
]

{ #category : #layout }
SargemtForm >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpPanedLayout newLeftToRight
				   positionOfSlider: 200;
				   yourself);
		  yourself
]
