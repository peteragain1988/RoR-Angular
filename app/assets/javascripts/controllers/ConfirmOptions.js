angular.module('thms.controllers').controller('ConfirmOptionsController',[
  '$scope', '$state', 'FootyOptions', 'BillyConnolly', 'Drake', 'The_Eagles', '$modal', 'details', '$humane', 'Tickets', 'Ricky_Martin', 'Russel_Peters', 'Walking_With_Dinosaurs',
  function ($scope, $state, FootyOptions, BillyConnolly, Drake, The_Eagles, $modal, details, $humane, Tickets, Ricky_Martin, Russel_Peters, Walking_With_Dinosaurs) {
    $scope.confirmButtonDisabled = false;
    $scope.confirmButtonText = "Confirm";

    if (details.event_name == 'THE FOOTY SHOW FIGHT NIGHT') {
      $scope.Options = FootyOptions;
    } else if (details.event_name == 'BILLY CONNOLLY') {
      $scope.Options = BillyConnolly;
    } else if (details.event_name == 'DRAKE') {
      $scope.Options = Drake;
    } else if (details.event_name == 'THE EAGLES') {
      $scope.Options =  The_Eagles;
    } else if (details.event_name == 'RICKY MARTIN ONE WORLD TOUR') {
      $scope.Options =  Ricky_Martin;
    } else if (details.event_name == 'RUSSELL PETERS - Almost Famous World Tour') {
        $scope.Options = Russel_Peters;
    } else if (details.event_name == 'Walking With Dinosaurs The Arena Spectacular') {
        $scope.Options = Walking_With_Dinosaurs;
    } else {
      console.log('bang, something went wrong')
    }

    $scope.details = details;

    $state.go('authenticated.main.inventory.confirmOptions.attendance');

    $scope.confirmDrink = function(item) {
      console.log(item.name + " requested");
      item.count = 1;
      item.requested = true;
    };

    $scope.unConfirmDrink = function(item) {
      console.log(item.name + " de-requested");
      item.count = 0;
      item.requested = false;
    };

    $scope.increment = function (snack) {
      if (snack.count == undefined) {
        snack.count = 0
      }
      snack.count = snack.count + 1;
    };

    $scope.decrement = function (snack) {
      if (snack.count == undefined) {
        snack.count = 0
      }
      if (snack.count >= 0) {
        snack.count = snack.count - 1;
      }
    };

    $scope.goToSnackSelection = function(backwards) {

      if ($scope.Options.snacks.hidden) {
        if (backwards) {
          $state.go('authenticated.main.inventory.confirmOptions.drinks')
        } else {
          $state.go('authenticated.main.inventory.confirmOptions.parking');
        }
      } else {
        if (backwards) {
          $state.go('authenticated.main.inventory.confirmOptions.snacks')
        } else {
          var modal = $modal.open({
            templateUrl: 'inventory/_modal_snack_conditions.html',
            windowClass: 'effect-10'
          });

          modal.result.then(function(result) {
            $state.go('authenticated.main.inventory.confirmOptions.snacks')
          })
        }
      }
    };


    $scope.selectMenu = function (menu) {
      $scope.Options.selectedOptions.selection.menu = menu;

      if (menu.doesntHaveDrinksPackage == true) {
        $state.go('authenticated.main.inventory.confirmOptions.drinks');
        return;
      }

      var modalInstance = $modal.open({
        templateUrl: 'inventory/_modal_drinksChoices.html',
        controller: [
          '$scope', 'FootyOptions', 'BillyConnolly', 'Drake', 'The_Eagles',
          function ($scope, FootyOptions, BillyConnolly, Drake, The_Eagles) {

        if (details.event_name == 'THE FOOTY SHOW FIGHT NIGHT') {
          $scope.Options = FootyOptions;
        } else if (details.event_name == 'BILLY CONNOLLY') {
          $scope.Options = BillyConnolly;
        } else if (details.event_name == 'DRAKE') {
          $scope.Options = Drake;
        } else if (details.event_name == 'THE EAGLES') {
          $scope.Options =  The_Eagles;
        } else {
          console.log('bang, something went wrong')
        }

          $scope.next = function () {
            $scope.$close();
            $state.go('authenticated.main.inventory.confirmOptions.drinks')
          }

        }]
      });

    };

    $scope.openModalForItemImage = function(item) {
      var modal = $modal.open({
        template: '"<div class="panel" style="display: flex"><img style="width: auto; max-height: 800px; margin: 0 auto;" src="'+ item.data.image.file_name +'"/></div>',
        windowClass: "effect-8 narrow"
      })
    };

    $scope.notComing = function () {
      $scope.Options.buildSelections();
      $scope.Options.selectedOptions.selection.notComing = true;
      $scope.Options.selectedOptions.inventory_id = $state.params['id'];
      $scope.Options.submitSelections();
    };

    $scope.createNewParkingReservation = function () {
      $scope.Options.parking.push({});
    };

    $scope.buildOptions = function () {
      $scope.Options.buildSelections();
      $state.go('authenticated.main.inventory.confirmOptions.review');
    };

    $scope.wantStandardDrinksMenu = function() {
      $scope.Options.selectedOptions.selection.standardDrinkList = true;
      if ($scope.Options.snacks.hidden) {
        $state.go('authenticated.main.inventory.confirmOptions.parking');
      } else {
        $state.go('authenticated.main.inventory.confirmOptions.snacks');
      }
    };

    $scope.confirmChoices = function () {
      $scope.confirmButtonDisabled = true;
      $scope.confirmButtonText = "Please Wait...";

      // important
      $scope.Options.selectedOptions.is_attending = true;

      $scope.Options.selectedOptions.inventory_id = $state.params['id'];
      $scope.Options.submitSelections();
    };

    $scope.$root.$on('options:selections:saved', function (event, data) {

      if ($scope.Options.selectedOptions.is_attending) {
        var modal = $modal.open({
          templateUrl: 'inventory/_modal_guest_names.html',
          windowClass: 'effect-0',
//        backdrop: 'static',
          resolve: {
            confirmation: [
              'InventoryConfirmation', function(InventoryConfirmation) {
                return InventoryConfirmation.view(data.inventory_id)
              }
            ]
          },
          controller: [
            '$scope', 'confirmation', 'InventoryConfirmation', function($scope, confirmation, InventoryConfirmation) {
              $scope.confirmation = confirmation.data;
              if ($scope.confirmation.guests.length === 0) {
                $scope.guestList = [
                  {
                    name: ''
                  }
                ];
              } else {
                $scope.guestList = $scope.confirmation.guests;
              }
              $scope.addNewGuestName = function() {
                return $scope.guestList.push({
                  name: ''
                });
              };

              $scope.save = function() {
                $scope.confirmation.guests = $scope.guestList;
                InventoryConfirmation.update($scope.confirmation).then(function(result) {
                  $scope.$close();
                }).catch(function(error) {
                  return $scope.$close();
                });
              };
            }
          ]
        });

        modal.result.then(function(result) {
          $state.go('authenticated.main.event.client.index');
          $humane.stickySuccess('Options Confirmed Successfully');
          // they have confirmed guests or something
          Tickets.addMagicalTickets();
        });
      } else {

        // they arent coming
        $state.go('authenticated.main.event.client.index');
        $humane.stickySuccess('Options Confirmed Successfully');
      }

    })

  }]);