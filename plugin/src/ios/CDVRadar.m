#import "CDVRadar.h"

@implementation CDVRadar {
    CLLocationManager *locationManager;
    NSString *eventsCallbackId;
    NSString *locationCallbackId;
    NSString *clientLocationCallbackId;
    NSString *errorCallbackId;
    NSString *tokenCallbackId;
}

- (void)pluginInitialize {
  [Radar setDelegate:self];
  [Radar setVerifiedDelegate:self];
  locationManager = [CLLocationManager new];
}

- (void)didReceiveEvents:(NSArray<RadarEvent *> *)events user:(RadarUser * _Nullable )user {
    if (!eventsCallbackId) {
        return;
    }

    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[RadarEvent arrayForEvents:events] forKey:@"events"];
    if (user) {
        [dict setValue:[user dictionaryValue] forKey:@"user"];
    }

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:eventsCallbackId];
}

- (void)didUpdateLocation:(CLLocation *)location user:(RadarUser *)user {
    if (!locationCallbackId) {
        return;
    }

    NSDictionary *dict = @{@"location": [Radar dictionaryForLocation:location], @"user": [user dictionaryValue]};

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:locationCallbackId];
}

- (void)didUpdateClientLocation:(CLLocation *)location stopped:(BOOL)stopped source:(RadarLocationSource)source {
    if (!clientLocationCallbackId) {
        return;
    }

    NSDictionary *dict = @{@"location": [Radar dictionaryForLocation:location], @"stopped": @(stopped), @"source": [Radar stringForLocationSource:source]};

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:clientLocationCallbackId];
}

- (void)didFailWithStatus:(RadarStatus)status {
    if (!errorCallbackId) {
        return;
    }

    NSDictionary *dict = @{@"status": [Radar stringForStatus:status]};

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:errorCallbackId];
}

- (void)didLogMessage:(NSString *)message {

}

- (void)didUpdateToken:(NSString *)token {
    if (!tokenCallbackId) {
        return;
    }

    NSDictionary *dict = @{@"token": token};

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:tokenCallbackId];
}

- (void)initialize:(CDVInvokedUrlCommand *)command {
    NSString *publishableKey = [command.arguments objectAtIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Cordova" forKey:@"radar-xPlatformSDKType"];
    [[NSUserDefaults standardUserDefaults] setObject:@"3.9.0" forKey:@"radar-xPlatformSDKVersion"];

    [Radar initializeWithPublishableKey:publishableKey];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setUserId:(CDVInvokedUrlCommand *)command {
    NSString *userId = [command.arguments objectAtIndex:0];

    [Radar setUserId:userId];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getUserId:(CDVInvokedUrlCommand *)command {
    NSString *userId = [Radar getUserId];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:userId];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setLogLevel:(CDVInvokedUrlCommand *)command {
    NSString *level = [command.arguments objectAtIndex:0];

    RadarLogLevel logLevel = RadarLogLevelNone;
    if (level) {
        NSString *lowerLevel = [level lowercaseString];
        if ([lowerLevel isEqualToString:@"error"]) {
            logLevel = RadarLogLevelError;
        } else if ([lowerLevel isEqualToString:@"warning"]) {
            logLevel = RadarLogLevelWarning;
        } else if ([lowerLevel isEqualToString:@"info"]) {
            logLevel = RadarLogLevelInfo;
        } else if ([lowerLevel isEqualToString:@"debug"]) {
            logLevel = RadarLogLevelDebug;
        } else {            
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"invalid level"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];            
            return;
        }
    } else {         
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"level is required"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];            
        return;
    }
    [Radar setLogLevel:logLevel];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setDescription:(CDVInvokedUrlCommand *)command {
    NSString *description = [command.arguments objectAtIndex:0];

    [Radar setDescription:description];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getDescription:(CDVInvokedUrlCommand *)command {
    NSString *description = [Radar getDescription];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:description];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setMetadata:(CDVInvokedUrlCommand *)command {
    NSDictionary *metadata = [command.arguments objectAtIndex:0];

    [Radar setMetadata:metadata];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getMetadata:(CDVInvokedUrlCommand *)command {
    NSDictionary *metadata = [Radar getMetadata];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:metadata];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setAnonymousTrackingEnabled:(CDVInvokedUrlCommand *)command {
    NSNumber *enabledNumber = [command.arguments objectAtIndex:0];

    BOOL enabled = [enabledNumber boolValue];

    [Radar setAnonymousTrackingEnabled:enabled];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getPermissionsStatus:(CDVInvokedUrlCommand *)command {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    NSString *str;
    switch (status) {
        case kCLAuthorizationStatusDenied:
            str = @"DENIED";
            break;
        case kCLAuthorizationStatusRestricted:
            str = @"DENIED";
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            str = @"GRANTED_BACKGROUND";
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            str = @"GRANTED_FOREGROUND";
            break;
        default:
            str = @"UNKNOWN";
    }

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

- (void)getLocation:(CDVInvokedUrlCommand *)command {
    NSString *desiredAccuracy = [command.arguments objectAtIndex:0];
    RadarTrackingOptionsDesiredAccuracy accuracy = RadarTrackingOptionsDesiredAccuracyMedium;
    
    if (desiredAccuracy) {
        NSString *lowerAccuracy = [desiredAccuracy lowercaseString];
        if ([lowerAccuracy isEqualToString:@"high"]) {
            accuracy = RadarTrackingOptionsDesiredAccuracyHigh;
        } else if ([lowerAccuracy isEqualToString:@"medium"]) {
            accuracy = RadarTrackingOptionsDesiredAccuracyMedium;
        } else if ([lowerAccuracy isEqualToString:@"low"]) {
            accuracy = RadarTrackingOptionsDesiredAccuracyLow;
        } else {            
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"invalid desiredAccuracy"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];            
            return;
        }
    }
    [self.commandDelegate runInBackground:^{
        [Radar getLocationWithDesiredAccuracy:accuracy completionHandler:^(RadarStatus status, CLLocation *location, BOOL stopped) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (location) {
                [dict setObject:[Radar dictionaryForLocation:location] forKey:@"location"];
            }
            [dict setObject:@(stopped) forKey:@"stopped"];

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void)trackOnce:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        RadarTrackCompletionHandler completionHandler = ^(RadarStatus status, CLLocation *location, NSArray<RadarEvent *> *events, RadarUser *user) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (location) {
                [dict setObject:[Radar dictionaryForLocation:location] forKey:@"location"];
            }
            if (events) {
                [dict setObject:[RadarEvent arrayForEvents:events] forKey:@"events"];
            }
            if (user) {
                [dict setObject:[user dictionaryValue] forKey:@"user"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        };

        CLLocation *location;
        RadarTrackingOptionsDesiredAccuracy desiredAccuracy = RadarTrackingOptionsDesiredAccuracyMedium;
        BOOL beacons = NO;
        if (command.arguments && command.arguments.count) {
            NSDictionary *optionsDict = [command.arguments objectAtIndex:0];
            NSDictionary *locationDict = optionsDict[@"location"];
            if (locationDict) {
                NSNumber *latitudeNumber = locationDict[@"latitude"];
                NSNumber *longitudeNumber = locationDict[@"longitude"];
                NSNumber *accuracyNumber = locationDict[@"accuracy"];
                double latitude = [latitudeNumber doubleValue];
                double longitude = [longitudeNumber doubleValue];
                double accuracy = accuracyNumber ? [accuracyNumber doubleValue] : -1;
                location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) altitude:-1 horizontalAccuracy:accuracy verticalAccuracy:-1 timestamp:[NSDate date]];
            }
            NSString *desiredAccuracyStr = optionsDict[@"desiredAccuracy"];
            if (desiredAccuracyStr && [desiredAccuracyStr isKindOfClass:[NSString class]]) {
                NSString *lowerAccuracy = [desiredAccuracyStr lowercaseString];
                if ([lowerAccuracy isEqualToString:@"high"]) {
                    desiredAccuracy = RadarTrackingOptionsDesiredAccuracyHigh;
                } else if ([lowerAccuracy isEqualToString:@"medium"]) {
                    desiredAccuracy = RadarTrackingOptionsDesiredAccuracyMedium;
                } else if ([lowerAccuracy isEqualToString:@"low"]) {
                    desiredAccuracy = RadarTrackingOptionsDesiredAccuracyLow;
                } else {            
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"invalid desiredAccuracy"];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];            
                    return;
                }
            }
            NSNumber *beaconsNum = optionsDict[@"beacons"];
            if (beaconsNum) {
                beacons = [beaconsNum boolValue];
            }
        }

        if (location) {
            [Radar trackOnceWithLocation:location completionHandler:completionHandler];
        } else {
            [Radar trackOnceWithDesiredAccuracy:desiredAccuracy beacons:beacons completionHandler:completionHandler];
        }
    }];
}

- (void)trackVerified:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        BOOL beacons = NO;
        if (command.arguments && command.arguments.count) {
            NSDictionary *argsDict = [command.arguments objectAtIndex:0];
            NSNumber *beaconsNum = argsDict[@"beacons"];
            if (beaconsNum) {
                beacons = [beaconsNum boolValue];
            }
        }

        RadarTrackCompletionHandler completionHandler = ^(RadarStatus status, CLLocation *location, NSArray<RadarEvent *> *events, RadarUser *user) {
            if (status == RadarStatusSuccess) {
                NSMutableDictionary *dict = [NSMutableDictionary new];
                [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
                if (location) {
                    [dict setObject:[Radar dictionaryForLocation:location] forKey:@"location"];
                }
                if (events) {
                    [dict setObject:[RadarEvent arrayForEvents:events] forKey:@"events"];
                }
                if (user) {
                    [dict setObject:[user dictionaryValue] forKey:@"user"];
                }
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        };

        [Radar trackVerifiedWithBeacons:beacons completionHandler:completionHandler];
    }];
}

- (void)trackVerifiedToken:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        BOOL beacons = NO;
        if (command.arguments && command.arguments.count) {
            NSDictionary *argsDict = [command.arguments objectAtIndex:0];
            NSNumber *beaconsNum = argsDict[@"beacons"];
            if (beaconsNum) {
                beacons = [beaconsNum boolValue];
            }
        }

        RadarTrackTokenCompletionHandler completionHandler = ^(RadarStatus status, NSString* token) {
            if (status == RadarStatusSuccess) {
                NSMutableDictionary *dict = [NSMutableDictionary new];
                [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
                [dict setObject:token forKey:@"token"];
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        };

        [Radar trackVerifiedTokenWithBeacons:beacons completionHandler:completionHandler];
    }];
}

- (void)startTrackingEfficient:(CDVInvokedUrlCommand *)command {
    [Radar startTrackingWithOptions:RadarTrackingOptions.presetEfficient];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startTrackingResponsive:(CDVInvokedUrlCommand *)command {
    [Radar startTrackingWithOptions:RadarTrackingOptions.presetResponsive];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startTrackingContinuous:(CDVInvokedUrlCommand *)command {
    [Radar startTrackingWithOptions:RadarTrackingOptions.presetContinuous];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startTrackingCustom:(CDVInvokedUrlCommand *)command {
    NSDictionary *optionsDict = [command.arguments objectAtIndex:0];

    RadarTrackingOptions *options = [RadarTrackingOptions trackingOptionsFromDictionary:optionsDict];
    [Radar startTrackingWithOptions:options];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startTrackingVerified:(CDVInvokedUrlCommand *)command {
    BOOL token = NO;
    double interval = 1;
    BOOL beacons = NO;

    if (command.arguments && command.arguments.count) {
        NSDictionary *argsDict = [command.arguments objectAtIndex:0];

        NSNumber *tokenNumber = argsDict[@"token"];
        if (tokenNumber != nil && [tokenNumber isKindOfClass:[NSNumber class]]) {
            token = [tokenNumber boolValue];
        }
        NSNumber *beaconsNumber = argsDict[@"beacons"];
        if (beaconsNumber != nil && [beaconsNumber isKindOfClass:[NSNumber class]]) {
            beacons = [beaconsNumber boolValue];
        }
        NSNumber *intervalNumber = argsDict[@"interval"];
        if (intervalNumber != nil && [intervalNumber isKindOfClass:[NSNumber class]]) {
            interval = [intervalNumber doubleValue];
        }
    }

    [Radar startTrackingVerified:token interval:interval beacons:beacons];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setForegroundServiceOptions:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)mockTracking:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        NSDictionary *optionsDict = [command.arguments objectAtIndex:0];

        NSDictionary *originDict = optionsDict[@"origin"];
        NSNumber *originLatitudeNumber = originDict[@"latitude"];
        NSNumber *originLongitudeNumber = originDict[@"longitude"];
        double originLatitude = [originLatitudeNumber doubleValue];
        double originLongitude = [originLongitudeNumber doubleValue];
        CLLocation *origin = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(originLatitude, originLongitude) altitude:-1 horizontalAccuracy:5 verticalAccuracy:-1 timestamp:[NSDate date]];
        NSDictionary *destinationDict = optionsDict[@"destination"];
        NSNumber *destinationLatitudeNumber = destinationDict[@"latitude"];
        NSNumber *destinationLongitudeNumber = destinationDict[@"longitude"];
        double destinationLatitude = [destinationLatitudeNumber doubleValue];
        double destinationLongitude = [destinationLongitudeNumber doubleValue];
        CLLocation *destination = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude) altitude:-1 horizontalAccuracy:5 verticalAccuracy:-1 timestamp:[NSDate date]];
        NSString *modeStr = optionsDict[@"mode"];
        RadarRouteMode mode = RadarRouteModeCar;
        if ([modeStr isEqualToString:@"FOOT"] || [modeStr isEqualToString:@"foot"]) {
            mode = RadarRouteModeFoot;
        } else if ([modeStr isEqualToString:@"BIKE"] || [modeStr isEqualToString:@"bike"]) {
            mode = RadarRouteModeBike;
        } else if ([modeStr isEqualToString:@"CAR"] || [modeStr isEqualToString:@"car"]) {
            mode = RadarRouteModeCar;
        }
        NSNumber *stepsNumber = optionsDict[@"steps"];
        int steps;
        if (stepsNumber != nil && [stepsNumber isKindOfClass:[NSNumber class]]) {
            steps = [stepsNumber intValue];
        } else {
            steps = 10;
        }
        NSNumber *intervalNumber = optionsDict[@"interval"];
        double interval;
        if (intervalNumber != nil && [intervalNumber isKindOfClass:[NSNumber class]]) {
            interval = [intervalNumber doubleValue];
        } else {
            interval = 1;
        }

        [Radar mockTrackingWithOrigin:origin destination:destination mode:mode steps:steps interval:interval completionHandler:^(RadarStatus status, CLLocation *location, NSArray<RadarEvent *> *events, RadarUser *user) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (location) {
                [dict setObject:[Radar dictionaryForLocation:location] forKey:@"location"];
            }
            if (events) {
                [dict setObject:[RadarEvent arrayForEvents:events] forKey:@"events"];
            }
            if (user) {
                [dict setObject:[user dictionaryValue] forKey:@"user"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void)stopTracking:(CDVInvokedUrlCommand *)command {
    [Radar stopTracking];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)isTracking:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:[Radar isTracking]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getTrackingOptions:(CDVInvokedUrlCommand *)command {
    RadarTrackingOptions* options = [Radar getTrackingOptions];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[options dictionaryValue]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)onEvents:(CDVInvokedUrlCommand *)command {
    eventsCallbackId = command.callbackId;
}

- (void)onLocation:(CDVInvokedUrlCommand *)command {
    locationCallbackId = command.callbackId;
}

- (void)onClientLocation:(CDVInvokedUrlCommand *)command {
    clientLocationCallbackId = command.callbackId;
}

- (void)onError:(CDVInvokedUrlCommand *)command {
    errorCallbackId = command.callbackId;
}

- (void)onToken:(CDVInvokedUrlCommand *)command {
    tokenCallbackId = command.callbackId;
}

- (void)offEvents:(CDVInvokedUrlCommand *)command {
    eventsCallbackId = nil;
}

- (void)offLocation:(CDVInvokedUrlCommand *)command {
    locationCallbackId = nil;
}

- (void)offClientLocation:(CDVInvokedUrlCommand *)command {
    clientLocationCallbackId = nil;
}

- (void)offError:(CDVInvokedUrlCommand *)command {
    errorCallbackId = nil;
}

- (void)offToken:(CDVInvokedUrlCommand *)command {
    tokenCallbackId = nil;
}

- (void)getTripOptions:(CDVInvokedUrlCommand *)command {
    RadarTripOptions *options = [Radar getTripOptions];

    if (options == nil) {
        NSString *optionsStr = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:optionsStr];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

        return;
    }

    NSDictionary *optionsDict = [options dictionaryValue];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:optionsDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startTrip:(CDVInvokedUrlCommand *)command {
    NSDictionary *optionsDict = [command.arguments objectAtIndex:0];

    NSDictionary *tripOptionsDict = optionsDict[@"tripOptions"];
    if (tripOptionsDict == nil) {
        tripOptionsDict = optionsDict;
    }
    RadarTripOptions *tripOptions = [RadarTripOptions tripOptionsFromDictionary:tripOptionsDict];
    NSDictionary *trackingOptionsDict = optionsDict[@"trackingOptions"];
    RadarTrackingOptions *trackingOptions;
    if (trackingOptionsDict) {
        trackingOptions = [RadarTrackingOptions trackingOptionsFromDictionary:trackingOptionsDict];
    }

    [Radar startTripWithOptions:tripOptions trackingOptions:trackingOptions completionHandler:^(RadarStatus status, RadarTrip * _Nullable trip, NSArray<RadarEvent *> * _Nullable events) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
        
        if (trip) {
            [dict setObject:[trip dictionaryValue] forKey:@"trip"];
        }
        if (events) {
            [dict setObject:[RadarEvent arrayForEvents:events] forKey:@"events"];
        }

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)updateTrip:(CDVInvokedUrlCommand *)command {
    NSDictionary *optionsDict = [command.arguments objectAtIndex:0];

    NSDictionary *tripOptionsDict = optionsDict[@"options"];
    NSString *statusStr = optionsDict[@"status"];

    RadarTripOptions *options = [RadarTripOptions tripOptionsFromDictionary:tripOptionsDict];
    RadarTripStatus status = RadarTripStatusUnknown;
    if (statusStr) {
        if ([statusStr isEqualToString:@"started"]) {
            status = RadarTripStatusStarted;
        } else if ([statusStr isEqualToString:@"approaching"]) {
            status = RadarTripStatusApproaching;
        } else if ([statusStr isEqualToString:@"arrived"]) {
            status = RadarTripStatusArrived;
        } else if ([statusStr isEqualToString:@"completed"]) {
            status = RadarTripStatusCompleted;
        } else if ([statusStr isEqualToString:@"canceled"]) {
            status = RadarTripStatusCanceled;
        }
    }
    
    [Radar updateTripWithOptions:options status:status completionHandler:^(RadarStatus status, RadarTrip * _Nullable trip, NSArray<RadarEvent *> * _Nullable events) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
        
        if (trip) {
            [dict setObject:[trip dictionaryValue] forKey:@"trip"];
        }
        if (events) {
            [dict setObject:[RadarEvent arrayForEvents:events] forKey:@"events"];
        }

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)completeTrip:(CDVInvokedUrlCommand *)command {
    [Radar completeTripWithCompletionHandler:^(RadarStatus status, RadarTrip * _Nullable trip, NSArray<RadarEvent *> * _Nullable events) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
        
        if (trip) {
            [dict setObject:[trip dictionaryValue] forKey:@"trip"];
        }
        if (events) {
            [dict setObject:[RadarEvent arrayForEvents:events] forKey:@"events"];
        }

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)cancelTrip:(CDVInvokedUrlCommand *)command {
    [Radar cancelTripWithCompletionHandler:^(RadarStatus status, RadarTrip * _Nullable trip, NSArray<RadarEvent *> * _Nullable events) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
        
        if (trip) {
            [dict setObject:[trip dictionaryValue] forKey:@"trip"];
        }
        if (events) {
            [dict setObject:[RadarEvent arrayForEvents:events] forKey:@"events"];
        }

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)getContext:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        RadarContextCompletionHandler completionHandler = ^(RadarStatus status, CLLocation * _Nullable location, RadarContext * _Nullable context) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (location) {
                [dict setObject:[Radar dictionaryForLocation:location] forKey:@"location"];
            }
            if (context) {
                [dict setObject:[context dictionaryValue] forKey:@"context"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        };

        if (command.arguments && command.arguments.count) {
            NSDictionary *locationDict = [command.arguments objectAtIndex:0];
            NSNumber *latitudeNumber = locationDict[@"latitude"];
            NSNumber *longitudeNumber = locationDict[@"longitude"];
            double latitude = [latitudeNumber doubleValue];
            double longitude = [longitudeNumber doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) altitude:-1 horizontalAccuracy:5 verticalAccuracy:-1 timestamp:[NSDate date]];

            [Radar getContextForLocation:location completionHandler:completionHandler];
        } else {
            [Radar getContextWithCompletionHandler:completionHandler];
        }
    }];
}

- (void)searchPlaces:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        RadarSearchPlacesCompletionHandler completionHandler = ^(RadarStatus status, CLLocation * _Nullable location, NSArray<RadarPlace *> * _Nullable places) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (location) {
                [dict setObject:[Radar dictionaryForLocation:location] forKey:@"location"];
            }
            if (places) {
                [dict setObject:[RadarPlace arrayForPlaces:places] forKey:@"places"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        };

        NSDictionary *optionsDict = [command.arguments objectAtIndex:0];

        CLLocation *near;
        NSDictionary *nearDict = optionsDict[@"near"];
        if (nearDict) {
            NSNumber *latitudeNumber = nearDict[@"latitude"];
            NSNumber *longitudeNumber = nearDict[@"longitude"];
            double latitude = [latitudeNumber doubleValue];
            double longitude = [longitudeNumber doubleValue];
            near = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) altitude:-1 horizontalAccuracy:5 verticalAccuracy:-1 timestamp:[NSDate date]];
        }
        NSNumber *radiusNumber = optionsDict[@"radius"];
        int radius;
        if (radiusNumber != nil && [radiusNumber isKindOfClass:[NSNumber class]]) {
            radius = [radiusNumber intValue];
        } else {
            radius = 1000;
        }
        NSArray *chains = optionsDict[@"chains"];        
        NSDictionary *chainMetadata = optionsDict[@"chainMetadata"];
        NSArray *categories = optionsDict[@"categories"];
        NSArray *groups = optionsDict[@"groups"];
        NSNumber *limitNumber = optionsDict[@"limit"];
        int limit;
        if (limitNumber != nil && [limitNumber isKindOfClass:[NSNumber class]]) {
            limit = [limitNumber intValue];
        } else {
            limit = 10;
        }

        if (near) {
            [Radar searchPlacesNear:near radius:radius chains:chains chainMetadata:chainMetadata categories:categories groups:groups limit:limit completionHandler:completionHandler];
        } else {
            [Radar searchPlacesWithRadius:radius chains:chains chainMetadata:chainMetadata categories:categories groups:groups limit:limit completionHandler:completionHandler];
        }
    }];
}

- (void)searchGeofences:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        RadarSearchGeofencesCompletionHandler completionHandler = ^(RadarStatus status, CLLocation * _Nullable location, NSArray<RadarGeofence *> * _Nullable geofences) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (location) {
                [dict setObject:[Radar dictionaryForLocation:location] forKey:@"location"];
            }
            if (geofences) {
                [dict setObject:[RadarGeofence arrayForGeofences:geofences] forKey:@"geofences"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        };

        NSDictionary *optionsDict = [command.arguments objectAtIndex:0];

        CLLocation *near;
        NSDictionary *nearDict = optionsDict[@"near"];
        if (nearDict) {
            NSNumber *latitudeNumber = nearDict[@"latitude"];
            NSNumber *longitudeNumber = nearDict[@"longitude"];
            double latitude = [latitudeNumber doubleValue];
            double longitude = [longitudeNumber doubleValue];
            near = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) altitude:-1 horizontalAccuracy:5 verticalAccuracy:-1 timestamp:[NSDate date]];
        }
        NSNumber *radiusNumber = optionsDict[@"radius"];
        int radius;
        if (radiusNumber != nil && [radiusNumber isKindOfClass:[NSNumber class]]) {
            radius = [radiusNumber intValue];
        } else {
            radius = 1000;
        }
        NSArray *tags = optionsDict[@"tags"];
        NSDictionary *metadata = optionsDict[@"metadata"];
        NSNumber *limitNumber = optionsDict[@"limit"];
        int limit;
        if (limitNumber != nil && [limitNumber isKindOfClass:[NSNumber class]]) {
            limit = [limitNumber intValue];
        } else {
            limit = 10;
        }

        if (near) {
            [Radar searchGeofencesNear:near radius:radius tags:tags metadata:metadata limit:limit completionHandler:completionHandler];
        } else {
            [Radar searchGeofencesWithRadius:radius tags:tags metadata:metadata limit:limit completionHandler:completionHandler];
        }
    }];
}

- (void)autocomplete:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        NSDictionary *optionsDict = [command.arguments objectAtIndex:0];

        NSString *query = optionsDict[@"query"];
        CLLocation *near;
        NSDictionary *nearDict = optionsDict[@"near"];
        if (nearDict) {
            NSNumber *latitudeNumber = nearDict[@"latitude"];
            NSNumber *longitudeNumber = nearDict[@"longitude"];
            double latitude = [latitudeNumber doubleValue];
            double longitude = [longitudeNumber doubleValue];
            near = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) altitude:-1 horizontalAccuracy:5 verticalAccuracy:-1 timestamp:[NSDate date]];
        }
        NSNumber *limitNumber = optionsDict[@"limit"];
        int limit;
        if (limitNumber != nil && [limitNumber isKindOfClass:[NSNumber class]]) {
            limit = [limitNumber intValue];
        } else {
            limit = 10;
        }        
        NSArray *layers = optionsDict[@"layers"];
        NSString *country = optionsDict[@"country"];
        BOOL mailable = false;
        NSNumber *mailableNumber = optionsDict[@"mailable"];
        if (mailableNumber != nil && [mailableNumber isKindOfClass:[NSNumber class]]) {
            mailable = [mailableNumber boolValue]; 
        }

        [Radar autocompleteQuery:query near:near layers:layers limit:limit country:country mailable:mailable completionHandler:^(RadarStatus status, NSArray<RadarAddress *> * _Nullable addresses) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (addresses) {
                [dict setObject:[RadarAddress arrayForAddresses:addresses] forKey:@"addresses"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void)geocode:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        NSString *query = [command.arguments objectAtIndex:0];

        [Radar geocodeAddress:query completionHandler:^(RadarStatus status, NSArray<RadarAddress *> * _Nullable addresses) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (addresses) {
                [dict setObject:[RadarAddress arrayForAddresses:addresses] forKey:@"addresses"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void)reverseGeocode:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        RadarGeocodeCompletionHandler completionHandler = ^(RadarStatus status, NSArray<RadarAddress *> * _Nullable addresses) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (addresses) {
                [dict setObject:[RadarAddress arrayForAddresses:addresses] forKey:@"addresses"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        };

        if (command.arguments && command.arguments.count) {
            NSDictionary *locationDict = [command.arguments objectAtIndex:0];
            NSNumber *latitudeNumber = locationDict[@"latitude"];
            NSNumber *longitudeNumber = locationDict[@"longitude"];
            double latitude = [latitudeNumber doubleValue];
            double longitude = [longitudeNumber doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) altitude:-1 horizontalAccuracy:5 verticalAccuracy:-1 timestamp:[NSDate date]];

            [Radar reverseGeocodeLocation:location completionHandler:completionHandler];
        } else {
            [Radar reverseGeocodeWithCompletionHandler:completionHandler];
        }
    }];
}

- (void)ipGeocode:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        [Radar ipGeocodeWithCompletionHandler:^(RadarStatus status, RadarAddress * _Nullable address, BOOL proxy) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (address) {
                [dict setObject:[address dictionaryValue] forKey:@"address"];
                [dict setValue:@(proxy) forKey:@"proxy"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void)getDistance:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        RadarRouteCompletionHandler completionHandler = ^(RadarStatus status, RadarRoutes * _Nullable routes) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (routes) {
                [dict setObject:[routes dictionaryValue] forKey:@"routes"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        };

        NSDictionary *optionsDict = [command.arguments objectAtIndex:0];

        CLLocation *origin;
        NSDictionary *originDict = optionsDict[@"origin"];
        if (originDict) {
            NSNumber *originLatitudeNumber = originDict[@"latitude"];
            NSNumber *originLongitudeNumber = originDict[@"longitude"];
            double originLatitude = [originLatitudeNumber doubleValue];
            double originLongitude = [originLongitudeNumber doubleValue];
            origin = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(originLatitude, originLongitude) altitude:-1 horizontalAccuracy:5 verticalAccuracy:-1 timestamp:[NSDate date]];
        }
        NSDictionary *destinationDict = optionsDict[@"destination"];
        NSNumber *destinationLatitudeNumber = destinationDict[@"latitude"];
        NSNumber *destinationLongitudeNumber = destinationDict[@"longitude"];
        double destinationLatitude = [destinationLatitudeNumber doubleValue];
        double destinationLongitude = [destinationLongitudeNumber doubleValue];
        CLLocation *destination = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude) altitude:-1 horizontalAccuracy:5 verticalAccuracy:-1 timestamp:[NSDate date]];
        NSArray *modesArr = optionsDict[@"modes"];
        RadarRouteMode modes = 0;
        if (modesArr != nil) {
            if ([modesArr containsObject:@"FOOT"] || [modesArr containsObject:@"foot"]) {
                modes = modes | RadarRouteModeFoot;
            }
            if ([modesArr containsObject:@"BIKE"] || [modesArr containsObject:@"bike"]) {
                modes = modes | RadarRouteModeBike;
            }
            if ([modesArr containsObject:@"CAR"] || [modesArr containsObject:@"car"]) {
                modes = modes | RadarRouteModeCar;
            }
        } else {
            modes = RadarRouteModeCar;
        }
        NSString *unitsStr = optionsDict[@"units"];
        RadarRouteUnits units;
        if (unitsStr != nil && [unitsStr isKindOfClass:[NSString class]]) {
            units = [unitsStr isEqualToString:@"METRIC"] || [unitsStr isEqualToString:@"metric"] ? RadarRouteUnitsMetric : RadarRouteUnitsImperial;
        } else {
            units = RadarRouteUnitsImperial;
        }

        if (origin) {
            [Radar getDistanceFromOrigin:origin destination:destination modes:modes units:units completionHandler:completionHandler];
        } else {
            [Radar getDistanceToDestination:destination modes:modes units:units completionHandler:completionHandler];
        }
    }];
}

- (void)getMatrix:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        NSDictionary *optionsDict = [command.arguments objectAtIndex:0];

        NSMutableArray *origins = [NSMutableArray new];
        NSArray *originsArr = optionsDict[@"origins"];
        if (originsArr) {
            for (NSDictionary *originDict in originsArr) {
                NSNumber *originLatitudeNumber = originDict[@"latitude"];
                NSNumber *originLongitudeNumber = originDict[@"longitude"];
                double originLatitude = [originLatitudeNumber doubleValue];
                double originLongitude = [originLongitudeNumber doubleValue];
                CLLocation *origin = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(originLatitude, originLongitude) altitude:-1 horizontalAccuracy:5 verticalAccuracy:-1 timestamp:[NSDate date]];
                [origins addObject:origin];
            }
        }
        NSMutableArray *destinations = [NSMutableArray new];
        NSArray *destinationsArr = optionsDict[@"destinations"];
        if (destinationsArr) {
            for (NSDictionary *destinationDict in destinationsArr) {
                NSNumber *destinationLatitudeNumber = destinationDict[@"latitude"];
                NSNumber *destinationLongitudeNumber = destinationDict[@"longitude"];
                double destinationLatitude = [destinationLatitudeNumber doubleValue];
                double destinationLongitude = [destinationLongitudeNumber doubleValue];
                CLLocation *destination = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude) altitude:-1 horizontalAccuracy:5 verticalAccuracy:-1 timestamp:[NSDate date]];
                [destinations addObject:destination];
            }
        }
        RadarRouteMode mode = RadarRouteModeCar;
        NSString *modeStr = optionsDict[@"mode"];
        if (modeStr != nil) {
            if ([modeStr isEqualToString:@"FOOT"] || [modeStr isEqualToString:@"foot"]) {
                mode = RadarRouteModeFoot;
            } else if ([modeStr isEqualToString:@"BIKE"] || [modeStr isEqualToString:@"bike"]) {
                mode = RadarRouteModeBike;
            } else if ([modeStr isEqualToString:@"CAR"] || [modeStr isEqualToString:@"car"]) {
                mode = RadarRouteModeCar;
            } else if ([modeStr isEqualToString:@"TRUCK"] || [modeStr isEqualToString:@"truck"]) {
                mode = RadarRouteModeTruck;
            } else if ([modeStr isEqualToString:@"MOTORBIKE"] || [modeStr isEqualToString:@"motorbike"]) {
                mode = RadarRouteModeMotorbike;
            }
        }
        NSString *unitsStr = optionsDict[@"units"];
        RadarRouteUnits units;
        if (unitsStr != nil && [unitsStr isKindOfClass:[NSString class]]) {
            units = [unitsStr isEqualToString:@"METRIC"] || [unitsStr isEqualToString:@"metric"] ? RadarRouteUnitsMetric : RadarRouteUnitsImperial;
        } else {
            units = RadarRouteUnitsImperial;
        }

        [Radar getMatrixFromOrigins:origins destinations:destinations mode:mode units:units completionHandler:^(RadarStatus status, RadarRouteMatrix * _Nullable matrix) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (matrix) {
                [dict setObject:[matrix arrayValue] forKey:@"matrix"];
            }

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void)logConversion:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        NSDictionary *optionsDict = [command.arguments objectAtIndex:0];
        NSString *name = optionsDict[@"name"];
        NSDictionary *metadata = optionsDict[@"metadata"];
        NSNumber *revenue = optionsDict[@"revenue"];

        RadarLogConversionCompletionHandler completionHandler = ^(RadarStatus status, RadarEvent * _Nullable event) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[Radar stringForStatus:status] forKey:@"status"];
            if (event) {
                [dict setObject:[event dictionaryValue] forKey:@"event"];
            }
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        };

        if (revenue) {
            [Radar logConversionWithName:name revenue:revenue metadata:metadata completionHandler:completionHandler];
        } else {
            [Radar logConversionWithName:name metadata:metadata completionHandler:completionHandler];
        }
    }];
}

- (void)getHost:(CDVInvokedUrlCommand *)command {
    NSString *host = [RadarSettings host];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:host];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getPublishableKey:(CDVInvokedUrlCommand *)command {
    NSString *publishableKey = [RadarSettings publishableKey];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:publishableKey];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)isUsingRemoteTrackingOptions:(CDVInvokedUrlCommand *)command {
    BOOL isUsingRemoteTrackingOptions = [Radar isUsingRemoteTrackingOptions];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isUsingRemoteTrackingOptions];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setNotificationOptions:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)logTermination:(CDVInvokedUrlCommand *)command {
    [Radar logTermination];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)logBackgrounding:(CDVInvokedUrlCommand *)command {
    [Radar logBackgrounding];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)logResigningActive:(CDVInvokedUrlCommand *)command {
    [Radar logResigningActive];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end