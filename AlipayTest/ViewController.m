//
//  ViewController.m
//  AlipayTest
//
//  Created by xiaohaijian on 16/5/11.
//  Copyright © 2016年 xiaohaijian. All rights reserved.
//

#import "ViewController.h"
#import "APViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:@"前往支付" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)btnClick{
    

    APViewController * apV = [[APViewController alloc]init];
    
    apV.subject = @"这是我选择的商品";
    apV.body = @"这是我选择的商品";
    apV.price = 0.01;
    
    [self.navigationController pushViewController:apV animated:YES];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
