//
//  NetworkTool.h
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@class NetworkTool;
/**
 *  网络请求成功回调
 *
 *  @param data 返回数据
 *  @param http http对象
 */
typedef void(^HttpWorkSuccess)(id data, NetworkTool *http);

/**
 *  网络请求失败回调
 *
 *  @param error 错误
 *  @param http  http对象
 */
typedef void(^HttpWorkFail)(NSError *error, NetworkTool *http);


typedef NS_ENUM(NSInteger, HttpWorkType)
{
    /**
     *  GET请求
     */
    kHttpWorkTypeGET    = 1 << 0,
    /**
     *  POST请求
     */
    kHttpWorkTypePOST   = 1 << 1,
    /**
     *  PUT请求
     */
    kHttpWorkTypePUT    = 1 << 2,
    /**
     *  DELETE请求
     */
    kHttpWorkTypeDELETE = 1 << 3,
    /**
     *  PATCH请求
     */
    kHttpWorkTypePATCH  = 1 << 4
};

typedef NS_ENUM(NSInteger, netWorkBaseUrlType)
{
    /**
     *  默认urlERP
     */
    kNetWorkBaseUrlDefault    = 1 << 0,
    /**
     *  其他url OES
     */
    kNetWorkBaseUrlSpecial    = 1 << 1,
    
    // 特殊url
    kNetWorkBaseUrlSpecialCommonUrl  = 1 << 2,
    
    //公共的接口
    kNetWorkCommonUrl = 1 << 3
};

/**
 *  网络封装类
 */
@interface NetworkTool : AFHTTPSessionManager

//单例对象
+ (instancetype)sharedNetworkTool;

/**
 *  普通http请求
 *
 *  @param success  成功block回调
 *  @param fail     失败block回调
 *  @param httpType http类型
 *  @param model    请求模块
 *  @param param    请求参数
 *
 *  @return http对象
 */

+ (NetworkTool *)httpRequestData:(HttpWorkSuccess)success
                            fail:(HttpWorkFail)fail
                  netBaseUrlType:(netWorkBaseUrlType)baseUrlType
                            type:(HttpWorkType)httpType
                            boid:(NSString *)boid
                           model:(NSString *)model
                        paramter:(NSDictionary *)param
                           login:(BOOL)isLogin;

/**
 *  普通http请求
 *
 *  @param success  成功block回调
 *  @param fail     失败block回调
 *  @param httpType http类型
 *  @param model    请求模块
 *  @param arg      可变参数， key, value, key , value ...
 *
 *  @return http对象
 */
+ (NetworkTool *)httpRequestData:(HttpWorkSuccess)success
                            fail:(HttpWorkFail)fail
                  netBaseUrlType:(netWorkBaseUrlType)baseUrlType
                            type:(HttpWorkType)httpType
                            boid:(NSString *)boid
                           model:(NSString *)model
                         isLogin:(BOOL)login                            args:(NSObject <NSCopying, NSSecureCoding> *)arg, ...NS_REQUIRES_NIL_TERMINATION;


// 上传图片
+ (NetworkTool *)uploadImage:(HttpWorkSuccess)success
                        fail:(HttpWorkFail)fail
               withURLString:(NSString *)URLString
                  parameters:(id)parameters
                  uploadData:(NSData *)uploadData
                  uploadName:(NSString *)uploadName;


// 上传多张图片
+ (NetworkTool *)uploadMostImage:(HttpWorkSuccess)success
                            fail:(HttpWorkFail)fail
                   withURLString:(NSString *)URLString
                      parameters:(id)parameters
                     uploadDatas:(NSArray *)uploadDatas
                      uploadName:(NSString *)uploadName;



@end



