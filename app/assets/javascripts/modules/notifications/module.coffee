app = angular.module 'thms.modules.venue'

#= controllers

app.config [
  '$stateProvider', ($stateProvider) ->
    $stateProvider
    .state 'authenticated.main.notifications',
      abstract: true
      template: '<ui-view></ui-view>'

    .state 'authenticated.main.notifications.index',
      url: '/notifications'
      resolve:
        data: [
          'Companies', (Companies) ->
            Companies.sync()
        ]
      views:
        'content@authenticated':
          templateUrl: 'notifications/index.html'
          controller: 'NotificationIndexCtrl'
        'header@authenticated':
          template: '<h1>Notification Center</h1>'

    .state 'authenticated.main.notifications.templates',
        abstract: true
        template: '<ui-view></ui-view>'

    .state 'authenticated.main.notifications.templates.index',
        url: '/notifications/templates'
        resolve:
            templates: [
                'MailTemplate', (MailTemplate) -> MailTemplate.query()
            ]
        views:
            'content@authenticated':
                templateUrl: 'notifications/templates/index.html'
                controller: 'MailTemplateIndexCtrl'
            'header@authenticated':
                template: '<h1>Notification Center</h1>'

    .state 'authenticated.main.notifications.templates.new',
        url: '/notifications/templates/new'
        resolve:
            template: [
                'MailTemplate', (MailTemplate) ->
                    new MailTemplate()
            ]
        views:
            'content@authenticated':
                templateUrl: 'notifications/templates/new.html'
                controller: 'MailTemplateNewCtrl'
            'header@authenticated':
                template: '<h1>Notification Center</h1>'

    .state 'authenticated.main.notifications.templates.edit',
        url: '/notifications/templates/:id/edit'
        resolve:
            template: [
                'MailTemplate','$stateParams', (MailTemplate, $stateParams) ->
                    MailTemplate.get $stateParams.id
            ]
        views:
            'content@authenticated':
                templateUrl: 'notifications/templates/new.html'
                controller: 'MailTemplateNewCtrl'
            'header@authenticated':
                template: '<h1>Notification Center</h1>'

    .state 'authenticated.main.notifications.templates.send',
        url: '/notifications/templates/:id/send'
        resolve:
            data: [
                '$http', '$stateParams', ($http, $stateProvider) ->
                    $http.get "/api/v2/mail_templates/#{$stateProvider.id}/send"
            ]
        views:
            'content@authenticated':
                templateUrl: 'notifications/templates/send.html'
                controller: 'MailTemplateSendCtrl'
            'header@authenticated':
                template: '<h1>Notification Center</h1>'

#    .state 'authenticated.main.notifications.template.send.selectEventDate'
#        views:
#            'step':
#                template: '<h1>Ooo</h1>'
]