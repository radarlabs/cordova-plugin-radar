const cordova = require('cordova');

const exec = (action, args, callback) => {
  cordova.exec(callback,
    (err) => {
      console.error(err, action, args);
    }, 'Radar', action, args);
};

const initialize = (publishableKey) => {
  exec('initialize', [publishableKey]);
}

const setUserId = (userId) => {
  exec('setUserId', [userId]);
};

const getUserId = (callback) => {
  exec("getUserId", null, callback)
}

const setDescription = (description) => {
  exec('setDescription', [description]);
};

const getDescription = (callback) => {
  exec("getDescription", null, callback);
}

const setMetadata = (metadata) => {
  exec('setMetadata', [metadata]);
};

const getMetadata = (callback) => {
  exec('getMetadata', null, callback);
};

const setAnonymousTrackingEnabled = (enabled) => {
  exec('setAnonymousTrackingEnabled', [enabled]);
}

const setAdIdEnabled = (enabled) => {
  exec('setAdIdEnabled', [enabled]);
}

const getPermissionsStatus = (callback) => {
  exec('getPermissionsStatus', null, callback);
};

const requestPermissions = (background) => {
  exec('requestPermissions', [background]);
};

const getLocation = (desiredAccuracy, callback) => {
  exec('getLocation', [desiredAccuracy], callback);
};

const trackOnce = (arg1, arg2) => {
  if (typeof arg1 === 'function') {
    exec('trackOnce', null, arg1);
  } else {
    exec('trackOnce', [arg1], arg2);
  }
};

const startTrackingEfficient = () => {
  exec('startTrackingEfficient');
};

const startTrackingResponsive = () => {
  exec('startTrackingResponsive');
};

const startTrackingContinuous = () => {
  exec('startTrackingContinuous');
};

const startTrackingCustom = (options, callback) => {
  exec('startTrackingCustom', [options], callback);
};

const mockTracking = (options, callback) => {
  exec('mockTracking', [options], callback);
};

const stopTracking = () => {
  exec('stopTracking');
};

const isTracking = (callback) => {
  exec('isTracking', null, callback);
}

const getTrackingOptions = (callback) => {
  exec('getTrackingOptions', null, callback);
}

const onEvents = (callback) => {
  exec('onEvents', null, (data) => {
    callback(data.events, data.user);
  });
};

const onLocation = (callback) => {
  exec('onLocation', null, (data) => {
    callback(data.location, data.user);
  });
};

const onClientLocation = (callback) => {
  exec('onClientLocation', null, (data) => {
    callback(data.location, data.stopped, data.source);
  });
};

const onError = (callback) => {
  exec('onError', null, (data) => {
    callback(data.status);
  });
};

const offEvents = () => {
  exec('offEvents');
};

const offLocation = () => {
  exec('offLocation');
};

const offClientLocation = () => {
  exec('offClientLocation');
};

const offError = () => {
  exec('offEvents');
};

const getTripOptions = (callback) => {
  exec('getTripOptions', null, callback);
};

const startTrip = (options, callback) => {
  exec('startTrip', [options], callback);
};

const updateTrip = (options, callback) => {
  exec('updateTrip', [options], callback);
};

const completeTrip = (callback) => {
  exec('completeTrip', null, callback);
};

const cancelTrip = (callback) => {
  exec('cancelTrip', null, callback);
};

const getContext = (arg1, arg2) => {
  if (typeof arg1 === 'function') {
    exec('getContext', null, arg1);
  } else {
    exec('getContext', [arg1], arg2);
  }
};

const searchPlaces = (options, callback) => {
  exec('searchPlaces', [options], callback);
};

const searchGeofences = (options, callback) => {
  exec('searchGeofences', [options], callback);
};

const autocomplete = (options, callback) => {
  exec('autocomplete', [options], callback);
};

const geocode = (query, callback) => {
  exec('geocode', [query], callback);
};

const reverseGeocode = (arg1, arg2) => {
  if (typeof arg1 === 'function') {
    exec('reverseGeocode', null, arg1);
  } else {
    exec('reverseGeocode', [arg1], arg2);
  }
};

const ipGeocode = (callback) => {
  exec('ipGeocode', null, callback);
};

const getDistance = (options, callback) => {
  exec('getDistance', [options], callback);
};

const getMatrix = (options, callback) => {
  exec('getMatrix', [options], callback);
};

const setForegroundServiceOptions = (args, callback) => {
  exec('setForegroundServiceOptions', [options], callback)
}

const setLogLevel = (logLevel) => {
  exec('setLogLevel', [logLevel]);
};

const sendEvent = (options, callback) => {
  exec('sendEvent', [options], callback);
}

const Radar = {
  initialize,
  setUserId,
  getUserId,
  setDescription,
  getDescription,
  setMetadata,
  getMetadata,
  setAnonymousTrackingEnabled,
  setAdIdEnabled,
  getPermissionsStatus,
  requestPermissions,
  getLocation,
  trackOnce,
  startTrackingEfficient,
  startTrackingResponsive,
  startTrackingContinuous,
  startTrackingCustom,
  mockTracking,
  stopTracking,
  isTracking,
  getTrackingOptions,
  onEvents,
  onLocation,
  onClientLocation,
  onError,
  offEvents,
  offLocation,
  offClientLocation,
  offError,
  getTripOptions,
  startTrip,
  updateTrip,
  completeTrip,
  cancelTrip,
  getContext,
  searchPlaces,
  searchGeofences,
  autocomplete,
  geocode,
  reverseGeocode,
  ipGeocode,
  getDistance,
  getMatrix,
  setForegroundServiceOptions,
  setLogLevel,
  sendEvent
};

module.exports = Radar;
