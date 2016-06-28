//
//  SQ1Basics.h
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 28/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import <Foundation/Foundation.h>

#define userDefaultsGetBool(key)   [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define userDefaultsGetInt(key)    ((int) [[NSUserDefaults standardUserDefaults] integerForKey:key])
#define userDefaultsGetDouble(key) [[NSUserDefaults standardUserDefaults] doubleForKey:key]
#define userDefaultsGetString(key) fc_safeString([[NSUserDefaults standardUserDefaults] stringForKey:key])
#define userDefaultsGetArray(key)  [[NSUserDefaults standardUserDefaults] arrayForKey:key]
#define userDefaultsGetObject(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define userDefaultsSetBool(key, b)   { [[NSUserDefaults standardUserDefaults] setBool:b    forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define userDefaultsSetInt(key, i)    { [[NSUserDefaults standardUserDefaults] setInteger:i forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define userDefaultsSetDouble(key, d) { [[NSUserDefaults standardUserDefaults] setDouble:d  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define userDefaultsSetString(key, s) { [[NSUserDefaults standardUserDefaults] setObject:s  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define userDefaultsSetArray(key, a)  { [[NSUserDefaults standardUserDefaults] setObject:a  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define userDefaultsSetObject(key, o) { [[NSUserDefaults standardUserDefaults] setObject:o  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }

#define APP_DISPLAY_NAME    [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define APP_VERSION         [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_BUILD_NUMBER    [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"]

void sq1_executeOnMainThread(void (^block)());


