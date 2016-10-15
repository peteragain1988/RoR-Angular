app = angular.module 'thms.services'

#app.factory 'Ticket', [
#
#    'RailsResource', 'railsSerializer', (RailsResource, railsSerializer) ->
#        class Ticket extends RailsResource
#            @configure url: '/api/v2/my/tickets', name: 'ticket'
#]

app.factory 'Tickets', ['$http', '$q', 'Ticket', '$humane', ($http, $q, Ticket, $humane) ->
    BASE_URL = '/api/v2/tickets/'

    new class Tickets
        __collection = []

        constructor: ->

        # We sync the tickets the first thing when the page loads.
        count: 0
    ## Retreive all resources
        sync: ->
            deffered = $q.defer()
            __collection = []
            $http.get(BASE_URL)
            .then (results) =>
                __collection.push new Ticket(data.id, data, BASE_URL + data.id, false) for data in results.data
                @count = __collection.length
                deffered.resolve __collection

            .catch (error) ->
                deffered.reject error

            deffered.promise
    # Use a resource from the cache, if we have it
    # Otherwise retrieve it from the api
        view: (id) ->
            defferred = $q.defer()
            element = _.find __collection, (item) ->
                item.id is id

                # resolve the promise if our cache hit
            if element
                defferred.resolve element
            else if id
                # grab the resource from the api if our cache missed
                $http.get(BASE_URL + id)
                .then (result) ->
                    defferred.resolve result.data
                .catch (error) ->
                    defferred.reject error
                # return false if something else didnt happen, i.e: undefined id passed
            else defferred.reject false

            defferred.promise

    # Use a resource from the cache, if we have it
    # Otherwise retrieve it from the api
        view_facility: (facility_name) ->
          defferred = $q.defer()

          # resolve the promise if our cache hit
          if facility_name
            # grab the resource from the api if our cache missed
            $http.get(BASE_URL + "anz/facility/" + facility_name + "?anz=1")
            .then (result) ->
              defferred.resolve result
            .catch (error) ->
              defferred.reject error
            # return false if something else didnt happen, i.e: undefined id passed
          else defferred.reject false

          defferred.promise

    # Use a resource from the cache, if we have it
    # Otherwise retrieve it from the api          
         anz_tickets: (auth_token) ->
          defferred = $q.defer()

          # resolve the promise if our cache hit
          if auth_token
            # grab the resource from the api if our cache missed
            $http.get(BASE_URL + "anz/" + auth_token)
            .then (result) ->
              defferred.resolve result
            .catch (error) ->
              defferred.reject error
            # return false if something else didnt happen, i.e: undefined id passed
          else defferred.reject false

          defferred.promise
]


