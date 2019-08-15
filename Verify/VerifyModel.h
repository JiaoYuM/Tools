//
//  VerifyModel.h
//  ZhaoHuC
//
//  Created by MacPro on 2018/5/23.
//  Copyright © 2018年 Viewhigh. All rights reserved.
//

#import <Foundation/Foundation.h>
/*[\u4e00-\u9fa5] //匹配中文字符
 
 正常中文名"^[\u4e00-\u9fa5]+$"
 带点{•|·}的中文名"^[\u4e00-\u9fa5]+[·•][\u4e00-\u9fa5]+$"
 ^[1-9]\d*$    //匹配正整数
 ^[A-Za-z]+$   //匹配由26个英文字母组成的字符串
 ^[A-Z]+$      //匹配由26个英文字母的大写组成的字符串
 ^[a-z]+$      //匹配由26个英文字母的小写组成的字符串
 ^[A-Za-z0-9]+$ //匹配由数字和26个英文字母组成的字符串
 */
@interface VerifyModel : NSObject

///身份证的校验
+ (BOOL)isCorrect:(NSString *)IDNumber ;
//手机号的校验
+ (BOOL) isVaildMobileNo:(NSString *)mobileNo;
/**
 判断是否是有效的中文名
 
 @param realName 名字
 @return 如果是在如下规则下符合的中文名则返回`YES`，否则返回`NO`
 限制规则： 
 1. 首先是名字要大于两个汉字
 2. 如果是中间带`{•|·}`的名字，则限制长度15位（新疆人的名字有15位左右的），如果有更长的，请自行修改长度限制
 3. 如果是不带小点的正常名字，限制长度为8位，若果觉得不适，请自行修改位数限制
 *PS: `•`或`·`具体是那个点具体处理需要注意*
 */
+ (BOOL)isVaildRealName:(NSString *)realName;
///密码格式的判断
+ (BOOL)isVaildRealPassWord:(NSString *)passWord;
/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+(NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2;
@end
