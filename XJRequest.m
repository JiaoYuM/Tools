//
//  XJRequest.m
//  CashLoan
//
//  Created by jiaoyu on 2017/3/13.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import "XJRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "Reachability.h"
#import "SAMKeychain.h"
#import <CoreTelephony/CoreTelephonyDefines.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *CTSettingCopyMyPhoneNumber();
static NSString *jr_privateBaseUrl = nil;
static NSDictionary *jr_httpHeaders = nil;
static NSHTTPCookie * jr_userCookie = nil;
static BOOL jr_cacheStatus = YES;
static NSString *jr_latitude = nil;
static NSString *jr_longitude = nil;
static CLLocationManager *locationManager = nil;

@implementation XJRequest
+(void)setOrUpdateBaseUrl:(NSString*)baseUrl{
    jr_privateBaseUrl = baseUrl;
}
+(NSString*)baseUrl{
    return jr_privateBaseUrl;
}
+(void)setCurrentLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude{
   
    jr_latitude = [NSString stringWithFormat:@"%f",latitude];
    jr_longitude = [NSString stringWithFormat:@"%f",longitude];
}
+(void)configUserCookie:(id )userToken{
    jr_userCookie = [self creatCookie:@"login_token" cookieValur:userToken];
}
+(void)addNotification{
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(reachAbilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
    [hostReach startNotifier];
}
+(void)reachAbilityChanged:(NSNotification*)note{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable) {
        [XJAlertView toastLabel:NETWORK_OFF inSuperView:[UIApplication sharedApplication].keyWindow];
    }else if (status == ReachableViaWiFi){
        [XJAlertView toastLabel:WiFI_STATUE inSuperView:[UIApplication sharedApplication].keyWindow];
    }else if (status == ReachableViaWWAN){
        [XJAlertView toastLabel:MOBILE_NET inSuperView:[UIApplication sharedApplication].keyWindow];
    }
}
+(void)GetRequestWithUrl:(NSString*)url
             cacheStatue:(BOOL)cacheStatue
              parameters:(NSDictionary*)parameterDic
        returnValueBlock:(ReturnValueBlock)responseBlock
            failureBlock:(FailureBlock)failureBlock{
    jr_cacheStatus = cacheStatue;
    [self requestWithUrl:url parameters:parameterDic httpMethod:@"GET" returnValueBlock:responseBlock failureBlock:failureBlock];
}
    
+(void)PostRequestWithUrl:(NSString*)url
               parameters:(NSDictionary*)parameterDic
         returnValueBlock:(ReturnValueBlock)responseBlock
             failureBlock:(FailureBlock)failureBlock{
    [self requestWithUrl:url parameters:parameterDic httpMethod:@"POST" returnValueBlock:responseBlock failureBlock:failureBlock];
}

+(void)PostRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameterDic contentType:(NSString *)contentType returnValueBlock:(ReturnValueBlock)responseBlock failureBlock:(FailureBlock)failureBlock{
    [self requestWithUrl:url parameters:parameterDic httpMethod:@"POST" contentType:contentType returnValueBlock:responseBlock failureBlock:failureBlock];
}
#pragma mark -Private method
    /*!
     * 私有方法
     *
     */
+(void)requestWithUrl:(NSString *)url
           parameters:(NSDictionary *)parameterDic
           httpMethod:(NSString*)httpMethod
          contentType:(NSString*)contentType
     returnValueBlock:(ReturnValueBlock)responseBlock
         failureBlock:(FailureBlock)failureBlock{
    NSString *absolute;
    absolute = [self absoluteUrlWithPath:url];
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    } else {
        NSURL *absouluteURL = [NSURL URLWithString:absolute];
        if (absouluteURL == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    }
    NSString *getAbsoluteUrl;
    if ([httpMethod isEqualToString:@"GET"]) {
        getAbsoluteUrl = [self generateGETAbsoluteURL:absolute params:parameterDic];
    }else if ([httpMethod isEqualToString:@"POST"]){
        getAbsoluteUrl = absolute;
    }
    NSLog(@"requeset = =%@",getAbsoluteUrl);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:getAbsoluteUrl]];
    __weak ASIFormDataRequest *dataRequest = request;
    if ([httpMethod isEqualToString:@"POST"]) {
        NSArray *allKey = [parameterDic allKeys];
        for (int i = 0; i < parameterDic.count; i++) {
            NSString *key = [allKey objectAtIndex:i];
            id value = [parameterDic objectForKey:key];
            //判断是否为文件
            if ([value isKindOfClass:[NSData class]]) {
                [request setPostBody:value];
            }else{
                [request addPostValue:value forKey:key];
            }
        }
    }
    //修改Content-Type
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:contentType forKey:@"Content-Type"];
    [request setRequestHeaders:dic];

    [request setRequestMethod:httpMethod];
    NSHTTPCookie *cookie = jr_userCookie;
    NSHTTPCookie *cookie1 = [self creatCookie:@"VISIT_SOURCE" cookieValur:@"IOS"];
    NSHTTPCookie *cookie2 = [self creatCookie:@"VISIT_APP_NAME" cookieValur:VISIT_APP_NAME];
    NSHTTPCookie *cookie3 = [self creatCookie:@"CURRENT_VERSION" cookieValur:VERSION];
    [request addRequestHeader:@"clientInfo" value:[self sethttpHeader]];
    [request setRequestCookies:[NSMutableArray arrayWithObjects:cookie1,cookie2,cookie3, cookie, nil]];
    [request setTimeOutSeconds:60];
    if ([httpMethod isEqualToString:@"GET"] && jr_cacheStatus) {
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        [request setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
        [request setCacheStoragePolicy:(ASICachePermanentlyCacheStoragePolicy)];
    }
    [request setCompletionBlock:^{
        NSData *responseData = [dataRequest.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:nil];
        NSLog(@"response %@",responseDic);
        NSLog(@"message%@",responseDic[@"message"]);
        //做停服处理
        if (request.responseStatusCode == 502) {
            //            [self fetchSeverState];
        }
        responseBlock(responseDic,dataRequest.responseStatusCode);
        /***************************************
         在这做判断如果responseDic里有errorCode调用errorBlock(responseDic)
         没有errorCode则只调用responseBlock(responseDic)
         ******************************/
    }];
    [request setFailedBlock:^{
        if (dataRequest.error.code == ASIRequestTimedOutErrorType) {
            failureBlock(REQUEST_FAIL_MESSAGE);
        }else if (dataRequest.error.code == ASIConnectionFailureErrorType){
            failureBlock(NETWORK_LINK_FAIL);
        }else{
            failureBlock(dataRequest.error.localizedDescription);
        }
        NSLog(@"%@==%@",dataRequest.error,dataRequest.error.localizedDescription);
    }];
    [request startAsynchronous];
}

+(void)requestWithUrl:(NSString *)url
           parameters:(NSDictionary *)parameterDic
           httpMethod:(NSString*)httpMethod
     returnValueBlock:(ReturnValueBlock)responseBlock
         failureBlock:(FailureBlock)failureBlock{
    NSString *absolute;
        absolute = [self absoluteUrlWithPath:url];
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    } else {
        NSURL *absouluteURL = [NSURL URLWithString:absolute];
        if (absouluteURL == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    }
    NSString *getAbsoluteUrl;
    if ([httpMethod isEqualToString:@"GET"]) {
        getAbsoluteUrl = [self generateGETAbsoluteURL:absolute params:parameterDic];
    }else if ([httpMethod isEqualToString:@"POST"]){
        getAbsoluteUrl = absolute;
    }
    NSLog(@"requeset = =%@",getAbsoluteUrl);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:getAbsoluteUrl]];
    __weak ASIFormDataRequest *dataRequest = request;
    if ([httpMethod isEqualToString:@"POST"]) {
        NSArray *allKey = [parameterDic allKeys];
        for (int i = 0; i < parameterDic.count; i++) {
            NSString *key = [allKey objectAtIndex:i];
            id value = [parameterDic objectForKey:key];
            //判断是否为文件
            if ([value isKindOfClass:[NSData class]]) {
                [request setPostBody:value];
            }else{
                [request addPostValue:value forKey:key];
            }
        }
    }
    [request setRequestMethod:httpMethod];
    NSHTTPCookie *cookie = jr_userCookie;
    NSHTTPCookie *cookie1 = [self creatCookie:@"VISIT_SOURCE" cookieValur:@"IOS"];
    NSHTTPCookie *cookie2 = [self creatCookie:@"VISIT_APP_NAME" cookieValur:VISIT_APP_NAME];
    NSHTTPCookie *cookie3 = [self creatCookie:@"CURRENT_VERSION" cookieValur:VERSION];
    [request addRequestHeader:@"clientInfo" value:[self sethttpHeader]];
    [request setRequestCookies:[NSMutableArray arrayWithObjects:cookie1,cookie2,cookie3, cookie, nil]];
    [request setTimeOutSeconds:60];
    if ([httpMethod isEqualToString:@"GET"] && jr_cacheStatus) {
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        [request setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
        [request setCacheStoragePolicy:(ASICachePermanentlyCacheStoragePolicy)];
    }
    [request setCompletionBlock:^{
        NSData *responseData = [dataRequest.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:nil];
        NSLog(@"response %@",responseDic);
        NSLog(@"message%@",responseDic[@"message"]);
        //做停服处理
        if (request.responseStatusCode == 502) {
//            [self fetchSeverState];
        }
        responseBlock(responseDic,dataRequest.responseStatusCode);
        /***************************************
         在这做判断如果responseDic里有errorCode调用errorBlock(responseDic)
         没有errorCode则只调用responseBlock(responseDic)
         ******************************/
    }];
    [request setFailedBlock:^{
        if (dataRequest.error.code == ASIRequestTimedOutErrorType) {
            failureBlock(REQUEST_FAIL_MESSAGE);
        }else if (dataRequest.error.code == ASIConnectionFailureErrorType){
            failureBlock(NETWORK_LINK_FAIL);
        }else{
            failureBlock(dataRequest.error.localizedDescription);
        }
        NSLog(@"%@==%@",dataRequest.error,dataRequest.error.localizedDescription);
    }];
    [request startAsynchronous];
}
    
+ (NSString *)absoluteUrlWithPath:(NSString *)path {
    if (path == nil || path.length == 0) {
        return @"";
    }
    
    if ([self baseUrl] == nil || [[self baseUrl] length] == 0) {
        return path;
    }
    
    NSString *absoluteUrl = path;
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        if ([[self baseUrl] hasSuffix:@"/"]) {
            if ([path hasPrefix:@"/"]) {
                NSMutableString * mutablePath = [NSMutableString stringWithString:path];
                [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
                absoluteUrl = [NSString stringWithFormat:@"%@%@",
                               [self baseUrl], mutablePath];
            } else {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }
        } else {
            if ([path hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            } else {
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",
                               [self baseUrl], path];
            }
        }
    }
    return absoluteUrl;
}
    // 仅对一级字典结构起作用
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}
//上传图片
+(void)uploadWithImage:(UIImage *)image url:(NSString *)url filename:(NSString *)filename name:(NSString *)name mimeType:(NSString *)mimeType parameters:(NSDictionary *)parameters success:(ReturnValueBlock)success fail:(FailureBlock)fail{
    NSString *absolute = [self absoluteUrlWithPath:url];
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    } else {
        NSURL *absouluteURL = [NSURL URLWithString:absolute];
        if (absouluteURL == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    }
    NSData *data = UIImageJPEGRepresentation(image,1);//获取图片数据
    NSMutableData *imageData = [NSMutableData dataWithData:data];//ASIFormDataRequest 的setPostBody 方法需求的为NSMutableData类型
    NSURL *URL = [NSURL URLWithString:absolute];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
    __weak ASIFormDataRequest *requestData = request;
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"clientInfo" value:[self sethttpHeader]];
    [request setTimeOutSeconds:90];
    NSString *imageFileName = filename;
    if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
    }
    [request setData:imageData withFileName:imageFileName andContentType:mimeType forKey:name];
    [request startAsynchronous];
    [request setCompletionBlock:^{
        NSData *responseData = [requestData.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:nil];
        success(responseDic,requestData.responseStatusCode);
    }];
    
    [request setFailedBlock:^{
        if (request.error.code == ASIRequestTimedOutErrorType) {
            fail(REQUEST_FAIL_MESSAGE);
        }else if (request.error.code == ASIConnectionFailureErrorType){
            fail(NETWORK_LINK_FAIL);
        }else{
            fail(requestData.error.localizedDescription);
        }
    }];
}
//上传多张图片
+(void)uploadWithImageArr:(NSArray *)imageArray url:(NSString *)url filename:(NSString *)filename name:(NSString *)name mimeType:(NSString *)mimeType parameters:(NSDictionary *)parameters success:(ReturnValueBlock)success fail:(FailureBlock)fail{
    NSString *absolute = [self absoluteUrlWithPath:url];
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    } else {
        NSURL *absouluteURL = [NSURL URLWithString:absolute];
        if (absouluteURL == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    }
    
    NSURL *URL = [NSURL URLWithString:absolute];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
    __weak ASIFormDataRequest *requestData = request;
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"clientInfo" value:[self sethttpHeader]];
    [request setTimeOutSeconds:90];
    
    for (UIImage *image in imageArray) {
        NSData *data = UIImageJPEGRepresentation(image,1);//获取图片数据
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        [request addData:data withFileName:imageFileName andContentType:mimeType forKey:name];
    }
    [request startAsynchronous];
    [request setCompletionBlock:^{
        NSData *responseData = [requestData.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:nil];
        success(responseDic,requestData.responseStatusCode);
    }];
    
    [request setFailedBlock:^{
        if (request.error.code == ASIRequestTimedOutErrorType) {
            fail(REQUEST_FAIL_MESSAGE);
        }else if (request.error.code == ASIConnectionFailureErrorType){
            fail(NETWORK_LINK_FAIL);
        }else{
            fail(requestData.error.localizedDescription);
        }
    }];
}
//上传文件
+(void)uploadWithFile:(NSData *)data url:(NSString *)url authorization:(NSString *)authorization name:(NSString *)name mimeType:(NSString *)mimeType parameters:(NSDictionary *)parameters success:(ReturnValueBlock)success fail:(FailureBlock)fail{
    NSString *absolute = [self absoluteUrlWithPath:url];
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    } else {
        NSURL *absouluteURL = [NSURL URLWithString:absolute];
        if (absouluteURL == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    }
    NSURL *URL = [NSURL URLWithString:absolute];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
    __weak ASIFormDataRequest *requestData = request;
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"clientInfo" value:[self sethttpHeader]];
    [request setTimeOutSeconds:90];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:authorization forKey:@"Authorization"];
    [dic setValue:mimeType forKey:@"Content-Type"];
    
    NSArray *allKey = [parameters allKeys];
    for (int i = 0; i < parameters.count; i++) {
        NSString *key = [allKey objectAtIndex:i];
        id value = [parameters objectForKey:key];
        //判断是否为文件
        if ([value isKindOfClass:[NSData class]]) {
            [request addData:value forKey:key];
        }else{
            [request addPostValue:value forKey:key];
        }
    }
    [request setRequestHeaders:dic];
    [request setData:data withFileName:name andContentType:@"multipart/form-data" forKey:name];
    [request startAsynchronous];
    [request setCompletionBlock:^{
        NSData *responseData = [requestData.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:nil];
        success(responseDic,requestData.responseStatusCode);
    }];
    
    [request setFailedBlock:^{
        if (request.error.code == ASIRequestTimedOutErrorType) {
            fail(REQUEST_FAIL_MESSAGE);
        }else if (request.error.code == ASIConnectionFailureErrorType){
            fail(NETWORK_LINK_FAIL);
        }else{
            fail(requestData.error.localizedDescription);
        }
    }];
}
+(NSHTTPCookie*)creatCookie:(NSString*)cookieName cookieValur:(NSString*)cookieValue{
    NSDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setValue:cookieName forKey:NSHTTPCookieName];
    [properties setValue:cookieValue forKey:NSHTTPCookieValue];
    [properties setValue:CookieDomain forKey:NSHTTPCookieDomain];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    [properties setValue:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    return cookie;
}
//json数据加密
+(NSString *)sethttpHeader{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:jr_longitude forKey:@"longitude"];
    [params setValue:jr_latitude forKey:@"latitude"];
    [params setValue:[self getUUID] forKey:@"deviceId"];
    [params setValue:@"0" forKey:@"clientType"];
    [params setValue:[self getPhoneNum] forKey:@"mobile"];
    [params setValue:VERSION forKey:@"version"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonStr);
    NSString *encryptStr = [CryptLib encryptWith:jsonStr];
    return encryptStr;
}
//获取UUID
+(NSString *)getUUID{
    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:@" " account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SAMKeychain setPassword: currentDeviceUUIDStr forService:@" " account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}
//获取用户手机号
+(NSString *)getPhoneNum{
    return [XJUserDefault stringForKey:@"SBFormattedPhoneNumber"];
}

//+(void)fetchSeverState{
//    [XJRequest GetRequestWithUrl:StopSever cacheStatue:NO parameters:nil returnValueBlock:^(id returnValue, int responseStatusCode) {
//        NSLog(@"response = %@",returnValue);
//    } failureBlock:^(NSString *errorMessage) {
//        
//    }];
//}

@end
