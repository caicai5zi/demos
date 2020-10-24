//
//  OCUtil+IOKit.h
//  HRSword
//
//  Created by app on 2020/10/20.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

#import "OCUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCUtil (IOKit)

+(NSString *)IORegistryEntryGetNameInPlane:(io_registry_entry_t)entry plane:(const io_name_t _Nullable )plane;
+(NSString *)IOObjectGetClass:(io_registry_entry_t)entry;
+(NSString *)IOObjectGetClasses:(io_registry_entry_t)entry;
+(NSString * _Nullable)BundleIdentifierForEntry:(io_registry_entry_t)entry;
+(uint32_t)busyState:(io_service_t)service;
+(BOOL)matched:(io_service_t)service;

+(NSArray<NSString *> *)IOObjectClassInherit:(NSString *)className;

+(NSDictionary *)matchingInfo:(io_registry_entry_t)entry;
//need release
+(io_registry_entry_t)IORegistryGetRootEntry:(mach_port_t)masterPort;
//need release
+(NSArray<NSNumber *> *)children:(io_registry_entry_t)entry plane:(const io_name_t _Nullable )plane;

+(NSDictionary *)properties:(io_registry_entry_t)entry;

+(NSArray<NSDictionary<NSString *,id>*>*)kextInfoArray;

@end

NS_ASSUME_NONNULL_END
