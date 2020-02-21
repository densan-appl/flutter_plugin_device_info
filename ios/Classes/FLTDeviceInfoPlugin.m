// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTDeviceInfoPlugin.h"
#import <sys/utsname.h>

@implementation FLTDeviceInfoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/device_info"
                                  binaryMessenger:[registrar messenger]];
  FLTDeviceInfoPlugin* instance = [[FLTDeviceInfoPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getIosDeviceInfo" isEqualToString:call.method]) {
    UIDevice* device = [UIDevice currentDevice];
    struct utsname un;
    uname(&un);

    result(@{
      @"name" : [device name],
      @"systemName" : [device systemName],
      @"systemVersion" : [device systemVersion],
      @"model" : [device model],
      @"modelName" : [self getDeviceName],
      @"localizedModel" : [device localizedModel],
      @"identifierForVendor" : [[device identifierForVendor] UUIDString],
      @"isPhysicalDevice" : [self isDevicePhysical],
      @"utsname" : @{
        @"sysname" : @(un.sysname),
        @"nodename" : @(un.nodename),
        @"release" : @(un.release),
        @"version" : @(un.version),
        @"machine" : @(un.machine),
      }
    });
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSString*) getDeviceName {

    struct utsname systemInfo;

    uname(&systemInfo);

    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];

    static NSDictionary* deviceNamesByCode = nil;

    if (!deviceNamesByCode) {

        deviceNamesByCode = @{  /* Simulator */
                                @"i386"       :@"Simulator",
                                @"x86_64"     :@"Simulator",
                                /* iPod */
                                @"iPod1,1"    :@"iPod Touch 1st",            // iPod Touch 1st Generation
                                @"iPod2,1"    :@"iPod Touch 2nd",            // iPod Touch 2nd Generation
                                @"iPod3,1"    :@"iPod Touch 3rd",            // iPod Touch 3rd Generation
                                @"iPod4,1"    :@"iPod Touch 4th",            // iPod Touch 4th Generation
                                @"iPod5,1"    :@"iPod Touch 5th",            // iPod Touch 5th Generation
                                @"iPod7,1"    :@"iPod Touch 6th",            // iPod Touch 6th Generation
                                /* iPhone */
                                @"iPhone1,1"  :@"iPhone",                    // iPhone 2G
                                @"iPhone1,2"  :@"iPhone",                    // iPhone 3G
                                @"iPhone2,1"  :@"iPhone",                    // iPhone 3GS
                                @"iPhone3,1"  :@"iPhone 4",                  // iPhone 4 GSM
                                @"iPhone3,2"  :@"iPhone 4",                  // iPhone 4 GSM 2012
                                @"iPhone3,3"  :@"iPhone 4",                  // iPhone 4 CDMA For Verizon,Sprint
                                @"iPhone4,1"  :@"iPhone 4S",                 // iPhone 4S
                                @"iPhone5,1"  :@"iPhone 5",                  // iPhone 5 GSM
                                @"iPhone5,2"  :@"iPhone 5",                  // iPhone 5 Global
                                @"iPhone5,3"  :@"iPhone 5c",                 // iPhone 5c GSM
                                @"iPhone5,4"  :@"iPhone 5c",                 // iPhone 5c Global
                                @"iPhone6,1"  :@"iPhone 5s",                 // iPhone 5s GSM
                                @"iPhone6,2"  :@"iPhone 5s",                 // iPhone 5s Global
                                @"iPhone7,1"  :@"iPhone 6 Plus",             // iPhone 6 Plus
                                @"iPhone7,2"  :@"iPhone 6",                  // iPhone 6
                                @"iPhone8,1"  :@"iPhone 6S",                 // iPhone 6S
                                @"iPhone8,2"  :@"iPhone 6S Plus",            // iPhone 6S Plus
                                @"iPhone8,4"  :@"iPhone SE" ,                // iPhone SE
                                @"iPhone9,1"  :@"iPhone 7",                  // iPhone 7 A1660,A1779,A1780
                                @"iPhone9,3"  :@"iPhone 7",                  // iPhone 7 A1778
                                @"iPhone9,2"  :@"iPhone 7 Plus",             // iPhone 7 Plus A1661,A1785,A1786
                                @"iPhone9,4"  :@"iPhone 7 Plus",             // iPhone 7 Plus A1784
                                @"iPhone10,1" :@"iPhone 8",                  // iPhone 8 A1863,A1906,A1907
                                @"iPhone10,4" :@"iPhone 8",                  // iPhone 8 A1905
                                @"iPhone10,2" :@"iPhone 8 Plus",             // iPhone 8 Plus A1864,A1898,A1899
                                @"iPhone10,5" :@"iPhone 8 Plus",             // iPhone 8 Plus A1897
                                @"iPhone10,3" :@"iPhone X",                  // iPhone X A1865,A1902
                                @"iPhone10,6" :@"iPhone X",                  // iPhone X A1901
                                @"iPhone11,8" :@"iPhone XR",                 // iPhone XR A1984,A2105,A2106,A2108
                                @"iPhone11,2" :@"iPhone XS",                 // iPhone XS A2097,A2098
                                @"iPhone11,4" :@"iPhone XS Max",             // iPhone XS Max A1921,A2103
                                @"iPhone11,6" :@"iPhone XS Max",             // iPhone XS Max A2104  

                                /* iPad */
                                @"iPad1,1"   :@"iPad 1 ",                       // iPad 1
                                @"iPad2,1"   :@"iPad 2 WiFi",                   // iPad 2
                                @"iPad2,2"   :@"iPad 2 Cell",                   // iPad 2 GSM
                                @"iPad2,3"   :@"iPad 2 Cell",                   // iPad 2 CDMA (Cellular)
                                @"iPad2,4"   :@"iPad 2 WiFi",                   // iPad 2 Mid2012
                                @"iPad2,5"   :@"iPad Mini WiFi",                // iPad Mini WiFi
                                @"iPad2,6"   :@"iPad Mini Cell",                // iPad Mini GSM (Cellular)
                                @"iPad2,7"   :@"iPad Mini Cell",                // iPad Mini Global (Cellular)
                                @"iPad3,1"   :@"iPad 3 WiFi",                   // iPad 3 WiFi
                                @"iPad3,2"   :@"iPad 3 Cell",                   // iPad 3 CDMA (Cellular)
                                @"iPad3,3"   :@"iPad 3 Cell",                   // iPad 3 GSM (Cellular)
                                @"iPad3,4"   :@"iPad 4 WiFi",                   // iPad 4 WiFi
                                @"iPad3,5"   :@"iPad 4 Cell",                   // iPad 4 GSM (Cellular)
                                @"iPad3,6"   :@"iPad 4 Cell",                   // iPad 4 Global (Cellular)
                                @"iPad4,1"   :@"iPad Air WiFi",                 // iPad Air WiFi
                                @"iPad4,2"   :@"iPad Air Cell",                 // iPad Air Cellular
                                @"iPad4,3"   :@"iPad Air China",                // iPad Air ChinaModel
                                @"iPad4,4"   :@"iPad Mini 2 WiFi",              // iPad mini 2 WiFi
                                @"iPad4,5"   :@"iPad Mini 2 Cell",              // iPad mini 2 Cellular
                                @"iPad4,6"   :@"iPad Mini 2 China",             // iPad mini 2 ChinaModel
                                @"iPad4,7"   :@"iPad Mini 3 WiFi",              // iPad mini 3 WiFi
                                @"iPad4,8"   :@"iPad Mini 3 Cell",              // iPad mini 3 Cellular
                                @"iPad4,9"   :@"iPad Mini 3 China",             // iPad mini 3 ChinaModel
                                @"iPad5,1"   :@"iPad Mini 4 WiFi",              // iPad Mini 4 WiFi
                                @"iPad5,2"   :@"iPad Mini 4 Cell",              // iPad Mini 4 Cellular
                                @"iPad5,3"   :@"iPad Air 2 WiFi",               // iPad Air 2 WiFi
                                @"iPad5,4"   :@"iPad Air 2 Cell",               // iPad Air 2 Cellular
                                @"iPad6,3"   :@"iPad Pro 9.7inch WiFi",         // iPad Pro 9.7inch WiFi
                                @"iPad6,4"   :@"iPad Pro 9.7inch Cell",         // iPad Pro 9.7inch Cellular
                                @"iPad6,7"   :@"iPad Pro 12.9inch WiFi",        // iPad Pro 12.9inch WiFi
                                @"iPad6,8"   :@"iPad Pro 12.9inch Cell"         // iPad Pro 12.9inch Cellular
                                @"iPad6,11"  :@"iPad 5th",                      // iPad 5th Generation WiFi
                                @"iPad6,12"  :@"iPad 5th",                      // iPad 5th Generation Cellular
                                @"iPad7,1"   :@"iPad Pro 12.9inch 2nd",         // iPad Pro 12.9inch 2nd Generation WiFi
                                @"iPad7,2"   :@"iPad Pro 12.9inch 2nd",         // iPad Pro 12.9inch 2nd Generation Cellular
                                @"iPad7,3"   :@"iPad Pro 10.5inch",             // iPad Pro 10.5inch WiFi
                                @"iPad7,4"   :@"iPad Pro 10.5inch",             // iPad Pro 10.5inch Cellular
                                @"iPad7,5"   :@"iPad 6th",                      // iPad 6th Generation WiFi
                                @"iPad7,6"   :@"iPad 6th"                       // iPad 6th Generation Cellular
                                @"iPad8,1"   :@"iPad Pro 11inch WiFi",          // iPad Pro 11inch WiFi
                                @"iPad8,2"   :@"iPad Pro 11inch WiFi",          // iPad Pro 11inch WiFi
                                @"iPad8,3"   :@"iPad Pro 11inch Cell",          // iPad Pro 11inch Cellular
                                @"iPad8,4"   :@"iPad Pro 11inch Cell",          // iPad Pro 11inch Cellular
                                @"iPad8,5"   :@"iPad Pro 12.9inch WiFi",        // iPad Pro 12.9inch WiFi
                                @"iPad8,6"   :@"iPad Pro 12.9inch WiFi",        // iPad Pro 12.9inch WiFi
                                @"iPad8,7"   :@"iPad Pro 12.9inch Cell",        // iPad Pro 12.9inch Cellular
                                @"iPad8,8"   :@"iPad Pro 12.9inch Cell",        // iPad Pro 12.9inch Cellular
                                @"iPad11,1"  :@"iPad Mini 5th WiFi",            // iPad mini 5th WiFi
                                @"iPad11,2"  :@"iPad Mini 5th Cell",            // iPad mini 5th Cellular
                                @"iPad11,3"  :@"iPad Air 3rd WiFi",             // iPad Air 3rd generation WiFi
                                @"iPad11,4"  :@"iPad Air 3rd Cell"              // iPad Air 3rd generation Cellular
                            };
    }

    NSString* deviceName = [deviceNamesByCode objectForKey:code];

    if (!deviceName) {
        // 該当するデバイス名がない場合、機種のみ推定する

        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }

    return deviceName;
}

// return value is false if code is run on a simulator
- (NSString*)isDevicePhysical {
#if TARGET_OS_SIMULATOR
  NSString* isPhysicalDevice = @"false";
#else
  NSString* isPhysicalDevice = @"true";
#endif

  return isPhysicalDevice;
}

@end
