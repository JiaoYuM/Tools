//
//  GetAddressBook.h
//  CashLoan
//
//  Created by jiaoyu on 2017/5/23.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 **
 *返回的通讯录数据的block
 */
typedef void(^ReturnAddressBookBlock) (id returnValue);
typedef void(^RejectBlock) (NSString *rejectMessage);
@interface GetAddressBook : NSObject
+(void)getAddressBookInfoSuccess:(ReturnAddressBookBlock)returnBlock failureBlock:(RejectBlock)rejectBlock;

@end
