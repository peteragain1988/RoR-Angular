angular.module('thms.controllers', []);
angular.module('thms.services', []);
angular.module('thms.directives', []);
angular.module('thms.modules.venue', ['ui.router', 'restangular']);
angular.module('thms.modules.client', ['ui.router']);

angular.module('thms', [
  'thms.services',
  'thms.directives',
  'thms.modules.venue',
  'thms.modules.client',
  'thms.controllers',
  'templates',
  'ui.bootstrap',
  'ui.router',
  'ui.utils',
  'LocalStorageModule',
  'LocalForageModule',
//  Tooltips broken in 1.3 until fix
//  'ngAnimate',
  'ngSanitize',
  'ngDragDrop',
  'jmdobry.angular-cache',
  'angularMoment',
  'angularFileUpload',
  'newrelic-timing',
  'rails',
  'angular-medium-editor'
]);

angular.module('thms').constant('angularMomentConfig', {
  preprocess: 'unix',
  timezone: 'Etc/UTC'
});

angular.module('thms').config(['$compileProvider', function ($compileProvider) {
  // Speed Up the app, should only do this in production - uncomment when we reach angular 1.3
  $compileProvider.debugInfoEnabled(false);
}]);

angular.module('thms').config(['$stateProvider', '$urlRouterProvider', '$localForageProvider', '$locationProvider', 'RestangularProvider', function ($stateProvider, $urlRouterProvider, $localForageProvider, $locationProvider, RestangularProvider) {

    RestangularProvider.setBaseUrl('/api/v1');

    $locationProvider.html5Mode({
      enabled: true,
      requireBase: false
    });

    $localForageProvider.config({
      name: 'EventHub'
    });

    $urlRouterProvider.otherwise('/');

    $stateProvider
      .state('redraw', {
        controller: [ '$state', function($state) {
          $state.go('authenticated.main.home')
        }],
        data: {
          requireLogin: true
        }
      })
      .state('guest', {
        abstract: true,
        templateUrl: 'layouts/guest.html',
        data: {
          requireLogin: false
        }
      })
      .state('guest.login', {
        url: '/login',
        views: {
          "content": {
            templateUrl: 'login.html',
            controller: 'LoginWindowCtrl'
          }
        }
      })
      .state('guest.confirm', {
          url: '/confirm/:token',
          views: {
            'content': {
              templateUrl: 'employees/confirm.html',
              controller: 'ConfirmUserCtrl'
            }
      }})
      .state('guest.password_reset_request', {
        url: '/reset/password',
        views: {
          "content": {
            templateUrl: 'resetPasswordRequest.html',
            controller: ['$scope', '$http', '$state', '$humane', function ($scope, $http, $state, $humane) {
              $scope.data = {
                email: ''
              };

              $scope.sendRequest = function (data) {
                $http.post('/api/v1/security/request_password_reset', data).success(function (result) {
                  $state.go('guest.login');
                  $humane.stickyError("Request Sent - Check your Email")
                }).error(function (error, statusCode) {
                  console.log(statusCode)
                })
              }
            }]
          }
        }
      })
      .state('guest.reset_password', {
        url: '/reset/password/:token',
        views: {
          "content": {
            templateUrl: 'resetPassword.html',
            controller: 'ResetPasswordCtrl'
          }
        }
      })

      .state('authenticated', {
          abstract: true,
          templateUrl: 'layouts/authenticated.html',
              data: {
                requireLogin: true
              }
        })

        .state('anz_authenticated', {
            abstract: true,
            templateUrl: 'layouts/anz_authenticated.html',
                data: {
                    requireLogin: false
                }
        })

      .state('authenticated.main', {
        views: {
          "user-menu@authenticated": {
            templateUrl: 'navigation/user_header_menu.html'
          },
          "main-navigation@authenticated": {
            templateProvider: ['Auth', '$templateCache', function(Auth, $templateCache) {

              //TODO Fix up the serilasizer so i return a 'role' string instead of having to parse this shit.
              if (Auth.currentUser.permissions['venue_admin?']) {
                return $templateCache.get('navigation/venue_admin_navigation.html')
              } else if (Auth.currentUser.permissions['client_admin?']) {
                return $templateCache.get('navigation/client_navigation.html')
              } else {
                // TODO we should actually return a name for when you are a standard user.
                return $templateCache.get('navigation/standard_navigation.html')
              }
            }]
          }
        }
      })
      .state('anz_authenticated.main', {
         views: {
          "user-menu@anz_authenticated": {
            templateUrl: 'navigation/anz_header_menu.html'
          },
          "main-navigation@anz_authenticated": {
            templateProvider: ['Auth', '$templateCache', function(Auth, $templateCache) {

              //TODO Fix up the serilasizer so i return a 'role' string instead of having to parse this shit.
              //if (Auth.currentUser.permissions['venue_admin?']) {
                //return $templateCache.get('navigation/anz_admin_navigation.html')
              //} else if (Auth.currentUser.permissions['client_admin?']) {
              //  return $templateCache.get('navigation/client_navigation.html')
              //} else {
                // TODO we should actually return a name for when you are a standard user.
              //  return $templateCache.get('navigation/standard_navigation.html')
              //}
            }]
          }
        }
      })

      .state('authenticated.main.home', {
        url: '/',
        views: {
          "content@authenticated": {
            templateProvider: ['Auth', '$templateCache', function (Auth, $templateCache) {
              if (Auth.currentUser.company.company_type == 'venue') {
                return $templateCache.get('dashboard/venue.html')
              } else {
                return "<div class='panel'></div>"
              }
            }],
            controller: 'MainDashboardCtrl'
          },
          "header@authenticated": {
            templateUrl: 'dashboard/_header_main.html'
          }


        }
      })

      .state('authenticated.main.home.debug', {
        url: '/debug',
        views: {
          "content@authenticated": {
            templateUrl: 'dashboard/debug.html',
            controller: [
              '$scope', '$http', '$modal', '$humane', function ($scope, $http, $modal, $humane) {
                $scope.reloadData = function () {
                  $http.get('/api/v2/tickets/manual').success(function (data) {
                    $scope.inventory = data
                  });
                };

                $scope.reloadData();

				var model = {};
				$scope.model = model;
				
				// This property is bound to the checkbox in the table header
				model.allItemsSelected = false;

				$scope.selectAll = function () {
				    // Loop through all the entities and set their isChecked property
				    for (var i = 0; i < $scope.inventory.length; i++) {
				        $scope.inventory[i].done = model.allItemsSelected;
				    }
				};
				
				$scope.selectItem = function () {
				    for (var i = 0; i < $scope.inventory.length; i++) {
				        if (!$scope.inventory[i].done) {
				            model.allItemsSelected = false;
				            return;
				        }
				    }
				    model.allItemsSelected = true;
				};
				
				$scope.showDetail = function (inventory) {
				    if(inventory.status=="Success"){
				    	$humane.stickySuccess(inventory.detail_msg);
				    }else{
				    	$humane.stickyError(inventory.detail_msg);
				    }
				};
				
				var createCount;
			    var createItemIndexes = new Array();
				    
				$scope.createAllTickets = function () {
				    createCount = 0;
				    createItemIndexes = new Array();
				    for (var i = 0; i < $scope.inventory.length; i++) {
				    	//$scope.inventory[i].status = "";
				    	if($scope.inventory[i].done) {
			    			createItemIndexes.push(i);
				    		createCount++;
				    	}
				    }
				    
				    if(createCount == 0){
				    	alert("No Item Selected")
				    }else{
				    	
				    	$scope.inTotalProgress = true;
					    for (var i = 0; i < $scope.inventory.length; i++) {
					    	if($scope.inventory[i].done)
				    		{
				    			$scope.inventory[i].done = false;
				    			model.allItemsSelected = false;
				    			$http.post('/api/v2/tickets/manual', {inventory_id: $scope.inventory[i].id, inventory_index: i})
				    			.success(function (results, status, headers, config) {
		                            //$scope.inventory[results['index']].status = "Success";
		                            $scope.inventory[results['index']].status_style = "ticket_success";
		                            $scope.inventory[results['index']].createdCount = results['total_created'];
		                            $scope.inventory[results['index']].detail_msg = results['total_created'] + " Tickets Created";
		                            $scope.inventory[results['index']].ticket_count +=results['total_created'];
		                            
					    			var allCompleted=0, successCount = 0, failCount = 0, totalCreated =0;
		                            for (var i = 0; i < createCount; i++) {
						    			if($scope.inventory[createItemIndexes[i]].status == "Success") {
						    				allCompleted ++;
						    				totalCreated+=$scope.inventory[createItemIndexes[i]].createdCount;
						    				successCount++;
						    			}
						    			if($scope.inventory[createItemIndexes[i]].status == "Fail"){
						    				allCompleted ++;
						    				failCount++;
						    			}
							    		if(allCompleted == createCount){
							    			$scope.inTotalProgress = false;
							    			var msg = successCount+" Success "+failCount+" Fail \n"+totalCreated+" Tickets Created";
								    		$humane.stickySuccess(msg);
								    	}
							    	}
		                       	}).error(function (error, status, headers, config) {
		                            //$scope.inventory[results['index']].status = "Fail";
		                            $scope.inventory[results['index']].status_style = "ticket_fail";
		                            $scope.inventory[results['index']].detail_msg = error;
		                            
					    			var allCompleted=0, successCount = 0, failCount = 0, totalCreated =0;
		                            for (var i = 0; i < createCount; i++) {
						    			if($scope.inventory[createItemIndexes[i]].status == "Success") {
						    				allCompleted ++;
						    				totalCreated+=$scope.inventory[createItemIndexes[i]].createdCount;
						    				successCount++;
						    			}
						    			if($scope.inventory[createItemIndexes[i]].status == "Fail"){
						    				allCompleted ++;
						    				failCount++;
						    			}
							    		if(allCompleted == createCount){
							    			$scope.inTotalProgress = false;
							    			var msg = successCount+" Success "+failCount+" Fail \n"+totalCreated+" Tickets Created";
								    		$humane.stickySuccess(msg);
								    	}
							    	}
		                        })
				    		}
					    }
				    }
				};
				
				
                $scope.createTickets = function (inventory) {
                  console.log(inventory);
				  $scope.inventory.status = "";
                  
                  var modal = $modal.open({
                    templateUrl: 'dashboard/_modal_manual_ticket_create.html',
                    windowClass: 'effect-8',
                    controller: [
                      '$scope', '$http', '$humane', function ($scope, $http, $humane) {
                        $scope.inventory = inventory;

                        $scope.requestManual = function (ticketekEventCode) {
                          $scope.inProgress = true;

                          $http.post('/api/v2/tickets/request', {event_code: ticketekEventCode, inventory_id: inventory.id})
                            .success(function (results) {
                              $humane.stickySuccess(results['total_requested'] + " Tickets Requested");
                              $scope.$close();
                            })
                            .error(function (error) {
                              $scope.inProgress = false;
                              $humane.stickyError(error);
                            })
                        };


                        $scope.createManual = function (ticketPrefix) {
                          $scope.inProgress = true;
                          $http.post('/api/v2/tickets/manual', {prefix: ticketPrefix, inventory_id: inventory.id}).success(function (results, status, headers, config) {
                            $scope.inProgress = false;
                            $humane.stickySuccess(results['total_created'] + " Tickets Created");
                            //$scope.inventory.status = "Success";
                            $scope.inventory.status_style = "ticket_success";
                            $scope.inventory.detail_msg = results['total_created'] + " Tickets Created";
                            $scope.inventory.ticket_count +=results['total_created'];
                            $scope.$close();
                          }).error(function (error, status, headers, config) {
                            $scope.inProgress = false;
                           // $scope.inventory.status = "Fail";
                            $scope.inventory.status_style = "ticket_fail";
                            $scope.inventory.detail_msg = error;
                            $humane.stickyError(error);
                          })
                        }
                      }
                    ]
                  });

                  modal.result.then(function (results) {
                    console.log(results);
                    //$scope.reloadData();
                  })
                }
              }
            ]
          }
        }
      })

      // Inventory
      .state('authenticated.main.inventory', {
        abstract: true,
        template: "<ui-view></ui-view>"
      })

      .state('authenticated.main.inventory.confirmOptions.snacks', {
        url: '/snacks',
        views: {
          "step": {
            templateUrl: 'inventory/confirm_snacks.html'
          }
        }
      })

      .state('authenticated.main.inventory.confirmOptions.details', {
        url: '/details',
        views: {
          "step": {
            templateUrl: 'inventory/confirm_host_details.html'
          }
        }
      })

      .state('authenticated.main.inventory.confirmOptions.attendance', {
        url: '/attendance',
        views: {
          "step": {
            templateUrl: 'inventory/confirm_attendance.html'
          }
        }
      })

      .state('authenticated.main.inventory.confirmOptions.parking', {
        url: '/parking',
        views: {
          "step": {
            templateUrl: 'inventory/confirm_parking.html'
          }
        }
      })

      .state('authenticated.main.inventory.confirmOptions.review', {
        url: '/review',
        views: {
          "step": {
            templateUrl: 'inventory/confirm_review.html'
          }
        }
      })

      .state('authenticated.main.inventory.confirmOptions.drinks', {
        url: '/drinks',
        views: {
          "step": {
            templateUrl: 'inventory/confirm_drinks.html'
          }
        }
      })

      .state('authenticated.main.inventory.confirmOptions.menu', {
        url: '/menus',
        views: {
          "step": {
            templateUrl: 'inventory/confirm_menu.html'
          }
        }
      })

      .state('authenticated.main.inventory.confirmOptions', {
        url: '/my/options/:id/confirm',
        resolve: {
          details: ['$stateParams', 'Auth', 'Restangular', function ($stateParams, Auth, Restangular) {
            return Restangular.one('companies', Auth.currentUser.company.id).one('inventory', $stateParams.id).get();
          }]

        },
        views: {
          "content@authenticated": {
            templateUrl: 'inventory/confirm_options.html',
            controller: 'ConfirmOptionsController'
          },
          "header@authenticated": {
            template: "<h1>Confirm Options</h1>"
          }
        }
      })

      .state('authenticated.main.inventory.add', {
        url: '/inventory/add',
        resolve: {
          data: ['$http', 'Auth', '$stateParams', function ($http, Restangular, $stateParams) {
            return $http.get('/api/v1/my/events/dates/' + $stateParams['id'] + '/release');
          }]
        },
        views: {
          "content@authenticated": {
            templateUrl: 'inventory/add.html',
            controller: ['$scope', 'data', function ($scope, data) {
              console.log(data)
            }]

          },
          "header@authenticated": {
            template: "<h1>Release Event</h1>"
          }
        }
      })

      .state('authenticated.main.audit', {
        abstract: true,
        template: '<ui-view></ui-view>'
      })

      .state('authenticated.main.inventory.release', {
        url: '/inventory/:id/release',
        abstract: 'true',
        template: '<ui-view></ui-view>'
      })

      .state('authenticated.main.inventory.release.identifyClass', {
        url: '/class',
        views: {
          "content@authenticated": {
            templateUrl: 'client-module/release_to_team_class.html'
          }
        }
      })

      .state('authenticated.main.inventory.release.allocateBusinessUnits', {
        url: '/allocate',
        views: {
          "content@authenticated": {
            templateUrl: 'client-module/release_to_team_business_unit.html'
          }
        }
      })

      .state('authenticated.main.inventory.release.releaseExpiry', {
        url: '/expiry',
        views: {
          "content@authenticated": {
            templateUrl: 'client-module/release_to_team_release_expiry.html'
          }
        }
      })

      .state('authenticated.main.inventory.release.automateInvitations', {
        url: '/invitations',
        views: {
          "content@authenticated": {
            templateUrl: 'client-module/release_to_team_automate_invitations.html'
          }
        }
      })

}])
