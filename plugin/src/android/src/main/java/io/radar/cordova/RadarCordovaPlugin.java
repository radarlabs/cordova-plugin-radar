package io.radar.cordova;

import android.Manifest;
import android.content.Context;
import android.location.Location;
import android.os.Build;
import android.util.Log;

import java.util.Arrays;
import java.util.EnumSet;
import java.util.List;
import java.util.Iterator;
import java.util.Map;
import java.util.HashMap;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import io.radar.sdk.Radar;
import io.radar.sdk.RadarReceiver;
import io.radar.sdk.RadarTrackingOptions;
import io.radar.sdk.RadarTrackingOptions.RadarTrackingOptionsForegroundService;
import io.radar.sdk.RadarTripOptions;
import io.radar.sdk.model.RadarAddress;
import io.radar.sdk.model.RadarContext;
import io.radar.sdk.model.RadarEvent;
import io.radar.sdk.model.RadarGeofence;
import io.radar.sdk.model.RadarPlace;
import io.radar.sdk.model.RadarRouteMatrix;
import io.radar.sdk.model.RadarRoutes;
import io.radar.sdk.model.RadarTrip;
import io.radar.sdk.model.RadarUser;

import android.app.Activity;
import android.content.Intent;
import android.annotation.TargetApi;

import androidx.annotation.Nullable;

public class RadarCordovaPlugin extends CordovaPlugin {

    private static CallbackContext eventsCallbackContext;
    private static CallbackContext locationCallbackContext;
    private static CallbackContext clientLocationCallbackContext;
    private static CallbackContext errorCallbackContext;

    public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        try {
            if (action.equals("initialize")) {
                initialize(args, callbackContext);
            } else if (action.equals("setUserId")) {
                setUserId(args, callbackContext);
            } else if (action.equals("getUserId")) {
                getUserId(args, callbackContext);
            } else if (action.equals("setDescription")) {
                setDescription(args, callbackContext);
            } else if (action.equals("getDescription")) { 
                getDescription(args, callbackContext);
            } else if (action.equals("setMetadata")) {
                setMetadata(args, callbackContext);
            } else if (action.equals("getMetadata")) {
                getMetadata(args, callbackContext);
            } else if (action.equals("setAnonymousTrackingEnabled")) {
                setAnonymousTrackingEnabled(args, callbackContext);
            } else if (action.equals("setAdIdEnabled")) {
                setAdIdEnabled(args, callbackContext);
            } else if (action.equals("getPermissionsStatus")) {
                getPermissionsStatus(args, callbackContext);
            } else if (action.equals("requestPermissions")) {
                requestPermissions(args, callbackContext);
            } else if (action.equals("getLocation")) {
                getLocation(args, callbackContext);
            } else if (action.equals("trackOnce")) {
                trackOnce(args, callbackContext);
            } else if (action.equals("startTrackingEfficient")) {
                startTrackingEfficient(args, callbackContext);
            } else if (action.equals("startTrackingResponsive")) {
                startTrackingResponsive(args, callbackContext);
            } else if (action.equals("startTrackingContinuous")) {
                startTrackingContinuous(args, callbackContext);
            } else if (action.equals("startTrackingCustom")) {
                startTrackingCustom(args, callbackContext);
            } else if (action.equals("mockTracking")) {
                mockTracking(args, callbackContext);
            } else if (action.equals("stopTracking")) {
                stopTracking(args, callbackContext);
            } else if (action.equals("isTracking")) {
                isTracking(args, callbackContext);
            } else if (action.equals("getTrackingOptions")) {
                getTrackingOptions(args, callbackContext);
            } else if (action.equals("onEvents")) {
                onEvents(args, callbackContext);
            } else if (action.equals("onLocation")) {
                onLocation(args, callbackContext);
            } else if (action.equals("onClientLocation")) {
                onClientLocation(args, callbackContext);
            } else if (action.equals("onError")) {
                onError(args, callbackContext);
            } else if (action.equals("offEvents")) {
                offEvents(args, callbackContext);
            } else if (action.equals("offLocation")) {
                offLocation(args, callbackContext);
            } else if (action.equals("offClientLocation")) {
                offClientLocation(args, callbackContext);
            } else if (action.equals("offError")) {
                offError(args, callbackContext);
            } else if (action.equals("getTripOptions")) {
                getTripOptions(args, callbackContext);
            } else if (action.equals("startTrip")) {
                startTrip(args, callbackContext);
            } else if (action.equals("updateTrip")) {
                updateTrip(args, callbackContext);
            } else if (action.equals("completeTrip")) {
                completeTrip(args, callbackContext);
            } else if (action.equals("cancelTrip")) {
                cancelTrip(args, callbackContext);
            } else if (action.equals("getContext")) {
                getContext(args, callbackContext);
            } else if (action.equals("searchPlaces")) {
                searchPlaces(args, callbackContext);
            } else if (action.equals("searchGeofences")) {
                searchGeofences(args, callbackContext);
            } else if (action.equals("autocomplete")) {
                autocomplete(args, callbackContext);
            } else if (action.equals("geocode")) {
                geocode(args, callbackContext);
            } else if (action.equals("reverseGeocode")) {
                reverseGeocode(args, callbackContext);
            } else if (action.equals("ipGeocode")) {
                ipGeocode(args, callbackContext);
            } else if (action.equals("getDistance")) {
                getDistance(args, callbackContext);
            } else if (action.equals("getMatrix")) {
                getMatrix(args, callbackContext);
            } else if (action.equals("setForegroundServiceOptions")) {
                setForegroundServiceOptions(args, callbackContext);
            } else if (action.equals("setLogLevel")) {
                setLogLevel(args, callbackContext);
            } else if (action.equals("sendEvent")) {
                sendEvent(args, callbackContext);
            } else {
                return false;
            }
        } catch (JSONException e) {
            Log.e("RadarCordovaPlugin", "JSONException", e);
            return false;
        }

        return true;
    }

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        Radar.setReceiver(new RadarCordovaReceiver());
    }

    public static class RadarCordovaReceiver extends RadarReceiver {

        @Override
        public void onEventsReceived(Context context, RadarEvent[] events, RadarUser user) {
            if (RadarCordovaPlugin.eventsCallbackContext == null) {
                return;
            }

            try {
                JSONObject obj = new JSONObject();
                obj.put("events", RadarEvent.toJson(events));
                obj.put("user", user.toJson());

                PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, obj);
                pluginResult.setKeepCallback(true);
                RadarCordovaPlugin.eventsCallbackContext.sendPluginResult(pluginResult);
            } catch (JSONException e) {
                Log.e("RadarCordovaPlugin", "JSONException", e);
                RadarCordovaPlugin.eventsCallbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
            }
        }

        @Override
        public void onLocationUpdated(Context context, Location location, RadarUser user) {
            if (RadarCordovaPlugin.locationCallbackContext == null) {
                return;
            }

            try {
                JSONObject obj = new JSONObject();
                obj.put("location", Radar.jsonForLocation(location));
                obj.put("user", user.toJson());

                PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, obj);
                pluginResult.setKeepCallback(true);
                RadarCordovaPlugin.locationCallbackContext.sendPluginResult(pluginResult);
            } catch (JSONException e) {
                Log.e("RadarCordovaPlugin", "JSONException", e);
                RadarCordovaPlugin.locationCallbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
            }
        }

        @Override
        public void onClientLocationUpdated(Context context, Location location, boolean stopped, Radar.RadarLocationSource source) {
            if (RadarCordovaPlugin.clientLocationCallbackContext == null) {
                return;
            }

            try {
                JSONObject obj = new JSONObject();
                obj.put("location", Radar.jsonForLocation(location));
                obj.put("stopped", stopped);
                obj.put("source", source.toString());

                PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, obj);
                pluginResult.setKeepCallback(true);
                RadarCordovaPlugin.clientLocationCallbackContext.sendPluginResult(pluginResult);
            } catch (JSONException e) {
                Log.e("RadarCordovaPlugin", "JSONException", e);
                RadarCordovaPlugin.clientLocationCallbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
            }
        }

        @Override
        public void onError(Context context, Radar.RadarStatus status) {
            if (RadarCordovaPlugin.errorCallbackContext == null) {
                return;
            }

            try {
                JSONObject obj = new JSONObject();
                obj.put("status", status.toString());

                PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, obj);
                pluginResult.setKeepCallback(true);
                RadarCordovaPlugin.errorCallbackContext.sendPluginResult(pluginResult);
            } catch (JSONException e) {
                Log.e("RadarCordovaPlugin", "JSONException", e);
                RadarCordovaPlugin.errorCallbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
            }
        }

        @Override
        public void onLog(Context context, String message) {

        }

    }

    private static String[] stringArrayForArray(JSONArray jsonArr) throws JSONException {
        if (jsonArr == null) {
            return null;
        }

        String[] arr = new String[jsonArr.length()];
        for (int i = 0; i < arr.length; i++) {
            arr[i] = jsonArr.optString(i);
        }
        return arr;
    }

    private static Map<String, String> stringMapForJSONObject(JSONObject jsonObj) {
        try {
            if (jsonObj == null) {
                return null;
            }

            Map<String, String> stringMap = new HashMap<String, String>();
            Iterator<String> keys = jsonObj.keys();
            while (keys.hasNext()) {
                String key = keys.next();
                if (jsonObj.get(key) != null) {
                    stringMap.put(key, jsonObj.getString(key));
                }
            }
            return stringMap;
        } catch (JSONException j) {
            return null;
        }
    }

    public void initialize(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final String publishableKey = args.getString(0);
        Context context=this.cordova.getActivity().getApplicationContext(); 
        Radar.initialize(context, publishableKey);
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void setUserId(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
          final String userId = args.getString(0);

          Radar.setUserId(userId);

          callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void getUserId(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        String userId = Radar.getUserId();
        
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, userId));
    }

    public void setLogLevel(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        String level = args.getString(0);
        
        Radar.RadarLogLevel logLevel = Radar.RadarLogLevel.NONE;
        if (level != null) {
            level = level.toLowerCase();
            if (level.equals("error")) {
                logLevel = Radar.RadarLogLevel.ERROR;
            } else if (level.equals("warning")) {
                logLevel = Radar.RadarLogLevel.WARNING;
            } else if (level.equals("info")) {
                logLevel = Radar.RadarLogLevel.INFO;
            } else if (level.equals("debug")) {
                logLevel = Radar.RadarLogLevel.DEBUG;
            } else {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION, "invalid level: " + level));
                return;
            }
        } else {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION, "level is required"));
            return;
        }
        Radar.setLogLevel(logLevel);

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void setForegroundServiceOptions(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final JSONObject optionsJson = args.getJSONObject(0);
        RadarTrackingOptionsForegroundService options = RadarTrackingOptionsForegroundService.fromJson(optionsJson);
        Radar.setForegroundServiceOptions(options);
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void setDescription(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final String description = args.getString(0);

        Radar.setDescription(description);

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void getDescription(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        String description = Radar.getDescription();
        
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, description));
    }

    public void setMetadata(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final JSONObject metadata = args.getJSONObject(0);

        Radar.setMetadata(metadata);

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void getMetadata(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        JSONObject metadata = Radar.getMetadata();
        
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, metadata));
    }

    public void setAnonymousTrackingEnabled(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final boolean enabled = args.getBoolean(0);

        Radar.setAnonymousTrackingEnabled(enabled);
        
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void setAdIdEnabled(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final boolean enabled = args.getBoolean(0);

        Radar.setAdIdEnabled(enabled);
        
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void getPermissionsStatus(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        String str;
        boolean foreground = cordova.hasPermission("android.permission.ACCESS_FINE_LOCATION");
        if (Build.VERSION.SDK_INT >= 29) {
            if (foreground) {
                boolean background = cordova.hasPermission("android.permission.ACCESS_BACKGROUND_LOCATION");
                str = background ? "GRANTED_BACKGROUND" : "GRANTED_FOREGROUND";
            } else {
                str = "DENIED";
            }
        } else {
            str = foreground ? "GRANTED_BACKGROUND" : "DENIED";
        }

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, str));
    }

    public void requestPermissions(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final boolean background = args.getBoolean(0);

        if (background && Build.VERSION.SDK_INT >= 29) {
            cordova.requestPermissions(this, 0, new String[] { "android.permission.ACCESS_FINE_LOCATION", "android.permission.ACCESS_BACKGROUND_LOCATION" });
        } else {
            cordova.requestPermissions(this, 0, new String[] { "android.permission.ACCESS_FINE_LOCATION" });
        }

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void getLocation(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        String desiredAccuracy = args.getString(0);
        RadarTrackingOptions.RadarTrackingOptionsDesiredAccuracy accuracyLevel = RadarTrackingOptions.RadarTrackingOptionsDesiredAccuracy.MEDIUM;
        String accuracy = desiredAccuracy != null ? desiredAccuracy.toLowerCase()  : "medium";

        if (accuracy.equals("low")) {
            accuracyLevel = RadarTrackingOptions.RadarTrackingOptionsDesiredAccuracy.LOW;
        } else if (accuracy.equals("medium")) {
            accuracyLevel = RadarTrackingOptions.RadarTrackingOptionsDesiredAccuracy.MEDIUM;
        } else if (accuracy.equals("high")) {
            accuracyLevel = RadarTrackingOptions.RadarTrackingOptionsDesiredAccuracy.HIGH;
        } else {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION, "invalid desiredAccuracy: " + desiredAccuracy));
            return;
        }

        Radar.getLocation(accuracyLevel, new Radar.RadarLocationCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, Location location, boolean stopped) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (location != null) {
                        obj.put("location", Radar.jsonForLocation(location));
                    }
                    obj.put("stopped", stopped);

                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        });
    }

    public void trackOnce(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.RadarTrackCallback callback = new Radar.RadarTrackCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, Location location, RadarEvent[] events, RadarUser user) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (location != null) {
                        obj.put("location", Radar.jsonForLocation(location));
                    }
                    if (events != null) {
                        obj.put("events", RadarEvent.toJson(events));
                    }
                    if (user != null) {
                        obj.put("user", user.toJson());
                    }

                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        };

        Location location = null;
        RadarTrackingOptions.RadarTrackingOptionsDesiredAccuracy desiredAccuracy = RadarTrackingOptions.RadarTrackingOptionsDesiredAccuracy.MEDIUM;
        boolean beacons = false;
        if (args != null && args.length() > 0) {
            final JSONObject optionsObj = args.getJSONObject(0);
            if (optionsObj.has("location")) {
                JSONObject locationObj = optionsObj.getJSONObject("location");
                double latitude = locationObj.getDouble("latitude");
                double longitude = locationObj.getDouble("longitude");
                float accuracy = (float)locationObj.getDouble("accuracy");
                location = new Location("RadarCordovaPlugin");
                location.setLatitude(latitude);
                location.setLongitude(longitude);
                location.setAccuracy(accuracy);
            }
            if (optionsObj.has("desiredAccuracy")) {
                String desiredAccuracyStr = optionsObj.getString("desiredAccuracy").toLowerCase();
                if (desiredAccuracyStr.equals("none")) {
                    desiredAccuracy = RadarTrackingOptions.RadarTrackingOptionsDesiredAccuracy.NONE;
                } else if (desiredAccuracyStr.equals("low")) {
                    desiredAccuracy = RadarTrackingOptions.RadarTrackingOptionsDesiredAccuracy.LOW;
                } else if (desiredAccuracyStr.equals("medium")) {
                    desiredAccuracy = RadarTrackingOptions.RadarTrackingOptionsDesiredAccuracy.MEDIUM;
                } else if (desiredAccuracyStr.equals("high")) {
                    desiredAccuracy = RadarTrackingOptions.RadarTrackingOptionsDesiredAccuracy.HIGH;
                } else {
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION, "invalid desiredAccuracy: " + desiredAccuracy));
                    return;
                }
            }
            beacons = optionsObj.optBoolean("beacons", false);
        }

        if (location != null) {
            Radar.trackOnce(location, callback);
        } else {
            Radar.trackOnce(desiredAccuracy, beacons, callback);
        }
    }

    public void startTrackingEfficient(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.startTracking(RadarTrackingOptions.EFFICIENT);

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void startTrackingResponsive(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.startTracking(RadarTrackingOptions.RESPONSIVE);

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void startTrackingContinuous(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.startTracking(RadarTrackingOptions.CONTINUOUS);

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void startTrackingCustom(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final JSONObject optionsObj = args.getJSONObject(0);

        RadarTrackingOptions options = RadarTrackingOptions.fromJson(optionsObj);
        Radar.startTracking(options);

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void mockTracking(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final JSONObject optionsObj = args.getJSONObject(0);

        JSONObject originObj = optionsObj.getJSONObject("origin");
        double originLatitude = originObj.getDouble("latitude");
        double originLongitude = originObj.getDouble("longitude");
        Location origin = new Location("RNRadarModule");
        origin.setLatitude(originLatitude);
        origin.setLongitude(originLongitude);
        JSONObject destinationObj = optionsObj.getJSONObject("destination");
        double destinationLatitude = destinationObj.getDouble("latitude");
        double destinationLongitude = destinationObj.getDouble("longitude");
        Location destination = new Location("RNRadarModule");
        destination.setLatitude(destinationLatitude);
        destination.setLongitude(destinationLongitude);
        String modeStr = optionsObj.getString("mode");
        Radar.RadarRouteMode mode = Radar.RadarRouteMode.CAR;
        if (modeStr.equals("FOOT") || modeStr.equals("foot")) {
            mode = Radar.RadarRouteMode.FOOT;
        } else if (modeStr.equals("BIKE") || modeStr.equals("bike")) {
            mode = Radar.RadarRouteMode.BIKE;
        } else if (modeStr.equals("CAR") || modeStr.equals("car")) {
            mode = Radar.RadarRouteMode.CAR;
        }
        int steps = optionsObj.has("steps") ? optionsObj.getInt("steps") : 10;
        int interval = optionsObj.has("interval") ? optionsObj.getInt("interval") : 1;

        Radar.mockTracking(origin, destination, mode, steps, interval, new Radar.RadarTrackCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, Location location, RadarEvent[] events, RadarUser user) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (location != null) {
                        obj.put("location", Radar.jsonForLocation(location));
                    }
                    if (events != null) {
                        obj.put("events", RadarEvent.toJson(events));
                    }
                    if (user != null) {
                        obj.put("user", user.toJson());
                    }

                    PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, obj);
                    pluginResult.setKeepCallback(true);
                    callbackContext.sendPluginResult(pluginResult);
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        });
    }

    public void stopTracking(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.stopTracking();

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void isTracking(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, Radar.isTracking()));
    }

    public void getTrackingOptions(final JSONArray args, final CallbackContext callbackContext) throws JSONException {          
        RadarTrackingOptions options = Radar.getTrackingOptions();
        JSONObject optionsJson = options != null ? options.toJson() : null;

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, optionsJson));
    }

    public void onEvents(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        RadarCordovaPlugin.eventsCallbackContext = callbackContext;
    }

    public void onLocation(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        RadarCordovaPlugin.locationCallbackContext = callbackContext;
    }

    public void onClientLocation(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        RadarCordovaPlugin.clientLocationCallbackContext = callbackContext;
    }

    public void onError(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        RadarCordovaPlugin.errorCallbackContext = callbackContext;
    }

    public void offEvents(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        RadarCordovaPlugin.eventsCallbackContext = null;
    }

    public void offLocation(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        RadarCordovaPlugin.locationCallbackContext = null;
    }

    public void offClientLocation(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        RadarCordovaPlugin.clientLocationCallbackContext = null;
    }

    public void offError(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        RadarCordovaPlugin.errorCallbackContext = null;
    }

    public void getTripOptions(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        RadarTripOptions options = Radar.getTripOptions();

        if (options == null) {
            String optionsStr = null;
            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, optionsStr);
            callbackContext.sendPluginResult(pluginResult);

            return;
        }

        JSONObject optionsObj = options.toJson();
        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, optionsObj);
        callbackContext.sendPluginResult(pluginResult);
    }

    public void startTrip(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final JSONObject optionsObj = args.getJSONObject(0);
        
        // new format is { tripOptions, trackingOptions }
        JSONObject tripOptionsJson = optionsObj.optJSONObject("tripOptions");
        if (tripOptionsJson == null) {
            // legacy format
            tripOptionsJson = optionsObj;
        }
        RadarTripOptions options = RadarTripOptions.fromJson(tripOptionsJson);

        RadarTrackingOptions trackingOptions = null;
        JSONObject trackingOptionsJson = optionsObj.optJSONObject("trackingOptions");
        if (trackingOptionsJson != null) {
            trackingOptions = RadarTrackingOptions.fromJson(trackingOptionsJson);
        }

        Radar.startTrip(options, trackingOptions, new Radar.RadarTripCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, @Nullable RadarTrip trip, @Nullable RadarEvent[] events) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (trip != null) {
                        obj.put("trip", trip.toJson());
                    }
                    if (events != null) {
                        obj.put("events", RadarEvent.toJson(events));
                    }
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        });

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    public void updateTrip(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final JSONObject optionsObj = args.getJSONObject(0);

        JSONObject tripOptionsObj = optionsObj.getJSONObject("options");

        RadarTripOptions options = RadarTripOptions.fromJson(tripOptionsObj);
        RadarTrip.RadarTripStatus status = RadarTrip.RadarTripStatus.UNKNOWN;

        if (optionsObj.has("status")) {
            String statusStr = optionsObj.getString("status");
            if (statusStr != null) {
                if (statusStr.equalsIgnoreCase("started")) {
                    status = RadarTrip.RadarTripStatus.STARTED;
                } else if (statusStr.equalsIgnoreCase("approaching")) {
                    status = RadarTrip.RadarTripStatus.APPROACHING;
                } else if (statusStr.equalsIgnoreCase("arrived")) {
                    status = RadarTrip.RadarTripStatus.ARRIVED;
                } else if (statusStr.equalsIgnoreCase("completed")) {
                    status = RadarTrip.RadarTripStatus.COMPLETED;
                } else if (statusStr.equalsIgnoreCase("canceled")) {
                    status = RadarTrip.RadarTripStatus.CANCELED;
                }
            }
        }

        Radar.updateTrip(options, status, new Radar.RadarTripCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, @Nullable RadarTrip trip, @Nullable RadarEvent[] events) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (trip != null) {
                        obj.put("trip", trip.toJson());
                    }
                    if (events != null) {
                        obj.put("events", RadarEvent.toJson(events));
                    }
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        });
    }

    public void completeTrip(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.completeTrip(new Radar.RadarTripCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, @Nullable RadarTrip trip, @Nullable RadarEvent[] events) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (trip != null) {
                        obj.put("trip", trip.toJson());
                    }
                    if (events != null) {
                        obj.put("events", RadarEvent.toJson(events));
                    }
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        });
    }

    public void cancelTrip(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.cancelTrip(new Radar.RadarTripCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, @Nullable RadarTrip trip, @Nullable RadarEvent[] events) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (trip != null) {
                        obj.put("trip", trip.toJson());
                    }
                    if (events != null) {
                        obj.put("events", RadarEvent.toJson(events));
                    }
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        });
    }

    public void getContext(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.RadarContextCallback callback = new Radar.RadarContextCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, Location location, RadarContext context) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (location != null) {
                        obj.put("location", Radar.jsonForLocation(location));
                    }
                    if (context != null) {
                        obj.put("context", context.toJson());
                    }

                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        };

        if (args != null && args.length() > 0) {
            final JSONObject locationObj = args.getJSONObject(0);
            double latitude = locationObj.getDouble("latitude");
            double longitude = locationObj.getDouble("longitude");
            Location location = new Location("RadarCordovaPlugin");
            location.setLatitude(latitude);
            location.setLongitude(longitude);

            Radar.getContext(location, callback);
        } else {
            Radar.getContext(callback);
        }
    }

    public void searchPlaces(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.RadarSearchPlacesCallback callback = new Radar.RadarSearchPlacesCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, Location location, RadarPlace[] places) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (location != null) {
                        obj.put("location", Radar.jsonForLocation(location));
                    }
                    if (places != null) {
                        obj.put("places", RadarPlace.toJson(places));
                    }

                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        };

        final JSONObject optionsObj = args.getJSONObject(0);

        Location near = null;
        if (optionsObj.has("near")) {
            JSONObject nearObj = optionsObj.getJSONObject("near");
            double latitude = nearObj.getDouble("latitude");
            double longitude = nearObj.getDouble("longitude");
            near = new Location("RNRadarModule");
            near.setLatitude(latitude);
            near.setLongitude(longitude);
        }
        int radius = optionsObj.has("radius") ? optionsObj.getInt("radius") : 1000;
        String[] chains = optionsObj.has("chains") ? RadarCordovaPlugin.stringArrayForArray(optionsObj.getJSONArray("chains")) : null;
        Map<String, String> chainMetadata = optionsObj.has("chainMetadata") ? RadarCordovaPlugin.stringMapForJSONObject(optionsObj.getJSONObject("chainMetadata")) : null;
        String[] categories = optionsObj.has("categories") ? RadarCordovaPlugin.stringArrayForArray(optionsObj.getJSONArray("categories")) : null;
        String[] groups = optionsObj.has("groups") ? RadarCordovaPlugin.stringArrayForArray(optionsObj.getJSONArray("groups")) : null;
        int limit = optionsObj.has("limit") ? optionsObj.getInt("limit") : 10;

        if (near != null) {
            Radar.searchPlaces(near, radius, chains, chainMetadata, categories, groups, limit, callback);
        } else {
            Radar.searchPlaces(radius, chains, chainMetadata, categories, groups, limit, callback);
        }
    }

    public void searchGeofences(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.RadarSearchGeofencesCallback callback = new Radar.RadarSearchGeofencesCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, Location location, RadarGeofence[] geofences) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (location != null) {
                        obj.put("location", Radar.jsonForLocation(location));
                    }
                    if (geofences != null) {
                        obj.put("geofences", RadarGeofence.toJson(geofences));
                    }

                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        };

        final JSONObject optionsObj = args.getJSONObject(0);

        Location near = null;
        if (optionsObj.has("near")) {
            JSONObject nearObj = optionsObj.getJSONObject("near");
            double latitude = nearObj.getDouble("latitude");
            double longitude = nearObj.getDouble("longitude");
            near = new Location("RNRadarModule");
            near.setLatitude(latitude);
            near.setLongitude(longitude);
        }
        JSONObject metadata = optionsObj.has("metadata") ? optionsObj.getJSONObject("metadata") : null;
        int radius = optionsObj.has("radius") ? optionsObj.getInt("radius") : 1000;
        String[] tags = optionsObj.has("tags") ? RadarCordovaPlugin.stringArrayForArray(optionsObj.getJSONArray("tags")) : null;
        int limit = optionsObj.has("limit") ? optionsObj.getInt("limit") : 10;

        if (near != null) {
            Radar.searchGeofences(near, radius, tags, metadata, limit, callback);
        } else {
            Radar.searchGeofences(radius, tags, metadata, limit, callback);
        }
    }

    public void autocomplete(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final JSONObject optionsObj = args.getJSONObject(0);

        String query = optionsObj.getString("query");
        Location near = null;
        if (optionsObj.has("near")) {
            JSONObject nearObj = optionsObj.getJSONObject("near");
            double latitude = nearObj.getDouble("latitude");
            double longitude = nearObj.getDouble("longitude");
            near = new Location("RNRadarModule");
            near.setLatitude(latitude);
            near.setLongitude(longitude);
        }
        int limit = optionsObj.has("limit") ? optionsObj.getInt("limit") : 10;
        String country = optionsObj.getString("country");
        String[] layers = optionsObj.has("layers") ? RadarCordovaPlugin.stringArrayForArray(optionsObj.getJSONArray("layers")) : null;

        Radar.autocomplete(query, near, layers, limit, country, new Radar.RadarGeocodeCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, RadarAddress[] addresses) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (addresses != null) {
                        obj.put("addresses", RadarAddress.toJson(addresses));
                    }

                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        });
    }

    public void geocode(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final String query = args.getString(0);

        Radar.geocode(query, new Radar.RadarGeocodeCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, RadarAddress[] addresses) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (addresses != null) {
                        obj.put("addresses", RadarAddress.toJson(addresses));
                    }

                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        });
    }

    public void reverseGeocode(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.RadarGeocodeCallback callback = new Radar.RadarGeocodeCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, RadarAddress[] addresses) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (addresses != null) {
                        obj.put("addresses", RadarAddress.toJson(addresses));
                    }

                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        };

        if (args != null && args.length() > 0) {
            final JSONObject locationObj = args.getJSONObject(0);
            double latitude = locationObj.getDouble("latitude");
            double longitude = locationObj.getDouble("longitude");
            float accuracy = (float)locationObj.getDouble("accuracy");
            Location location = new Location("RadarCordovaPlugin");
            location.setLatitude(latitude);
            location.setLongitude(longitude);
            location.setAccuracy(accuracy);

            Radar.reverseGeocode(location, callback);
        } else {
            Radar.reverseGeocode(callback);
        }
    }

    public void ipGeocode(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.ipGeocode(new Radar.RadarIpGeocodeCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, RadarAddress address, boolean proxy) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (address != null) {
                        obj.put("address", address.toJson());
                        obj.put("proxy", proxy);
                    }

                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        });
    }

    public void getDistance(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Radar.RadarRouteCallback callback = new Radar.RadarRouteCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, RadarRoutes routes) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (routes != null) {
                        obj.put("routes", routes.toJson());
                    }

                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        };

        final JSONObject optionsObj = args.getJSONObject(0);

        Location origin = null;
        if (optionsObj.has("origin")) {
            JSONObject originObj = optionsObj.getJSONObject("origin");
            double originLatitude = originObj.getDouble("latitude");
            double originLongitude = originObj.getDouble("longitude");
            origin = new Location("RNRadarModule");
            origin.setLatitude(originLatitude);
            origin.setLongitude(originLongitude);
        }
        JSONObject destinationObj = optionsObj.getJSONObject("destination");
        double destinationLatitude = destinationObj.getDouble("latitude");
        double destinationLongitude = destinationObj.getDouble("longitude");
        Location destination = new Location("RNRadarModule");
        destination.setLatitude(destinationLatitude);
        destination.setLongitude(destinationLongitude);
        EnumSet<Radar.RadarRouteMode> modes = EnumSet.noneOf(Radar.RadarRouteMode.class);
        List<String> modesList = Arrays.asList(RadarCordovaPlugin.stringArrayForArray(optionsObj.getJSONArray("modes")));
        if (modesList.contains("FOOT") || modesList.contains("foot")) {
            modes.add(Radar.RadarRouteMode.FOOT);
        }
        if (modesList.contains("BIKE") || modesList.contains("bike")) {
            modes.add(Radar.RadarRouteMode.BIKE);
        }
        if (modesList.contains("CAR") || modesList.contains("car")) {
            modes.add(Radar.RadarRouteMode.CAR);
        }
        if (modesList.contains("TRUCK") || modesList.contains("truck")) {
            modes.add(Radar.RadarRouteMode.TRUCK);
        }
        if (modesList.contains("MOTORBIKE") || modesList.contains("motorbike")) {
            modes.add(Radar.RadarRouteMode.MOTORBIKE);
        }
        String unitsStr = optionsObj.getString("units");
        Radar.RadarRouteUnits units = unitsStr.equals("METRIC") || unitsStr.equals("metric") ? Radar.RadarRouteUnits.METRIC : Radar.RadarRouteUnits.IMPERIAL;

        if (origin != null) {
            Radar.getDistance(origin, destination, modes, units, callback);
        } else {
            Radar.getDistance(destination, modes, units, callback);
        }
    }

    public void getMatrix(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final JSONObject optionsObj = args.getJSONObject(0);

        JSONArray originsArr = optionsObj.getJSONArray("origins");
        Location[] origins = new Location[originsArr.length()];
        for (int i = 0; i < originsArr.length(); i++) {
            JSONObject originObj = originsArr.getJSONObject(i);
            double originLatitude = originObj.getDouble("latitude");
            double originLongitude = originObj.getDouble("longitude");
            Location origin = new Location("RadarCordovaPlugin");
            origin.setLatitude(originLatitude);
            origin.setLongitude(originLongitude);
            origins[i] = origin;
        }
        JSONArray destinationsArr = optionsObj.getJSONArray("destinations");
        Location[] destinations = new Location[destinationsArr.length()];
        for (int i = 0; i < destinationsArr.length(); i++) {
            JSONObject destinationObj = destinationsArr.getJSONObject(i);
            double destinationLatitude = destinationObj.getDouble("latitude");
            double destinationLongitude = destinationObj.getDouble("longitude");
            Location destination = new Location("RadarCordovaPlugin");
            destination.setLatitude(destinationLatitude);
            destination.setLongitude(destinationLongitude);
            destinations[i] = destination;
        }
        Radar.RadarRouteMode mode = Radar.RadarRouteMode.CAR;
        String modeStr = optionsObj.getString("mode");
        if (modeStr.equals("FOOT") || modeStr.equals("foot")) {
            mode = Radar.RadarRouteMode.FOOT;
        } else if (modeStr.equals("BIKE") || modeStr.equals("bike")) {
            mode = Radar.RadarRouteMode.BIKE;
        } else if (modeStr.equals("CAR") || modeStr.equals("car")) {
            mode = Radar.RadarRouteMode.CAR;
        } else if (modeStr.equals("TRUCK") || modeStr.equals("truck")) {
            mode = Radar.RadarRouteMode.TRUCK;
        } else if (modeStr.equals("MOTORBIKE") || modeStr.equals("motorbike")) {
            mode = Radar.RadarRouteMode.MOTORBIKE;
        }
        String unitsStr = optionsObj.getString("units");
        Radar.RadarRouteUnits units = unitsStr.equals("METRIC") || unitsStr.equals("metric") ? Radar.RadarRouteUnits.METRIC : Radar.RadarRouteUnits.IMPERIAL;

        Radar.getMatrix(origins, destinations, mode, units, new Radar.RadarMatrixCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, RadarRouteMatrix matrix) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (matrix != null) {
                        obj.put("matrix", matrix.toJson());
                    }

                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, obj));
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        });
    }

    public void sendEvent(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final JSONObject optionsObj = args.getJSONObject(0);
        
        String customType = optionsObj.getString("customType");
        JSONObject metadata = optionsObj.getJSONObject("metadata");
        
        Radar.sendEvent(customType, metadata, new Radar.RadarSendEventCallback() {
            @Override
            public void onComplete(Radar.RadarStatus status, Location location, RadarEvent[] events, RadarUser user) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("status", status.toString());
                    if (location != null) {
                        obj.put("location", Radar.jsonForLocation(location));
                    }
                    if (events != null) {
                        obj.put("events", RadarEvent.toJson(events));
                    }
                    if (user != null) {
                        obj.put("user", user.toJson());
                    }

                    PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, obj);
                    pluginResult.setKeepCallback(true);
                    callbackContext.sendPluginResult(pluginResult);
                } catch (JSONException e) {
                    Log.e("RadarCordovaPlugin", "JSONException", e);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                }
            }
        });
    }
}