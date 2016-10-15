app = angular.module 'thms.services'

app.factory 'EventStatuses', [ () ->
    class EventStatuses
        get: () ->
            [
                {name: 'Coming Soon', value: 'Coming Soon'},
                {name: 'Open', value: 'Open'},
                {name: 'Closing Soon', value: 'Closing Soon'},
                {name: 'Closed', value: 'Closed'}
            ]

    new EventStatuses
]