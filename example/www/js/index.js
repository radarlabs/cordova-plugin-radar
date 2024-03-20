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
	initialize: function () {
		document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
		document.addEventListener('pause', cordova.plugins.radar.logResigningActive(), false);
		// logBackgrounding() and logTermination() (iOS only) should be added to native callbacks 
	},

	log: function (newValue) {
		let textArea = document.getElementById('console');
		textArea.value = textArea.value + '\n\n' + newValue;
		console.log(newValue);
	},

	onDeviceReady: function () {
		cordova.plugins.radar.initialize('prj_test_pk_0000000000000000000000000000000000000000');
		cordova.plugins.radar.setUserId('cordova');
		cordova.plugins.radar.setDescription("cordova plugin test");
		cordova.plugins.radar.setLogLevel('info');
		cordova.plugins.radar.setMetadata({
			foo: 'bar',
		});
		cordova.plugins.radar.setAnonymousTrackingEnabled(false);

		cordova.plugins.radar.getLocation('low', (result) => {
			this.log("getLocation: " + JSON.stringify(result));
		});
		cordova.plugins.radar.getUserId((result) => {
			this.log("getUserId: " + JSON.stringify(result));
		});
		cordova.plugins.radar.getDescription((result) => {
			this.log("getDescription: " + JSON.stringify(result));
		});
		cordova.plugins.radar.getMetadata((result) => {
			this.log("getMetadata: " + JSON.stringify(result));
		});
		cordova.plugins.radar.getHost((result) => {
			this.log("getHost: " + JSON.stringify(result));
		});
		cordova.plugins.radar.getPublishableKey((result) => {
			this.log("getPublishableKey: " + JSON.stringify(result));
		});
		cordova.plugins.radar.isUsingRemoteTrackingOptions((result) => {
			this.log("isUsingRemoteTrackingOptions: " + JSON.stringify(result));
		});
		cordova.plugins.radar.setNotificationOptions({ iconString: 'icon' });
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
			this.log("getPermissionsStatus: " + JSON.stringify(result));
		});
		cordova.plugins.radar.onToken((result) => {
			this.log("token: " + JSON.stringify(result));
		})
		cordova.plugins.radar.trackOnce({ desiredAccuracy: "medium", beacons: true }, (result) => {
			this.log("trackOnce: " + JSON.stringify(result));
		});
		cordova.plugins.radar.trackVerified((result) => {
			this.log("trackVerified: " + JSON.stringify(result));
		});
		cordova.plugins.radar.trackVerifiedToken((result) => {
			this.log("trackVerifiedToken: " + JSON.stringify(result));
		});
		cordova.plugins.radar.isTracking((result) => {
			this.log("isTracking: " + JSON.stringify(result));
		})
		cordova.plugins.radar.startTrackingContinuous();
		cordova.plugins.radar.startTrackingVerified();
		cordova.plugins.radar.getTrackingOptions((result) => {
			this.log("getTrackingOptions: " + JSON.stringify(result));
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
			this.log("searchPlaces: " + JSON.stringify(result));
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
			this.log("startTrip: " + JSON.stringify(result));

			cordova.plugins.radar.getTripOptions((result) => {
				this.log(">getTripOptions: " + JSON.stringify(result));

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
					this.log("updateTrip: " + JSON.stringify(result));

					cordova.plugins.radar.getTripOptions((result) => {
						this.log(">>getTripOptions:" + JSON.stringify(result));

						cordova.plugins.radar.cancelTrip((result) => {
							this.log("cancelTrip:" + JSON.stringify(result));
						});
					});
				});
			});
		});

		cordova.plugins.radar.getTripOptions((result) => {
			this.log("getTripOptions: " + JSON.stringify(result));
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
			this.log("getMatrix: " + JSON.stringify(result));
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
			this.log("autocomplete: " + JSON.stringify(result));
		});
		cordova.plugins.radar.logConversion({
			name: "in_app_purchase",
			metadata: { "price": "150USD" }
		}, (result) => {
			this.log("logConversion: " + JSON.stringify(result));
		});
	},

};

app.initialize();
