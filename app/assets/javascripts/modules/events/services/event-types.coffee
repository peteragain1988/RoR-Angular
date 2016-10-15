app = angular.module 'thms.services'

app.factory 'EventTypes', [ () ->
    class EventTypes
        get: () ->
            [
                {name: 'Circus', value: 'Circus'},
                {name: 'Live Event', value: 'Live Event'},
                {name: 'Sports', value: 'Sports'},
                {name: 'Children Entertainment', value: 'Children Entertainment'}
            ]

    new EventTypes
]