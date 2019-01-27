"
P3FormattedStatementTest holds unit tests for the P3FormattedStatement class.

I reuse the configuration of P3ClientTests.
"
Class {
	#name : #P3FormattedStatementTest,
	#superclass : #TestCase,
	#instVars : [
		'client'
	],
	#classVars : [
		'Url'
	],
	#category : #'P3-Tests'
}

{ #category : #running }
P3FormattedStatementTest >> setUp [
	super setUp.
	client := P3Client new.
	client url: P3ClientTest url.
	client connect
]

{ #category : #running }
P3FormattedStatementTest >> tearDown [
	client close.
	super tearDown
]

{ #category : #tests }
P3FormattedStatementTest >> testByteArray [
	| statement bytes result |
	
	client execute: 'DROP TABLE IF EXISTS testBytea'.
	client execute: 'CREATE TABLE testBytea (id INT, bytes BYTEA)'.
	
	bytes := #[ 0 1 2 3 4 254 255 ].	
	
	statement := client format: 'INSERT INTO testBytea (id, bytes) VALUES ($1, $2)'.
	statement execute: { 100. bytes }.
	
	statement := client format: 'SELECT bytes FROM testBytea WHERE id = $1'.
	result := statement query: #( 100 ).
	
	self assert: result firstFieldOfFirstRecord equals: bytes.
	
	client execute: 'DROP TABLE testBytea'
]

{ #category : #tests }
P3FormattedStatementTest >> testNull [
	| statement result |
	
	client execute: 'DROP TABLE IF EXISTS table1'.
	client execute: 'CREATE TABLE table1 (id INTEGER, name TEXT, enabled BOOLEAN)'.
	
	statement := client format: 'INSERT INTO table1 (id, name, enabled) VALUES ($1, $2, $3)'.
	statement execute: #( nil nil nil	).
	
	result := client query: 'SELECT id, name, enabled FROM table1'.

	self assert: result firstRecord equals: #( nil nil nil ).
	
	client execute: 'DROP TABLE table1'
]

{ #category : #tests }
P3FormattedStatementTest >> testSimple [
	| statement result |
	
	client execute: 'DROP TABLE IF EXISTS table1'.
	client execute: 'CREATE TABLE table1 (id INTEGER, name TEXT, enabled BOOLEAN)'.
	
	statement := client format: 'INSERT INTO table1 (id, name, enabled) VALUES ($1, $2, $3)'.
	statement executeBatch: #(
		( 123 'Hello World' true )
		( 345 'Greetings' false )
		( 567 'From Mars' true )	).
	
	statement := client format: 'SELECT name, enabled FROM table1 WHERE id >= $1 ORDER BY id'.

	result := statement query: #( 345 ).
	self assert: result records equals: #( ('Greetings' false) ('From Mars' true ) ).
	
	result := statement query: #( 567 ).
	self assert: result records equals: #( ('From Mars' true ) ).
	
	result := statement query: #( 800 ).
	self assert: result records equals: #( ).
	
	client execute: 'DROP TABLE table1'
]

{ #category : #tests }
P3FormattedStatementTest >> testStrings [
	| statement string result |
	
	client execute: 'DROP TABLE IF EXISTS table1'.
	client execute: 'CREATE TABLE table1 (id INTEGER, name TEXT)'.
	
	string := 'single '' dounble '' dollar $ backslash \ euro €'.
	
	statement := client format: 'INSERT INTO table1 (id, name) VALUES ($1, $2)'.
	statement execute: { 123. string }.
	
	statement := client format: 'SELECT name FROM table1 WHERE id = $1'.
	result := statement query: { 123 }.
	
	self assert: result firstFieldOfFirstRecord equals: string.
	
	client execute: 'DROP TABLE table1'
]