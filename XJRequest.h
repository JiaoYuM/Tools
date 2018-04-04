//
//  XJRequest.h
//  CashLoan
//
//  Created by jiaoyu on 2017/3/13.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 *  定义返回请求数据的block类型
 *  ReturnValueBlock 请求返回调用 参数returnValue返回结果(里边包含服务器的状态码)  responseStatueCode 返回Http协议状态码
 *  ErrorCodeBlock 接口返回里边包含errorCode则调用 没的话不用调用
 *  FailureBlock 请求失败调用 一般是服务器没响应的网络不好
 */
typedef void (^ReturnValueBlock) (id returnValue, int responseStatusCode);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)(NSString* errorMessage);
@interface XJRequest : NSObject
+(void)setOrUpdateBaseUrl:(NSString*)baseUrl;
+(NSString*)baseUrl;
+(void)configUserCookie:(id)userToken;
+(void)addNotification;
+(NSString *)sethttpHeader;
//设置经纬度
+(void)setCurrentLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude;
/**
     *  responseBlock 正常的结果返回 包含结果和HTTP协议的错误码
     *  errorBlock responseBlock返回的服务器正常结果里包含state code
     *  failureBlock 网络请求失败时候 超时无响应等
*/

+(void)GetRequestWithUrl:(NSString*)url
             cacheStatue:(BOOL)cacheStatue
              parameters:(NSDictionary*)parameterDic
        returnValueBlock:(ReturnValueBlock)responseBlock
            failureBlock:(FailureBlock)failureBlock;
/**
     *  responseBlock 正常的结果返回 包含结果和HTTP协议的错误码
     *  errorBlock responseBlock返回的服务器正常结果里包含state code
     *  failureBlock 网络请求失败时候 超时无响应等
*/
+(void)PostRequestWithUrl:(NSString*)url
               parameters:(NSDictionary*)parameterDic
         returnValueBlock:(ReturnValueBlock)responseBlock
             failureBlock:(FailureBlock)failureBlock;

/**
 *  responseBlock 正常的结果返回 包含结果和HTTP协议的错误码
 *  errorBlock responseBlock返回的服务器正常结果里包含state code
 *  failureBlock 网络请求失败时候 超时无响应等
 *  contentType   类型
 */
+(void)PostRequestWithUrl:(NSString*)url
               parameters:(NSDictionary*)parameterDic
              contentType:(NSString*)contentType
         returnValueBlock:(ReturnValueBlock)responseBlock
             failureBlock:(FailureBlock)failureBlock;
//上传图片
+(void)uploadWithImage:(UIImage *)image
                   url:(NSString *)url
              filename:(NSString *)filename
                  name:(NSString *)name
              mimeType:(NSString *)mimeType
            parameters:(NSDictionary *)parameters
               success:(ReturnValueBlock)success
                  fail:(FailureBlock)fail;
//上传多张图片
+(void)uploadWithImageArr:(NSArray *)imageArray
                      url:(NSString *)url
                 filename:(NSString *)filename
                     name:(NSString *)name
                 mimeType:(NSString *)mimeType
               parameters:(NSDictionary *)parameters
                  success:(ReturnValueBlock)success
                     fail:(FailureBlock)fail;
//上传文件
+(void)uploadWithFile:(NSData *)data
                   url:(NSString *)url
              authorization:(NSString *)authorization
                  name:(NSString *)name
              mimeType:(NSString *)mimeType
            parameters:(NSDictionary *)parameters
               success:(ReturnValueBlock)success
                  fail:(FailureBlock)fail;
@end
