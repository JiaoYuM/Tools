//
//  GetAddressBook.m
//  CashLoan
//
//  Created by jiaoyu on 2017/5/23.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import "GetAddressBook.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
@implementation GetAddressBook
+(void)getAddressBookInfoSuccess:(ReturnAddressBookBlock)returnBlock failureBlock:(RejectBlock)rejectBlock{
    NSMutableArray *addressBookArray = [NSMutableArray array];
    if ([SystemVersion floatValue] < 9.0) {
        // 1.获取授权状态
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        // 2.判断授权状态
        if (status == kABAuthorizationStatusNotDetermined || status == kABAuthorizationStatusAuthorized) {
            // 3.请求授权
            // 3.1.创建通信录对象
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            // 3.2.请求授权
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) { // 当用户决定是否授权的时候会执行该block
                    
                    if (granted) { // 授权成功
                        // 2.获取联系人
                        // 2.1.创建通信录对象
                        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                        
                        // 2.2.获取所有的联系人
                        CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
                        
                        // 2.3.遍历所有的联系人
                        CFIndex peopleCount = CFArrayGetCount(peopleArray);
                        for (int i = 0; i < peopleCount; i++) {
                            
                            // 3.获取一条记录
                            ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
                            
                            // 3.1.获取联系人的姓名
                            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);//名字
                            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);//姓氏
                            NSString *holeName = [NSString stringWithFormat:@"%@%@",lastName,firstName];
                            NSLog(@"firstName = %@ lastName = %@", firstName, lastName);
                            
                            // 3.2.获取电话号码
                            // 3.2.1.获取所有的电话
                            ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
                            // 3.3.2.遍历所有的电话号码
                            CFIndex phoneCount = ABMultiValueGetCount(phones);
                            NSMutableArray *phoneNumArray = [NSMutableArray array];
                            for (int i = 0; i < phoneCount; i++) {
                                NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
                                [phoneNumArray addObject:phoneValue];
                                NSLog(@"phoneValue = %@", phoneValue);
                            }
                            NSMutableDictionary *addressDic = [NSMutableDictionary dictionary];
                            [addressDic setValue:holeName forKey:@"name"];
                            [addressDic setValue:phoneNumArray forKey:@"phoneNumber"];
                            [addressBookArray addObject:addressDic];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"addressBookArray = %@",addressBookArray);
                            returnBlock(addressBookArray);                            
                        });
                    } else { // 授权失败
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"不可以访问通信录");
                            NSString *message = @"不可以访问通信录";
                            rejectBlock(message);
                        });
                    }
                });
                // 3.3.释放不再使用的对象
                CFRelease(addressBook);
            });
        }
    }else{
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined || [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CNContactStore *store = [[CNContactStore alloc] init];
                [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        NSLog(@"授权成功");
                        // 2. 获取联系人仓库
                        CNContactStore * store = [[CNContactStore alloc] init];
                        // 3. 创建联系人信息的请求对象
                        NSArray * keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
                        // 4. 根据请求Key, 创建请求对象
                        CNContactFetchRequest * request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
                        // 5. 发送请求
                        [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                            // 6.1 获取姓名
                            NSString * givenName = contact.givenName;
                            NSString * familyName = contact.familyName;
                            NSString *holeName = [NSString stringWithFormat:@"%@%@",familyName,givenName];
                            NSLog(@"%@%@", familyName, givenName);
                            // 6.2 获取电话
                            NSArray * phoneArray = contact.phoneNumbers;
                            NSMutableArray *phoneNumArray = [NSMutableArray array];
                            for (CNLabeledValue * labelValue in phoneArray) {
                                CNPhoneNumber * number = labelValue.value;
                                NSLog(@"%@", number.stringValue);
                                [phoneNumArray addObject:number.stringValue];
                            }
                            NSMutableDictionary *addressDic = [NSMutableDictionary dictionary];
                            [addressDic setValue:holeName forKey:@"name"];
                            [addressDic setValue:phoneNumArray forKey:@"phoneNumber"];
                            [addressBookArray addObject:addressDic];
                        }];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            returnBlock(addressBookArray);
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"授权失败");
                            NSString *message = @"不可以访问通信录";
                            rejectBlock(message);
                        });
                    }
                    
                }];
            });
        }
        
    }
}



@end
