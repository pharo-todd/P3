Extension { #name : #DateAndTime }

{ #category : #'*P3' }
DateAndTime >> p3PrintUsing: delegate on: stream [
	"Print me on stream via double dispatch on delegate.
	Check the implementors of #p3PrintOn:using:"

	delegate printDateAndTime: self on: stream
]
