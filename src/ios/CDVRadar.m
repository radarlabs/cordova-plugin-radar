#import "CDVRadar.h"
#import "CDVRadarUtils.h"

@implementation CDVRadar {
    CLLocationManager *locationManager;
    NSString *eventsCallbackId;
    NSString *errorCallbackId;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [Radar setDelegate:self];
        locationManager = [CLLocationManager new];
    }
    return self;
}

- (void)didReceiveEvents:(NSArray<RadarEvent *> *)events user:(RadarUser *)user {
    if (!eventsCallbackId) {
        return;
    }

    NSDictionary *dict = @{@"events": [CDVRadarUtils arrayForEvents:events], @"user": [CDVRadarUtils dictionaryForUser: user]};

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:eventsCallbackId];
}

- (void)didFailWithStatus:(RadarStatus)status {
  if (!errorCallbackId) {
      return;
  }

  NSDictionary *dict = @{@"status": [CDVRadarUtils stringForStatus:status]};

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
  [pluginResult setKeepCallbackAsBool:YES];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:errorCallbackId];
}

- (void)setUserId:(CDVInvokedUrlCommand *)command {
    NSString *userId = [command.arguments objectAtIndex:0];

    [Radar setUserId:userId];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setDescription:(CDVInvokedUrlCommand *)command {
    NSString *description = [command.arguments objectAtIndex:0];

    [Radar setDescription:description];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getPermissionsStatus:(CDVInvokedUrlCommand *)command {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    NSString *str = [CDVRadarUtils stringForPermissionsStatus:status];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:str];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)requestPermissions:(CDVInvokedUrlCommand *)command {
    NSNumber *backgroundNumber = [command.arguments objectAtIndex:0];

    BOOL background = [backgroundNumber boolValue];

    if (background) {
        [locationManager requestAlwaysAuthorization];
    } else {
        [locationManager requestWhenInUseAuthorization];
    }

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startTracking:(CDVInvokedUrlCommand *)command {
    [Radar startTracking];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)stopTracking:(CDVInvokedUrlCommand *)command {
    [Radar stopTracking];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)trackOnce:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        [Radar trackOnceWithCompletionHandler:^(RadarStatus status, CLLocation *location, NSArray<RadarEvent *> *events, RadarUser *user) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[CDVRadarUtils stringForStatus:status] forKey:@"status"];
            if (location) {
                [dict setObject:[CDVRadarUtils dictionaryForLocation:location] forKey:@"location"];
            }
            if (events) {
                [dict setObject:[CDVRadarUtils arrayForEvents:events] forKey:@"events"];
            }
            if (user) {
                [dict setObject:[CDVRadarUtils dictionaryForUser:user] forKey:@"user"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void)updateLocation:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        NSDictionary *locationDict = [command.arguments objectAtIndex:0];

        NSNumber *latitudeNumber = [locationDict objectForKey:@"latitude"];
        NSNumber *longitudeNumber = [locationDict objectForKey:@"longitude"];
        NSNumber *accuracyNumber = [locationDict objectForKey:@"accuracy"];

        double latitude = [latitudeNumber doubleValue];
        double longitude = [longitudeNumber doubleValue];
        double accuracy = accuracyNumber ? [accuracyNumber doubleValue] : -1;

        CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) altitude:-1 horizontalAccuracy:accuracy verticalAccuracy:-1 timestamp:[NSDate date]];

        [Radar updateLocation:location withCompletionHandler:^(RadarStatus status, CLLocation *location, NSArray<RadarEvent *> *events, RadarUser *user) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[CDVRadarUtils stringForStatus:status] forKey:@"status"];
            if (location) {
                [dict setObject:[CDVRadarUtils dictionaryForLocation:location] forKey:@"location"];
            }
            if (events) {
                [dict setObject:[CDVRadarUtils arrayForEvents:events] forKey:@"events"];
            }
            if (user) {
                [dict setObject:[CDVRadarUtils dictionaryForUser:user] forKey:@"user"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void)onEvents:(CDVInvokedUrlCommand *)command {
    eventsCallbackId = command.callbackId;
}

- (void)onError:(CDVInvokedUrlCommand *)command {
    errorCallbackId = command.callbackId;
}

- (void)offEvents:(CDVInvokedUrlCommand *)command {
    eventsCallbackId = nil;
}

- (void)offError:(CDVInvokedUrlCommand *)command {
    errorCallbackId = nil;
}

@end
