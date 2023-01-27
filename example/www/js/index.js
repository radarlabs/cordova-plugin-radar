/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
	// Application Constructor
	initialize: function() {
		document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
	},

	onDeviceReady: function() {
		cordova.plugins.radar.initialize('prj_test_pk_000000000000000000000000000');
		cordova.plugins.radar.setUserId('cordova');
		cordova.plugins.radar.setDescription("cordova plugin test");
		cordova.plugins.radar.setLogLevel('info');
		cordova.plugins.radar.setMetadata({
      foo: 'bar',
    });
		cordova.plugins.radar.setAdIdEnabled(true);
		cordova.plugins.radar.setAnonymousTrackingEnabled(false);
		
		cordova.plugins.radar.getLocation('low', (result) => {
		  console.log("getLocation: ", result);
		});
		cordova.plugins.radar.getUserId((result) => {
			console.log("getUserId: ", result);
		});
		cordova.plugins.radar.getDescription((result) => {
			console.log("getDescription: ", result);
		});		
		cordova.plugins.radar.getMetadata((result) => {
			console.log("getMetadata: ", result);
		});		
		// cordova.plugins.radar.startTrackingContinuous();
		// cordova.plugins.radar.stopTracking();
		/*
		cordova.plugins.radar.onEvents((events, user) => {
			alert(JSON.stringify(events));
			alert(JSON.stringify(user));
		});
		cordova.plugins.radar.onClientLocation((location, stopped, source) => {
			alert(JSON.stringify(location));
			alert(JSON.stringify(stopped));
			alert(JSON.stringify(source));
		});
		cordova.plugins.radar.onError((err) => {
			alert(JSON.stringify(err));
		});
		*/
		cordova.plugins.radar.requestPermissions(true);
		cordova.plugins.radar.getPermissionsStatus((result) => {
		  console.log("getPermissionsStatus: ", result);
		});
		cordova.plugins.radar.trackOnce({ desiredAccuracy: "medium", beacons: true }, (result) => {
		  console.log("trackOnce", result);
		});
		cordova.plugins.radar.isTracking((result) => {
			console.log("isTracking", result);
		})
		cordova.plugins.radar.startTrackingContinuous();
		cordova.plugins.radar.getTrackingOptions((result) => {
			console.log("getTrackingOptions", result);
		});
		cordova.plugins.radar.searchPlaces({
      near: {
        'latitude': 40.783826,
        'longitude': -73.975363,
      },
      radius: 1000,
      chains: ["starbucks"],
      chainMetadata: {
        "customFlag": "true"
      },
      limit: 10,
		}, (result) => {
			console.log("searchPlaces", result);
		});
		/*
		cordova.plugins.radar.getDistance({
		  origin: {
		    latitude: 40.78382,
		    longitude: -73.97536
		  },
		  destination: {
		    latitude: 40.70390,
		    longitude: -73.98670
		  },
		  modes: [
		    'foot',
		    'car'
		  ],
		  units: 'imperial'
		}, (result) => {
		  alert(JSON.stringify(result));
		});
		*/
		/*
		cordova.plugins.radar.trackOnce({
			latitude: 37.4219999,
			longitude: -122.084057,
			accuracy: 65
		}, (result) => {
			alert(JSON.stringify(result));
		});
		cordova.plugins.radar.startTrackingEfficient();
		*/
		/*
		cordova.plugins.radar.ipGeocode((result) => {
			alert(JSON.stringify(result));
		});
		*/
		cordova.plugins.radar.startTrip({
			tripOptions: {
				externalId: "399",
				destinationGeofenceTag: "store",
				destinationGeofenceExternalId: "123",
				mode: "car",
			},
			trackingOptions: {
				"desiredStoppedUpdateInterval": 30,
				"fastestStoppedUpdateInterval": 30,
				"desiredMovingUpdateInterval": 30,
				"fastestMovingUpdateInterval": 30,
				"desiredSyncInterval": 20,
				"desiredAccuracy": "high",
				"stopDuration": 0,
				"stopDistance": 0,
				"replay": "none",
				"sync": "all",
				"showBlueBar": true,
				"useStoppedGeofence": false,
				"stoppedGeofenceRadius": 0,
				"useMovingGeofence": false,
				"movingGeofenceRadius": 0,
				"syncGeofences": false,
				"syncGeofencesLimit": 0,
				"beacons": false,
				"foregroundServiceEnabled": false
			}
		}, (result) => {
			console.log("startTrip: " + JSON.stringify(result));

			cordova.plugins.radar.getTripOptions((result) => {
				console.log(">getTripOptions: " + JSON.stringify(result));

				cordova.plugins.radar.updateTrip({
					options: {
						externalId: '299',
						metadata: {
							name: 'Nick Patrick'
						},
						destinationGeofenceTag: 'store',
						destinationExternalId: '123',
						mode: 'bike'
					},
					status: 'unknown'
				}, (result) => {
					console.log("updateTrip:", JSON.stringify(result));
	
					cordova.plugins.radar.getTripOptions((result) => {
						console.log(">>getTripOptions:", JSON.stringify(result));

						cordova.plugins.radar.cancelTrip((result) => {
							console.log("cancelTrip:", JSON.stringify(result));
						});
					});
				});
			});
		});

		cordova.plugins.radar.getTripOptions((result) => {
			console.log(JSON.stringify(result));
		});
		/*
		let i = 0;
		cordova.plugins.radar.mockTracking({
			origin: {
		    latitude: 40.78382,
		    longitude: -73.97536
		  },
		  destination: {
		    latitude: 40.70390,
		    longitude: -73.98670
		  },
			mode: 'foot',
			steps: 3,
			interval: 3
		}, (result) => {
			alert(JSON.stringify(result));
			if (i == 2) {
				cordova.plugins.radar.stopTrip();
			}
			i++;
		});
		*/

		/*
		cordova.plugins.radar.startTrackingCustom({
		  desiredStoppedUpdateInterval: 180,
		  desiredMovingUpdateInterval: 60,
		  desiredSyncInterval: 50,
		  desiredAccuracy: 'high',
		  stopDuration: 140,
		  stopDistance: 70,
		  sync: 'all',
		  replay: 'none',
		  showBlueBar: true
		});

		setTimeout(() => {
			cordova.plugins.radar.stopTracking();
		}, 60000);
		*/

		cordova.plugins.radar.getMatrix({
			origins: [
				{
					latitude: 40.78382,
					longitude: -73.97536
				}
			],
			destinations: [
				{
					latitude: 40.70390,
					longitude: -73.98670
				},
				{
				  latitude: 40.73237,
					longitude: -73.94884
				}
			],
			mode: 'car',
			units: 'imperial',
		}, (result) => {
			console.log("getMatrix", JSON.stringify(result));
		});
		cordova.plugins.radar.autocomplete({
      query: 'brooklyn roasting',
      near: {
        'latitude': 40.783826,
        'longitude': -73.975363,
      },
      limit: 10,
      layers: ['address', 'street'],
      country: 'US'
    }, (result) => {
			console.log("autocomplete", result);
    });		
		cordova.plugins.radar.sendEvent({
      customType: "in_app_purchase",
      metadata: {"price": "150USD"}
    }, (result) => {
			console.log("sendEvent: ", result);
		});		
	},

};

app.initialize();
