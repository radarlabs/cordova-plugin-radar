package io.radar.cordova;

import android.location.Location;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import io.radar.sdk.Radar;
import io.radar.sdk.model.RadarEvent;
import io.radar.sdk.model.RadarGeofence;
import io.radar.sdk.model.RadarUser;
import io.radar.sdk.model.RadarUserInsights;
import io.radar.sdk.model.RadarUserInsightsLocation;
import io.radar.sdk.model.RadarUserInsightsState;

class RadarCordovaUtils {

    static String stringForPermissionsStatus(boolean hasGrantedPermissions) {
        if (hasGrantedPermissions) {
            return "GRANTED";
        }
        return "DENIED";
    }

    static String stringForStatus(Radar.RadarStatus status) {
        return status.toString();
    }

    static String stringForEventType(RadarEvent.RadarEventType type) {
        switch (type) {
            case USER_ENTERED_GEOFENCE:
                return "user.entered_geofence";
            case USER_EXITED_GEOFENCE:
                return "user.exited_geofence";
            case USER_ENTERED_HOME:
                return "user.entered_home";
            case USER_EXITED_HOME:
                return "user.exited_home";
            case USER_ENTERED_OFFICE:
                return "user.entered_office";
            case USER_EXITED_OFFICE:
                return "user.exited_office";
            case USER_STARTED_TRAVELING:
                return "user.started_traveling";
            case USER_STOPPED_TRAVELING:
                return "user.stopped_traveling";
            case USER_ENTERED_REGION_COUNTRY:
                return "user.entered_region_country";
            case USER_EXITED_REGION_COUNTRY:
                return "user.exited_region_country";
            case USER_ENTERED_REGION_STATE:
                return "user.entered_region_state";
            case USER_EXITED_REGION_STATE:
                return "user.exited_region_state";
            case USER_ENTERED_REGION_STATE:
                return "user.entered_region_dma";
            case USER_EXITED_REGION_STATE:
                return "user.exited_region_dma";
            default:
                return null;
        }
    }

    static int numberForEventConfidence(RadarEvent.RadarEventConfidence confidence) {
        switch (confidence) {
            case HIGH:
                return 3;
            case MEDIUM:
                return 2;
            case LOW:
                return 1;
            default:
                return 0;
        }
    }

    static String stringForUserInsightsLocationType(RadarUserInsightsLocation.RadarUserInsightsLocationType type) {
        switch (type) {
            case HOME:
                return "home";
            case OFFICE:
                return "office";
            default:
                return null;
        }
    }

    static int numberForUserInsightsLocationConfidence(RadarUserInsightsLocation.RadarUserInsightsLocationConfidence confidence) {
        switch (confidence) {
            case HIGH:
                return 3;
            case MEDIUM:
                return 2;
            case LOW:
                return 1;
            default:
                return 0;
        }
    }

    static JSONObject jsonObjectForUser(RadarUser user) throws JSONException {
        if (user == null) {
            return null;
        }

        JSONObject obj = new JSONObject();
        obj.put("_id", user.getId());
        obj.put("userId", user.getUserId());
        String description = user.getDescription();
        if (description != null) {
            obj.put("description", description);
        }
        JSONArray geofencesArr = new JSONArray();
        for (RadarGeofence geofence : user.getGeofences()) {
            JSONObject geofenceObj = RadarCordovaUtils.jsonObjectForGeofence(geofence);
            geofencesArr.put(geofenceObj);
        }
        obj.put("geofences", geofencesArr);
        JSONObject insightsObj = RadarCordovaUtils.jsonObjectForUserInsights(user.getInsights());
        if (insightsObj != null) {
            obj.put("insights", insightsObj);
        }
        return obj;
    }

    private static JSONObject jsonObjectForUserInsights(RadarUserInsights insights) throws JSONException {
        if (insights == null) {
            return null;
        }

        JSONObject obj = new JSONObject();
        JSONObject homeLocationObj = RadarCordovaUtils.jsonObjectForUserInsightsLocation(insights.getHomeLocation());
        if (homeLocationObj != null) {
            obj.put("homeLocation", homeLocationObj);
        }
        JSONObject officeLocationObj = RadarCordovaUtils.jsonObjectForUserInsightsLocation(insights.getOfficeLocation());
        if (officeLocationObj != null) {
            obj.put("officeLocation", officeLocationObj);
        }
        JSONObject stateObj = RadarCordovaUtils.jsonObjectForUserInsightsState(insights.getState());
        if (stateObj != null) {
            obj.put("state", stateObj);
        }
        return obj;
    }

    private static JSONObject jsonObjectForUserInsightsLocation(RadarUserInsightsLocation location) throws JSONException {
        if (location == null) {
            return null;
        }

        JSONObject obj = new JSONObject();
        String type = RadarCordovaUtils.stringForUserInsightsLocationType(location.getType());
        if (type != null) {
            obj.put("type", type);
        }
        JSONObject locationObj = RadarCordovaUtils.jsonObjectForLocation(location.getLocation());
        if (locationObj != null) {
            obj.put("location", locationObj);
        }
        int confidence = RadarCordovaUtils.numberForUserInsightsLocationConfidence(location.getConfidence());
        obj.put("confidence", confidence);
        return obj;
    }

    private static JSONObject jsonObjectForUserInsightsState(RadarUserInsightsState state) throws JSONException {
        if (state == null) {
            return null;
        }

        JSONObject obj = new JSONObject();
        obj.put("home", state.getHome());
        obj.put("office", state.getOffice());
        obj.put("traveling", state.getTraveling());
        return obj;
    }

    static JSONObject jsonObjectForGeofence(RadarGeofence geofence) throws JSONException {
        if (geofence == null) {
            return null;
        }

        JSONObject obj = new JSONObject();
        obj.put("_id", geofence.getId());
        String tag = geofence.getTag();
        if (tag != null) {
            obj.put("tag", tag);
        }
        String externalId = geofence.getExternalId();
        if (externalId != null) {
            obj.put("externalId", externalId);
        }
        obj.put("description", geofence.getDescription());
        return obj;
    }

    static JSONArray jsonArrayForEvents(RadarEvent[] events) throws JSONException {
        if (events == null) {
            return null;
        }

        JSONArray arr = new JSONArray();
        for (RadarEvent event : events) {
            JSONObject obj = RadarCordovaUtils.jsonObjectForEvent(event);
            arr.put(obj);
        }
        return arr;
    }

    private static JSONObject jsonObjectForEvent(RadarEvent event) throws JSONException {
        if (event == null) {
            return null;
        }

        JSONObject obj = new JSONObject();
        obj.put("_id", event.getId());
        obj.put("live", event.getLive());
        String type = RadarCordovaUtils.stringForEventType(event.getType());
        if (type != null) {
            obj.put("type", type);
        }
        JSONObject geofenceObj = RadarCordovaUtils.jsonObjectForGeofence(event.getGeofence());
        if (geofenceObj != null) {
            obj.put("geofence", geofenceObj);
        }
        int confidence = RadarCordovaUtils.numberForEventConfidence(event.getConfidence());
        obj.put("confidence", confidence);
        if (event.getDuration() != 0) {
            obj.put("duration", event.getDuration());
        }
        return obj;
    }

    static JSONObject jsonObjectForLocation(Location location) throws JSONException {
        if (location == null) {
            return null;
        }

        JSONObject obj = new JSONObject();
        obj.put("latitude", location.getLatitude());
        obj.put("longitude", location.getLongitude());
        if (location.getAccuracy() != 0) {
            obj.put("accuracy", location.getAccuracy());
        }
        return obj;
    }

}
