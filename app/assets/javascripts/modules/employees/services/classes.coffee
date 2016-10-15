app = angular.module 'thms.services'

app.factory 'Classes', [ () ->
    class Classes
        get: () ->
            [
                {name: 'A', value: 'A'},
                {name: 'B', value: 'B'},
                {name: 'C', value: 'C'},
                {name: 'D', value: 'D'},
                {name: 'na', value: 'na'}
            ]

    new Classes
]