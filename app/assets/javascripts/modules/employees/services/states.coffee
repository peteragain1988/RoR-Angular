app = angular.module 'thms.services'

app.factory 'States', [ () ->
    class States
        get: () ->
            [
                {name: 'NSW', value: 'NSW'},
                {name: 'VIC', value: 'VIC'},
                {name: 'QLD', value: 'QLD'},
                {name: 'SA', value: 'SA'},
                {name: 'NT', value: 'NT'},
                {name: 'ACT', value: 'ACT'},
                {name: 'WA', value: 'WA'}
            ]

    new States
]