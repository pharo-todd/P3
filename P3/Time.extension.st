Extension { #name : #Time }

{ #category : #'*P3' }
Time >> p3PrintUsing: delegate on: stream [
	"Print me on stream via double dispatch on delegate.
	Check the implementors of #p3PrintOn:using:"

	delegate printTime: self on: stream
]
