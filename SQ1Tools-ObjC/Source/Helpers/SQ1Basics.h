//
//  SQ1Basics.h
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 28/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import <Foundation/Foundation.h>

#define user_defaults_get_bool(key)   [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define user_defaults_get_int(key)    ((int) [[NSUserDefaults standardUserDefaults] integerForKey:key])
#define user_defaults_get_double(key) [[NSUserDefaults standardUserDefaults] doubleForKey:key]
#define user_defaults_get_string(key) fc_safeString([[NSUserDefaults standardUserDefaults] stringForKey:key])
#define user_defaults_get_array(key)  [[NSUserDefaults standardUserDefaults] arrayForKey:key]
#define user_defaults_get_object(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define user_defaults_set_bool(key, b)   { [[NSUserDefaults standardUserDefaults] setBool:b    forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_int(key, i)    { [[NSUserDefaults standardUserDefaults] setInteger:i forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_double(key, d) { [[NSUserDefaults standardUserDefaults] setDouble:d  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_string(key, s) { [[NSUserDefaults standardUserDefaults] setObject:s  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_array(key, a)  { [[NSUserDefaults standardUserDefaults] setObject:a  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_object(key, o) { [[NSUserDefaults standardUserDefaults] setObject:o  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }

#define APP_DISPLAY_NAME    [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define APP_VERSION         [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_BUILD_NUMBER    [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"]

void sq1_executeOnMainThread(void (^block)());


