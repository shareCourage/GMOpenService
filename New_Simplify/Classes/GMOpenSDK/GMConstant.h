//
//  GMConstant.h
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/16.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define GM_UniqueId_URL      @"http://open-dev.gpsoo.net/1/uniqueid/get?appid="
#define GM_Open_URL          @"http://open-dev.gpsoo.net/1/device/"
#define GM_Setloc_URL        @"http://open-dev.gpsoo.net/1/device/setloc"           //位置上传
#define GM_Getnearby_URL     @"http://open-dev.gpsoo.net/1/device/getnearby"     //附近设备提取
#define GM_GetHistoryloc_URL @"http://open-dev.gpsoo.net/1/device/gethisloc" //历史位置获取
#define GM_Getloc_URL        @"http://open-dev.gpsoo.net/1/device/getloc"    //获取设备最新位置信息
#define GM_Get_Fence_URL     @"http://open-dev.gpsoo.net/1/fence/get"
#define GM_Create_Fence_URL  @"http://open-dev.gpsoo.net/1/fence/create"
#define GM_Delete_Fence_URL  @"http://open-dev.gpsoo.net/1/fence/delete"
#define GM_Modify_Fence_URL  @"http://open-dev.gpsoo.net/1/fence/modify"
#define GM_Login_URL         @"http://open-dev.gpsoo.net/1/device/login"
#define GM_Logout_URL        @"http://open-dev.gpsoo.net/1/device/logout"
#define GM_APNS_Provider_URL @"http://open-dev.gpsoo.net/1/push/getchannelid"
#define GM_GetAlarm_URL      @"http://open-dev.gpsoo.net/1/alarm/gethis"


//#define GM_UniqueId_URL      @"http://open.goome.net/1/uniqueid/get?appid="
//#define GM_Open_URL          @"http://open.goome.net/1/device/"
//#define GM_Setloc_URL        @"http://open.goome.net/1/device/setloc"           //位置上传
//#define GM_Getnearby_URL     @"http://open.goome.net/1/device/getnearby"     //附近设备提取
//#define GM_GetHistoryloc_URL @"http://open.goome.net/1/device/gethisloc" //历史位置获取
//#define GM_Getloc_URL        @"http://open.goome.net/1/device/getloc"    //获取设备最新位置信息
//#define GM_Get_Fence_URL     @"http://open.goome.net/1/fence/get"
//#define GM_Create_Fence_URL  @"http://open.goome.net/1/fence/create"
//#define GM_Delete_Fence_URL  @"http://open.goome.net/1/fence/delete"
//#define GM_Modify_Fence_URL  @"http://open.goome.net/1/fence/modify"
//#define GM_Login_URL         @"http://open.goome.net/1/device/login"
//#define GM_Logout_URL        @"http://open.goome.net/1/device/logout"
//#define GM_APNS_Provider_URL @"http://open.goome.net/1/push/getchannelid"
//#define GM_GetAlarm_URL      @"http://open.goome.net/1/alarm/gethis"

//#define GM_APNS_Provider_URL @"http://wx-test.gpsoo.net/1/push/getchannelid"

#define GM_Argument_appid       @"appid"
#define GM_Argument_devid       @"devid"
#define GM_Argument_map_type    @"map_type"
#define GM_Argument_fenceid     @"fenceid"
#define GM_Argument_shape       @"shape"
#define GM_Argument_threshold   @"threshold"
#define GM_Argument_area        @"area"
#define GM_Argument_enable      @"enable"
#define GM_Argument_devinfo     @"devinfo"
#define GM_Argument_gps_time    @"gps_time"
#define GM_Argument_course      @"course"
#define GM_Argument_speed       @"speed"
#define GM_Argument_lng         @"lng"
#define GM_Argument_lat         @"lat"
#define GM_Argument_begin_time  @"begin_time"
#define GM_Argument_end_time    @"end_time"
#define GM_Argument_data        @"data"
#define GM_Argument_distance    @"distance"
#define GM_Argument_fenceName   @"name"
#define GM_Argument_limit       @"limit"
#define GM_Argument_in          @"in"
#define GM_Argument_out         @"out"
#define GM_Argument_name        @"name"
#define GM_Argument_update_time @"update_time"

#define GM_Argument_account     @"account"
#define GM_Argument_time        @"time"
#define GM_Argument_signature   @"signature"
#define GM_Argument_access_type @"access_type"
#define GM_Argument_msg         @"msg"
#define GM_Argument_platform    @"platform"
#define GM_Argument_apnsToken   @"apns_token"
#define GM_Argument_cid         @"cid"
#define GM_Argument_channelid   @"channelid"
#define GM_Argument_devinfo     @"devinfo"

#define GM_Argument_fingerprint @"fingerprint"
#define GM_Argument_lang        @"lang"
#define GM_Argument_timezone    @"timezone"

#define GM_Argument_tag1        @"tag1"
#define GM_Argument_tag2        @"tag2"
#define GM_Argument_tag3        @"tag3"

#define GM_Argument_typeid      @"typeid"
#define GM_Argument_pageno      @"pageno"
#define GM_Argument_pagesize    @"pagesize"

#define GM_KeyOfAppid           @"keyOfGoomeAppid"
#define GM_KeyOfChannelid       @"keyOfChannelid"
#define GM_UserDefaults         [NSUserDefaults standardUserDefaults]
#define GM_CurrentTime          [NSString stringWithFormat:@"%.f",[NSDate date].timeIntervalSince1970]

/**
 归档的实现
 */
#define GMCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self encode:encoder]; \
}


