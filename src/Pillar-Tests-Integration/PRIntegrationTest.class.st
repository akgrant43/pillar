Class {
	#name : #PRIntegrationTest,
	#superclass : #TestCase,
	#instVars : [
		'projectDirectory',
		'project'
	],
	#category : 'Pillar-Tests-Integration'
}

{ #category : #parameters }
PRIntegrationTest >> archetypeBasicLatex [

	^ 'basic-latex'
]

{ #category : #parameters }
PRIntegrationTest >> archetypeBook [

	^ 'book'
]

{ #category : #parameters }
PRIntegrationTest >> archetypePresentation [

	^ 'presentation'
]

{ #category : #parameters }
PRIntegrationTest >> archetypeWelcome [

	^  'welcome'
]

{ #category : #initialization }
PRIntegrationTest >> ensureTestDirectory [

	projectDirectory := '__test' asFileReference.
	projectDirectory ensureDeleteAll.
	projectDirectory ensureCreateDirectory.
]

{ #category : #parameters }
PRIntegrationTest >> outputEPub [

	^ PREPubOutput new
]

{ #category : #parameters }
PRIntegrationTest >> outputHtml [

	^ PRHtmlOutput new
]

{ #category : #parameters }
PRIntegrationTest >> outputPdf [

	^ PRPdfOutput new
]

{ #category : #running }
PRIntegrationTest >> setUp [

	super setUp.
	self ensureTestDirectory.
	project := PRProject on: projectDirectory.
]

{ #category : #running }
PRIntegrationTest >> tearDown [

	Smalltalk garbageCollect.
	projectDirectory ensureDeleteAll.
	super tearDown.
]

{ #category : #tests }
PRIntegrationTest >> testArchetype: archetype output: output [

	project installArchetypeNamed: archetype.
	project build: output.
	
	self assert: project outputDirectory children size equals: 1.
	self assert: project outputDirectory children first basename equals: output outputDirectoryName.
]

{ #category : #tests }
PRIntegrationTest >> testBasicLatexHtml [

	self testArchetype: self archetypeBasicLatex output: self outputHtml.
	self assert: (project outputDirectory / 'html' / 'index.html') exists.
]

{ #category : #tests }
PRIntegrationTest >> testBasicLatexPdf [

	self timeLimit: 1 minute.
	self testArchetype: self archetypeBasicLatex output: self outputPdf.
	self assert: (project outputDirectory / 'pdf' / 'index.pdf') exists.
]

{ #category : #tests }
PRIntegrationTest >> testBookEpub [

	| archive |
	self testArchetype: self archetypeBook output: self outputEPub.
	self assert: (project outputDirectory / 'epub' / 'index.epub') exists.
	
	archive := ZipArchive new.
	archive readFrom: (project outputDirectory / 'epub' / 'index.epub') fullName.
		
	self assert: archive members first fileName equals: 'mimetype'.
	self assert: (archive memberNamed: 'contents.opf') notNil.
	self assert: (archive memberNamed: 'contents.xhtml') notNil.
]

{ #category : #tests }
PRIntegrationTest >> testBookHtml [

	self testArchetype: self archetypeBook output: self outputHtml.
	self assert: (project outputDirectory / 'html' / 'index.html') exists.
]

{ #category : #tests }
PRIntegrationTest >> testBookPdf [

	self timeLimit: 2 minutes.
	self testArchetype: self archetypeBook output: self outputPdf.
	self assert: (project outputDirectory / 'pdf' / 'index.pdf') exists.
]

{ #category : #tests }
PRIntegrationTest >> testPresentationHtml [

	self testArchetype: self archetypePresentation output: self outputHtml.
	self assert: (project outputDirectory / 'html' / 'index.html') exists.
]

{ #category : #tests }
PRIntegrationTest >> testPresentationPdf [

	self timeLimit: 2 minutes.
	self testArchetype: self archetypePresentation output: self outputPdf.
	self assert: (project outputDirectory / 'pdf' / 'index.pdf') exists.
]

{ #category : #tests }
PRIntegrationTest >> testWelcomeHtml [

	self testArchetype: self archetypeWelcome output: self outputHtml.
	self assert: (project outputDirectory / 'html' / 'index.html') exists.
]

{ #category : #tests }
PRIntegrationTest >> testWelcomePdf [

	self testArchetype: self archetypeWelcome output: self outputPdf.
	self assert: (project outputDirectory / 'pdf' / 'index.pdf') exists.
]
