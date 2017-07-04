//
//  FirstViewController.m
//  获取通讯录
//
//  Created by 苗建浩 on 2017/7/3.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"
#import "Header.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"通讯录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((screenWidth - 100) / 2, NAVGATION_ADD_STATUS_HEIGHT + 50, 100, 50);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"跳转" forState:0];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)buttonClick:(UIButton *)sender{
    ViewController *viewVC = [[ViewController alloc] init];
    [self.navigationController pushViewController:viewVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
