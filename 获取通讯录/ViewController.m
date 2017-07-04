//
//  ViewController.m
//  获取通讯录
//
//  Created by 苗建浩 on 2017/7/3.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddressModel.h"
#import "Header.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *addressTable;
@property (nonatomic, strong) NSMutableArray *addressArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"通讯录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.addressArr = [NSMutableArray array];
    [self addressInterface];
    
}

- (void)addressInterface{
    
    //  新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
        
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    
    
    //  获取通讯录里面所有的人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    //  通讯录中人数
    CFIndex numberPeople = ABAddressBookGetPersonCount(addressBooks);
    
    for (int i = 0; i < numberPeople; i++) {
        //  创建通讯录model
        AddressModel *dataModel = [[AddressModel alloc] init];
        //  获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //  获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABGroupNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        }else{
            if ((__bridge id)abLastName != nil) {
                nameString = [NSString stringWithFormat:@"%@  %@",nameString, lastNameString];
            }
        }
        dataModel.name = nameString;
        dataModel.recordID = (int)ABRecordGetRecordID(person);
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //  获取电话号码和邮箱
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyLabelAtIndex(valuesRef, k);
                
                switch (j) {
                    case 0:{//  电话
                        dataModel.tel = (__bridge NSString *)value;
                        break;
                    }
                        
                    case 1:{//  邮箱
                        dataModel.email = (__bridge NSString *)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        //  将个人信息添加到数组中
        [self.addressArr addObject:dataModel];
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    UITableView *addressTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVGATION_ADD_STATUS_HEIGHT, screenWidth, screenHight) style:UITableViewStylePlain];
    addressTable.delegate = self;
    addressTable.dataSource = self;
    addressTable.tableFooterView = [[UIView alloc] init];
    self.addressTable = addressTable;
    [self.view addSubview:addressTable];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _addressArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45 * DISTENCEH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    AddressModel *dataModel = _addressArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dataModel.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",dataModel.tel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressModel *dataModel = _addressArr[indexPath.row];
    NSLog(@"名字 %@",dataModel.name);
    
    /*
     // 拨打电话
     NSString *tel = [NSString stringWithFormat:@"%@",dataModel.tel];
     
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[NSNumber numberWithInteger:[tel intValue]]]]];
     
     // 给对应号码发短信
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",[NSNumber numberWithInteger:[tel intValue]]]]];
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
