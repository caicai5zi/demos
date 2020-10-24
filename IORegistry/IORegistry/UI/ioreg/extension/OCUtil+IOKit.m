//
//  OCUtil+IOKit.m
//  HRSword
//
//  Created by app on 2020/10/20.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

#import "OCUtil+IOKit.h"
#import <IOKit/kext/KextManager.h>

@implementation OCUtil (IOKit)

+(NSString *)IORegistryEntryGetNameInPlane:(io_registry_entry_t)entry plane:(const io_name_t)plane{
    io_name_t name;
    name[0]=0;
    IORegistryEntryGetNameInPlane(entry, plane, name);
    NSString * res = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    return res;
}

+(NSString *)IOObjectGetClass:(io_registry_entry_t)entry{
    io_name_t className;
    className[0]=0;
    IOObjectGetClass(entry,className);
    NSString * res = [NSString stringWithCString:className encoding:NSUTF8StringEncoding];
    return res;
}

+(NSString *)IOObjectGetClasses:(io_registry_entry_t)entry{
    NSMutableArray * res = [NSMutableArray array];
    CFStringRef className = IOObjectCopyClass(entry);
    while (className) {
        [res addObject:(__bridge NSString * _Nonnull)(className)];
        CFStringRef newName = IOObjectCopySuperclassForClass(className);
        CFRelease(className);
        className = newName;
    }
    return [res componentsJoinedByString:@" : "];
}

+(NSArray<NSString *> *)IOObjectClassInherit:(NSString *)className {
    NSMutableArray * res = [NSMutableArray array];
    CFStringRef name = (__bridge CFStringRef)(className);
    CFRetain(name);
    while (name) {
        [res addObject:(__bridge NSString * _Nonnull)name];
        CFStringRef newName = IOObjectCopySuperclassForClass(name);
        CFRelease(name);
        name = newName;
    }
    return res;
}

+(NSString * _Nullable)BundleIdentifierForEntry:(io_registry_entry_t)entry {
    CFStringRef className = IOObjectCopyClass(entry);
    CFStringRef bundleId = IOObjectCopyBundleIdentifierForClass(className);
    NSString * res = (__bridge NSString *)(bundleId);
    CFRelease(className);
    CFRelease(bundleId);
    return res;
}

+(NSDictionary*)properties:(io_registry_entry_t)entry {
    NSDictionary * res = [NSDictionary dictionary];
    CFMutableDictionaryRef properties = 0;
    IORegistryEntryCreateCFProperties( entry, &properties, kCFAllocatorDefault, kNilOptions );
    if(properties){
        res = (__bridge NSDictionary *)(properties);
        CFRelease(properties);
    }
    return res;
}

+(uint32_t)busyState:(io_service_t)service {
    uint32_t busyState = 0;
    if (IOObjectConformsTo(service, "IOService")) {
        IOServiceGetBusyState(service, &busyState);
    }
    return busyState;
}

+(BOOL)matched:(io_service_t)service {
    uint64_t currentID = 0;
    if( IORegistryEntryGetRegistryEntryID(service, &currentID) != KERN_SUCCESS ){
        return NO;
    }
    io_name_t className;
    className[0]=0;
    if( IOObjectGetClass(service,className) != KERN_SUCCESS ){
        return  NO;
    }
    CFMutableDictionaryRef dic = IOServiceMatching(className);
    if (dic) {
        io_iterator_t existing;
        if(IOServiceGetMatchingServices(kIOMasterPortDefault, dic, &existing) != KERN_SUCCESS) {
            return NO;
        }
        BOOL matched = NO;
        io_service_t service = IOIteratorNext(existing);
        while (service) {
            uint64_t entryID = 0;
            IORegistryEntryGetRegistryEntryID(service, &entryID);
            if (currentID == entryID) {
                matched = YES;
                break;
            }
            service = IOIteratorNext(existing);
        }
        IOObjectRelease(existing);
        return matched;
    }
    return NO;
}

+(NSDictionary *)matchingInfo:(io_registry_entry_t)entry {
    uint32_t busyState;
    IOServiceGetBusyState(entry, &busyState);
    printf("%d",busyState);
    
    uint64_t entryID = 0;
    IORegistryEntryGetRegistryEntryID(entry, &entryID);
    printf("current: %llu\n",entryID);
    
    
    io_name_t className;
    className[0]=0;
    IOObjectGetClass(entry,className);
    CFMutableDictionaryRef dic = IOServiceMatching(className);
    io_iterator_t existing;
    IOServiceGetMatchingServices(kIOMasterPortDefault, dic, &existing);
    io_service_t service = IOIteratorNext(existing);
    while (service)
    {
        uint64_t entryID = 0;
        IORegistryEntryGetRegistryEntryID(service, &entryID);
        service = IOIteratorNext(existing);
    }

    return nil;
}

//需要 release
+(io_registry_entry_t)IORegistryGetRootEntry:(mach_port_t)masterPort{
    return IORegistryGetRootEntry(masterPort);
}

//child 需要IOObjectRelease
+(NSArray<NSNumber *> *)children:(io_registry_entry_t)entry plane:(const io_name_t)plane{
    NSMutableArray * res = [NSMutableArray array];
    io_iterator_t child_list = 0; // (needs release)
    kern_return_t status = IORegistryEntryGetChildIterator(entry,plane, &child_list);
    if (status != KERN_SUCCESS)
        return [NSArray array];
    io_registry_entry_t child = IOIteratorNext(child_list);
    while (child)
    {
        [res addObject:@(child)];
        child = IOIteratorNext(child_list);
    }
    IOObjectRelease(child_list);
    return [NSArray arrayWithArray:res];
}

+(NSArray<NSDictionary<NSString *,id>*>*)kextInfoArray{
    NSMutableArray * res = [NSMutableArray array];
    CFDictionaryRef LoadKextInfo_Dict= KextManagerCopyLoadedKextInfo(NULL,NULL);//沙箱限制， 权限无关
    if(LoadKextInfo_Dict==NULL)
        return [NSArray arrayWithArray:res];
    do
    {
        //读取每一个被加载的kext信息
        CFIndex KextCount=CFDictionaryGetCount(LoadKextInfo_Dict);
        if(KextCount==0)
            break;
        CFDictionaryRef* KextIinfo_list = (CFDictionaryRef *)malloc(KextCount * sizeof(CFDictionaryRef));
        if (KextIinfo_list==NULL)
            break;
        CFDictionaryGetKeysAndValues(LoadKextInfo_Dict, /* keys */ (const void**)NULL,(const void **)KextIinfo_list);
        for(CFIndex i=0;i<KextCount;i++)
        {
            CFDictionaryRef kextinfo=KextIinfo_list[i];
            if(CFDictionaryGetTypeID() != CFGetTypeID(kextinfo))
                continue;
            NSDictionary * info = (__bridge NSDictionary *)(kextinfo);
            [res addObject:info];
        }
        free(KextIinfo_list);
    }while(0);
    CFRelease(LoadKextInfo_Dict);
    return [NSArray arrayWithArray:res];
}

@end
