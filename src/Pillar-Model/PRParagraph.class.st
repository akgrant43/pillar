"
I'm a paragraph of text containing text, line breaks or annotations.
I'm close to a latex or HTML paragraph. I do not contain complex structures such as lists, codeblocks. 
		
"
Class {
	#name : #PRParagraph,
	#superclass : #PRDocumentGroup,
	#category : 'Pillar-Model-Document'
}

{ #category : #testing }
PRParagraph class >> isAbstract [
	^ false
]

{ #category : #visiting }
PRParagraph >> accept: aVisitor [
	aVisitor visitParagraph: self
]
