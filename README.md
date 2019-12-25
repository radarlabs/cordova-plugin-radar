![Radar](https://raw.githubusercontent.com/radarlabs/cordova-plugin-radar/master/logo.png)

[![npm version](https://badge.fury.io/js/@radarlabs/cordova-plugin-radar.svg)](https://badge.fury.io/js/@radarlabs/cordova-plugin-radar)

[Radar](https://radar.io) is the location platform for mobile apps.

## Installation

Install the Cordova plugin:

```bash
$ cordova plugin install cordova-plugin-radar
```

Before writing any JavaScript, you must integrate the Radar SDK with your iOS and Android apps by following the *Configure project* and *Add SDK to project* steps in the [SDK documentation](https://radar.io/documentation/sdk).

On iOS, you must add location usage descriptions and background modes to your `Info.plist`. Initialize the SDK in `application:didFinishLaunchingWithOptions:` in `AppDelegate.m`, passing in your publishable API key.

```objc
#import <RadarSDK/RadarSDK.h>

// ...

[Radar initializeWithPublishableKey:publishableKey];
```

On Android, you must add the Google Play Services library to your project. Initialize the SDK in `onCreate()` in `MainApplication.java`, passing in your publishable API key:

```java
import io.radar.sdk.Radar;

// ...

Radar.initialize(publishableKey);
```

## Usage

### Identify user

Until you identify the user, Radar will automatically identify the user by device ID.

To identify the user when logged in, call:

```js
cordova.plugins.radar.setUserId(userId);
```

where `userId` is a stable unique ID string for the user.

Do not send any PII, like names, email addresses, or publicly available IDs, for `userId`. See [privacy best practices](https://help.radar.io/privacy/what-are-privacy-best-practices-for-radar) for more information.

To set an optional description for the user, displayed in the dashboard, call:

```js
cordova.plugins.radar.setDescription(description);
```

where `description` is a string.

You only need to call these methods once, as these settings will be persisted across app sessions.

### Request permissions

Before tracking the user's location, the user must have granted location permissions for the app.

To determine the whether user has granted location permissions for the app, call:

```js
cordova.plugins.radar.getPermissionsStatus().then((status) => {
  // do something with status
});
```

`status` will be a string, one of:

- `GRANTED`
- `DENIED`
- `UNKNOWN`

To request location permissions for the app, call:

```js
cordova.plugins.radar.requestPermissions(background);
```

where `background` is a boolean indicating whether to request background location permissions or foreground location permissions. On Android, `background` will be ignored.

### Foreground tracking

Once you have initialized the SDK, you have identified the user, and the user has granted permissions, you can track the user's location.

To track the user's location in the foreground, call:

```js
cordova.plugins.radar.trackOnce().then((result) => {
  // do something with result.location, result.events, result.user.geofences
}).catch((err) => {
  // optionally, do something with err
});
```

`err` will be a string, one of:

- `ERROR_PUBLISHABLE_KEY`: the SDK was not initialized
- `ERROR_USER_ID`: the user was not identified
- `ERROR_PERMISSIONS`: the user has not granted location permissions for the app
- `ERROR_LOCATION`: location services were unavailable, or the location request timed out
- `ERROR_NETWORK`: the network was unavailable, or the network connection timed out
- `ERROR_UNAUTHORIZED`: the publishable API key is invalid
- `ERROR_SERVER`: an internal server error occurred
- `ERROR_UNKNOWN`: an unknown error occurred

### Background tracking

Once you have initialized the SDK, you have identified the user, and the user has granted permissions, you can start tracking the user's location in the background.

To start tracking the user's location in the background, call:

```js
cordova.plugins.radar.startTracking();
```

Assuming you have configured your project properly, the SDK will wake up while the user is moving (usually every 3-5 minutes), then shut down when the user stops (usually within 5-10 minutes). To save battery, the SDK will not wake up when stopped, and the user must move at least 100 meters from a stop (sometimes more) to wake up the SDK. **Note that location updates may be delayed significantly by iOS [Low Power Mode](https://support.apple.com/en-us/HT205234), by Android [Doze Mode and App Standby](https://developer.android.com/training/monitoring-device-state/doze-standby.html) and [Background Location Limits](https://developer.android.com/about/versions/oreo/background-location-limits.html), or if the device has connectivity issues, low battery, or wi-fi disabled. These constraints apply to all uses of background location services on iOS and Android, not just Radar. See more about [accuracy and reliability](https://radar.io/documentation/sdk#accuracy).**

To stop tracking the user's location in the background (e.g., when the user logs out), call:

```js
cordova.plugins.radar.stopTracking();
```

You only need to call these methods once, as these settings will be persisted across app sessions.

To listen for events and errors, you can add event listeners:

```js
cordova.plugins.radar.onEvents((events, user) => {
  // do something with events, user
});

cordova.plugins.radar.onError((err) => {
  // do something with err
});
```

You should remove event listeners when you are done with them:

```js
cordova.plugins.radar.offEvents();

cordova.plugins.radar.offError();
```

### Manual tracking

You can manually update the user's location by calling:

```js
const location = {
  latitude: 39.2904,
  longitude: -76.6122,
  accuracy: 65
};

cordova.plugins.radar.updateLocation(location).then((result) => {
  // do something with result.events, result.user.geofences
}).catch((err) => {
  // optionally, do something with err
});
```
