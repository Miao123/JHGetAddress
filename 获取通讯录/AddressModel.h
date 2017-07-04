//
//  AddressModel.h
//  获取通讯录
//
//  Created by 苗建浩 on 2017/7/3.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic, assign) NSInteger sectionNumber;
@property (nonatomic, assign) NSInteger recordID;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, strong) NSMutableArray *addressBookArray;

@end
