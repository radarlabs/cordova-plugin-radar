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
		cordova.plugins.radar.setUserId('cordova');
		/*
		cordova.plugins.radar.trackOnce((result) => {
		  alert(JSON.stringify(result));
		});
		*/
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
		/*
		cordova.plugins.radar.getPermissionsStatus((status) => {
			alert(JSON.stringify(status));
		});
		cordova.plugins.radar.trackOnce((result) => {
		  alert(JSON.stringify(result));
		});
		cordova.plugins.radar.searchPlaces({
			radius: 10000,
			chains: ['starbucks'],
			limit: 10,
		}, (result) => {
			alert(JSON.stringify(result));
		});
		*/
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
			externalId: '399',
			metadata: {
				name: 'Nick Patrick'
			},
			destinationGeofenceTag: 'store',
			destinationExternalId: '123',
			mode: 'foot'
		}, (result) => {
			alert(JSON.stringify(result));

			cordova.plugins.radar.getTripOptions((result) => {
				alert(JSON.stringify(result));

				cordova.plugins.radar.updateTrip({
					options: {
						externalId: '399',
						metadata: {
							name: 'Nick Patrick'
						},
						destinationGeofenceTag: 'store',
						destinationExternalId: '123',
						mode: 'bike'
					},
					status: 'unknown'
				}, (result) => {
					alert(JSON.stringify(result));
	
					cordova.plugins.radar.getTripOptions((result) => {
						alert(JSON.stringify(result));

						cordova.plugins.radar.cancelTrip((result) => {
							alert(JSON.stringify(result));
						});
					});
				});
			});
		});

		cordova.plugins.radar.getTripOptions((result) => {
			alert(JSON.stringify(result));
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
			alert(JSON.stringify(result));
		});

		cordova.plugins.radar.startForegroundService({
			title: 'Foo',
			text: 'Bar'
		});
		setTimeout(() => {
			cordova.plugins.radar.stopForegroundService();
		}, 10000);
	},

};

app.initialize();
