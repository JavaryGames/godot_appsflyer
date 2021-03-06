
#import <Foundation/Foundation.h>
#import "./GodotAppsFlyer.h"
#import <AppsFlyerLib/AppsFlyerTracker.h>

NSDictionary *convertFromDictionary(const Dictionary& dict)
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    for(int i=0; i<dict.size(); i++) {
        Variant key = dict.get_key_at_index(i); 
        Variant val = dict.get_value_at_index(i);
        if(key.get_type() == Variant::STRING) {
            NSString *strKey = [NSString stringWithUTF8String:((String)key).utf8().get_data()];
            if(val.get_type() == Variant::INT) {
                int i = (int)val;
                result[strKey] = @(i);
            } else if(val.get_type() == Variant::REAL) {
                double d = (double)val;
                result[strKey] = @(d);
            } else if(val.get_type() == Variant::STRING) {
                NSString *s = [NSString stringWithUTF8String:((String)val).utf8().get_data()];
                result[strKey] = s;
            } else if(val.get_type() == Variant::BOOL) {
                BOOL b = (bool)val;
                result[strKey] = @(b);
            } else if(val.get_type() == Variant::DICTIONARY) {
                NSDictionary *d = convertFromDictionary((Dictionary)val);
                result[strKey] = d;
            } else {
                ERR_PRINT("Unexpected type as dictionary value");
            }
        } else {
            ERR_PRINT("Non string key in Dictionary");
        }
    }
    return result;
}

GodotAppsFlyer::GodotAppsFlyer()
{
}

GodotAppsFlyer::~GodotAppsFlyer()
{
}

void GodotAppsFlyer::init(const String& key, const String& appId, const String& appleAppID)
{
    NSString *strKey = [NSString stringWithUTF8String:key.utf8().get_data()];
    NSString *strAppleAppID = [NSString stringWithUTF8String:appleAppID.utf8().get_data()];
    
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = strKey;
    [AppsFlyerTracker sharedTracker].appleAppID = strAppleAppID;
    [AppsFlyerTracker sharedTracker].delegate = nil;
#ifdef DEBUG
    [AppsFlyerTracker sharedTracker].isDebug = true;
#endif

    [[AppsFlyerTracker sharedTracker] trackAppLaunch];

    // [[AppsFlyerTracker sharedTracker] trackAppLaunchWithCompletionHandler:^(NSDictionary<NSString *,id> *dictionary, NSError *error) {
    //     if (error) {
    //         NSLog(@"AppsFlyerTracker trackAppLaunch ERROR");
    //         NSLog(@"%@", error);
    //         return;
    //     }
    //     if (dictionary) {
    //         NSLog(@"AppsFlyerTracker trackAppLaunch SUCCESSFUL");
    //         NSLog(@"%@", dictionary);
    //         return;
    //     }
    //     [NSException exceptionWithName:@"fatalError" reason:nil userInfo:nil];
    // }];
}

void GodotAppsFlyer::trackEvent(const String& event, const Dictionary& params)
{
    NSString *eventName = [NSString stringWithUTF8String:event.utf8().get_data()];
    NSDictionary *dict = convertFromDictionary(params);
    [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValues: dict];
}

void GodotAppsFlyer::setUninstallToken(const String& token)
{
    NSData *data = [NSData dataWithBytes:token.utf8().get_data() length:token.utf8().length()];
    [[AppsFlyerTracker sharedTracker] registerUninstall:data];
}

void GodotAppsFlyer::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("init", "key", "appId"), &GodotAppsFlyer::init);
    ClassDB::bind_method(D_METHOD("track_event", "event", "params"), &GodotAppsFlyer::trackEvent);
    ClassDB::bind_method(D_METHOD("set_uninstall_token", "event"), &GodotAppsFlyer::setUninstallToken);
}
