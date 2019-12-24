const cordova = require('cordova');

const exec = (action, args, callback) => {
  cordova.exec(callback,
    (error) => {
      console.log(error);
    }, 'Radar', action, args);
};

const setUserId = (userId) => {
  exec('setUserId', [userId]);
};

const setDescription = (description) => {
  exec('setDescription', [description]);
};

const getPermissionsStatus = (callback) => {
  exec('getPermissionsStatus', null, callback);
};

const requestPermissions = (background) => {
  exec('requestPermissions', [background]);
};

const startTracking = () => {
  exec('startTracking');
};

const stopTracking = () => {
  exec('stopTracking');
};

const trackOnce = (callback) => {
  exec('trackOnce', null, callback);
};

const updateLocation = (location, callback) => {
  exec('updateLocation', [location], callback);
};

const onEvents = (callback) => {
  exec('onEvents', null, (data) => {
    callback(data.events, data.user);
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

const offError = () => {
  exec('offEvents');
};

const Radar = {
  setUserId,
  setDescription,
  getPermissionsStatus,
  requestPermissions,
  startTracking,
  stopTracking,
  trackOnce,
  updateLocation,
  onEvents,
  onError,
  offEvents,
  offError,
};

module.exports = Radar;
