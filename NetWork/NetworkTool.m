//
//  NetworkTool.m
//

#import "NetworkTool.h"
#import "SVProgressHUD.h"
#import "NSDictionary+DRVHSetNilStr.h"
#import "Base64.h"



@interface NetworkTool ()

//请求参数
@property (nonatomic, strong) NSDictionary *args;
//方法
@property (nonatomic, strong) NSString *method;

@end


#define valid @"12d"

@implementation NetworkTool

+ (instancetype)sharedNetworkTool {
    
    static NetworkTool *instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[NetworkTool alloc] init];
        instance.requestSerializer = [AFHTTPRequestSerializer serializer];
        [instance.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        instance.requestSerializer.timeoutInterval = 10.0f;
        [instance.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        instance.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/xml/zip/",@"text/plain",@"text/html",@"text/javascript",nil];
        //忽略缓存
        instance.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    });
    return instance;
}


//多字典对象传入
+ (NetworkTool *)httpRequestData:(HttpWorkSuccess)success fail:(HttpWorkFail)fail netBaseUrlType:(netWorkBaseUrlType)baseUrlType type:(HttpWorkType)httpType boid:(NSString *)boid model:(NSString *)model isLogin:(BOOL)login args:(NSString *)arg, ... {
    
    NetworkTool *instance = [NetworkTool sharedNetworkTool];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    va_list args;
    va_start(args, arg);
    if (arg) {
        
        NSString *key = arg;
        NSString *str = va_arg(args, NSString *);
        while (str)
        {
            if (key)
            {
                [dic setObject:str  forKey:key];
                key = nil;
            }
            else
            {
                key = str;
            }
            str = va_arg(args, NSString *);
        }
        va_end(args);
    }
    [instance httpCallRequestData:success fail:fail netBaseUrlType:baseUrlType type:httpType boid:boid model:model paramater:dic isLogin:login];
    
    return instance;
}

//单字典对象传入
+ (NetworkTool *)httpRequestData:(HttpWorkSuccess)success fail:(HttpWorkFail)fail netBaseUrlType:(netWorkBaseUrlType)baseUrlType type:(HttpWorkType)httpType  boid:(NSString *)boid model:(NSString *)model paramter:(NSDictionary *)param login:(BOOL)islogin {
    
    NetworkTool *instance = [NetworkTool sharedNetworkTool];
    
    if (netStatus < 1) {
        
        [SVProgressHUD showErrorWithStatus:@"无法连接网络！"];
        
    }else {
        
        [instance httpCallRequestData:success fail:fail netBaseUrlType:baseUrlType type:httpType boid:boid model:model paramater:param isLogin:islogin];
        
    }
    return instance;
}

- (void)httpCallRequestData:(HttpWorkSuccess)success fail:(HttpWorkFail)fail netBaseUrlType:(netWorkBaseUrlType)baseUrlType type:(HttpWorkType)httpType boid:(NSString *)boid model:(NSString *)model paramater:(NSDictionary *)param isLogin:(BOOL)isLogin {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *fullUrl = [NSString string];
    //OES这个Type默认走的是不登录的OES地址
    if (baseUrlType == kNetWorkBaseUrlSpecial) {
        //拼接请求的接口
        fullUrl = [NSString stringWithFormat:@"%@",otherBaseUrl];
        
        switch (httpType) {
            case kHttpWorkTypeGET:
                fullUrl = [fullUrl stringByAppendingString:@"!get.action"];
                break;
            case kHttpWorkTypePOST:
                fullUrl = [fullUrl stringByAppendingString:@"!post.action"];
                break;
            default:
                break;
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        //字典转字符串
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [para setObject:model forKey:@"method"];
        [para setObject:valid forKey:@"valid"];
        [para setObject:str forKey:@"data"];
        
        //该Type为HERP地址
    }else if (baseUrlType == kNetWorkBaseUrlDefault){
        
        //拼接请求的接口(默认适用与ERP)
        fullUrl = [NSString stringWithFormat:@"%@%@",baseUrl ,model];
        para = [param mutableCopy];
        
        //拼接请求接口地址(默认走OES登录地址)
    }else if (baseUrlType == kNetWorkBaseUrlSpecialCommonUrl){
        //拼接请求的接口(一般走ERP登录接口)
        fullUrl = [NSString stringWithFormat:@"%@",commonServiceUrl];
        switch (httpType) {
            case kHttpWorkTypeGET:
                fullUrl = [fullUrl stringByAppendingString:@"!get.action"];
                break;
            case kHttpWorkTypePOST:
                fullUrl = [fullUrl stringByAppendingString:@"!post.action"];
                break;
            default:
                break;
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [para setObject:str forKey:@"data"];
        
        [para setObject:model forKey:@"method"];
        [para setObject:valid forKey:@"valid"];
        [para setObject:boid forKey:@"boid"];
    }else if (baseUrlType == kNetWorkCommonUrl){   //通用的接口
        
        fullUrl = [NSString stringWithFormat:@"%@!%@.action",commonServiceUrl,model];
        
        para = [param mutableCopy];
    }
    
    self.method = model;
    self.args = para;
    
    NSLog(@"地址URL = %@, 参数para = %@", fullUrl, para);
    __weak typeof(self) weakSelf = self;
    
    switch (httpType) {
        case kHttpWorkTypeGET:
        {
            [weakSelf GET:fullUrl parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 获得的json先转换成字符串
                NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"接受到的数据(receiveData) == %@",receiveStr);
                // 字符串再生成NSData
                NSData * data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
                //再解析
                NSDictionary *newDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                //再解析
                NSDictionary *jsonDict = [NSDictionary changeType:newDict];
                
                // 获取数据结果
                [weakSelf fixErrorCode:[[jsonDict objectForKey:@"status"]integerValue] model:model message:jsonDict[@"message"]];
                
                //成功之后的回调
                if (success) success(jsonDict, self);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (fail) fail(error, self);
                NSLog(@"httpFail %@", error.userInfo);
                
                NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
                NSInteger code = response.statusCode;
                
                NSLog(@"cookie = %@",response.allHeaderFields[@"Set-Cookie"]);
                [self.requestSerializer setValue:response.allHeaderFields[@"Set-Cookie"] forHTTPHeaderField:@"Cookie"];
                if (isLogin == YES && code == 403) {
                    
                    [weakSelf httpCheckLogin:^(id data, NetworkTool *http) {
                        [weakSelf httpCallRequestData:success fail:fail netBaseUrlType:baseUrlType type:httpType boid:boid model:model paramater:param isLogin:isLogin];
                        
                        [SVProgressHUD dismiss];
                        
                    } fail:^(NSError *error, NetworkTool *http) {
                        [weakSelf showConnectErrorBy:model];
                    }];
                }else {
                    [weakSelf showConnectErrorBy:model];
                }
            }];
        }
            break;
            
        case kHttpWorkTypePOST:
        {
            
            [weakSelf POST:fullUrl parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 获得的json先转换成字符串
                NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"接受到的数据(receiveData 11) == %@",receiveStr);
                // 字符串再生成NSData
                NSData * data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *newDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                //再解析
                NSDictionary *jsonDict = [NSDictionary changeType:newDict];
                // 获取数据结果
                [weakSelf fixErrorCode:[[jsonDict objectForKey:@"status"] integerValue] model:model message:jsonDict[@"message"]];
                
                //成功之后的回调
                if (success) success(jsonDict, self);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (fail) fail(error, self);
                NSLog(@"httpFail %@", error.userInfo);
                NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
                NSInteger code = response.statusCode;
                
                NSLog(@"cookie = %@",response.allHeaderFields[@"Set-Cookie"]);
                [self.requestSerializer setValue:response.allHeaderFields[@"Set-Cookie"] forHTTPHeaderField:@"Cookie"];
                if (isLogin == YES && code == 403) {
                    
                    [weakSelf httpCheckLogin:^(id data, NetworkTool *http) {
                        [weakSelf httpCallRequestData:success fail:fail netBaseUrlType:baseUrlType type:httpType boid:boid model:model paramater:param isLogin:isLogin];
                        
                        [SVProgressHUD dismiss];
                        
                    } fail:^(NSError *error, NetworkTool *http) {
                        [weakSelf showConnectErrorBy:model];
                    }];
                }else {
                    [weakSelf showConnectErrorBy:model];
                }
            }];
        }
            break;
        default:
            break;
    }
}


//文件上传接入NSData
+ (NetworkTool *)uploadImage:(HttpWorkSuccess)success fail:(HttpWorkFail)fail withURLString:(NSString *)URLString parameters:(id)parameters uploadData:(NSData *)uploadData uploadName:(NSString *)uploadName{
    
    NetworkTool *instance = [NetworkTool sharedNetworkTool];
    
    NSArray *arr = [NSArray arrayWithObject:uploadData];
    [instance uploadImage:success fail:fail withURLString:URLString parameters:parameters uploadDatas:arr uploadName:uploadName];
    
    return instance;
    
}

//文件上传接入数组
+(NetworkTool *)uploadMostImage:(HttpWorkSuccess)success fail:(HttpWorkFail)fail withURLString:(NSString *)URLString parameters:(id)parameters uploadDatas:(NSArray *)uploadDatas uploadName:(NSString *)uploadName{
    
    NetworkTool *instance = [NetworkTool sharedNetworkTool];
    
    [instance uploadImage:success fail:fail withURLString:URLString parameters:parameters uploadDatas:uploadDatas uploadName:uploadName];
    return instance;
}

- (void)uploadImage:(HttpWorkSuccess)success fail:(HttpWorkFail)fail withURLString:(NSString *)URLString parameters:(id)parameters uploadDatas:(NSArray *)uploadDatas uploadName:(NSString *)uploadName
{
    __weak typeof(self) weakSelf = self;
    
    if (uploadDatas.count == 1) {
        
        [weakSelf POST:URLString parameters:parameters constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
            
            [formData appendPartWithFileData:uploadDatas[0] name:uploadName fileName:uploadName mimeType:@"image/png"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 获得的json先转换成字符串
            NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *JSONData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
            //再解析
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:nil];
            if (success) success(jsonDict, self);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (fail) fail(error, self);
            NSLog(@"httpFail %@", error);
        }];
    }else if(uploadDatas.count > 1){
        
        [weakSelf POST:URLString parameters:parameters constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
            for (int i=0; i < uploadDatas.count; i++) {
                NSString *imageName = [NSString stringWithFormat:@"%@[%i]", uploadName, i];
                [formData appendPartWithFileData:uploadDatas[i] name:uploadName fileName:imageName mimeType:@"image/png"];
            }
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 获得的json先转换成字符串
            NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *JSONData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
            //再解析
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:nil];
            if (success) success(jsonDict, self);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (fail) fail(error, self);
            NSLog(@"httpFail %@", error);
        }];
    }
}

//单调登录接口
-(void)httpCheckLogin:(HttpWorkSuccess) success fail:(HttpWorkFail)fail{
    
    __weak typeof(self) weakSelf = self;
    NSString *account  = NSUserDefRead(@"account");
    NSString *password = NSUserDefRead(@"password");
    
    
    NSString *encryptURL = [getBaseUrl() stringByAppendingString:@"/techcomp/security/saltkey.jsp"];
    
    NSLog(@"加密请求地址%@",encryptURL);
    
    [weakSelf POST:encryptURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString * encryptpassword  =  [Base64 encryptUseDES:password key:receiveStr];
        
        NSLog(@"%@",encryptpassword);
        
        //第一次获取session
        [weakSelf POST:getBaseUrl() parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            NSLog(@"cookie = %@",response.allHeaderFields[@"Set-Cookie"]);
            
            if (response.allHeaderFields[@"Set-Cookie"] == nil) {
                //成功之后检验session
                NSString *url = [getBaseUrl() stringByAppendingString:@"/j_spring_security_check"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
                [dict setValue:account forKey:@"j_username"];
                [dict setValue:encryptpassword forKey:@"j_password"];
                [dict setValue:@"iOS" forKey:@"sourceType"];
                
                NSLog(@"%@",dict);
                
                [weakSelf POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    if (success) success(responseObject, self );
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (fail) fail(error, self);
                    [weakSelf showConnectErrorBy:NULL];
                    return;
                }];
                
            }else {
                //设置session
                [self.requestSerializer setValue:response.allHeaderFields[@"Set-Cookie"] forHTTPHeaderField:@"Cookie"];
                //成功之后检验session
                NSString *url = [getBaseUrl() stringByAppendingString:@"/j_spring_security_check"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
                [dict setObject:account forKey:@"j_username"];
                [dict setObject:password forKey:@"j_password"];
                
                [weakSelf POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    if (success) success(responseObject, self );
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (fail) fail(error, self);
                    [weakSelf showConnectErrorBy:NULL];
                    return;
                }];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [weakSelf showConnectErrorBy:NULL];
            //或者返回重新登录
            return;
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf showConnectErrorBy:NULL];
        return ;
    }];
}

//接口获取成功但是status不为0的提示
//以下增加了一个model字段,用于判断财务审批接口调取的时候错误弹框不消失(model = check只适合财务审批用);
- (void)fixErrorCode:(NSInteger )code model:(NSString*)model message:(NSString *)error {
    
    if (code == 0) {
        return;
    }else if ([model isEqualToString:@"check"]) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:error message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        alert.delegate = self;
        [alert show];
        return;
    }else {
        [SVProgressHUD showErrorWithStatus:error];
    }
    
#ifdef DEBUG
    NSLog(@"\n错误方法 %@, \n 错误参数%@ , \n 错误代码%zd",self.method, self.args, code);
#endif
    
}

//无法连接网络的弹框提示
- (void)showConnectErrorBy:(NSString *)model {
    
    if ([model isEqualToString:@"/webservices/login"]) {
        [SVProgressHUD showErrorWithStatus:@"服务器配置有误，无法连接，请联系管理员"];
    }else {
        [SVProgressHUD showErrorWithStatus:@"无法连接网络！"];
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end






