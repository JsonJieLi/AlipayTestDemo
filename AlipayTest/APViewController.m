//
//  APViewController.m
//  AliSDKDemo
//
//  Created by 方彬 on 11/29/13.
//  Copyright (c) 2013 Alipay.com. All rights reserved.
//

#import "APViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SuccessViewController.h"



@interface APViewController ()



@end

@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
	[self generateData];
  


}


#pragma mark -
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
	static int kNumber = 15;
	
	NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *resultStr = [[NSMutableString alloc] init];
	srand((unsigned)time(0));
	for (int i = 0; i < kNumber; i++)
	{
		unsigned index = rand() % [sourceStr length];
		NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
		[resultStr appendString:oneStr];
	}
	return resultStr;
}



#pragma mark -
#pragma mark   ==============产生订单信息==============

- (void)generateData{
    

		
    UILabel * subjectLabel = [[UILabel alloc]init];
    subjectLabel.frame = CGRectMake(20, 50,300, 100);
    subjectLabel.textColor = [UIColor redColor];
    subjectLabel.font =[UIFont systemFontOfSize:15];

    subjectLabel.text = [NSString stringWithFormat:@"购买商品：%@",self.subject];

    [self.view addSubview:subjectLabel];
    
    UILabel * bodyLabel = [[UILabel alloc]init];
    bodyLabel.frame = CGRectMake(20, 100,300, 100);
    bodyLabel.textColor = [UIColor redColor];
    bodyLabel.text = [NSString stringWithFormat:@"商品简介：%@",self.body];
    bodyLabel.font =[UIFont systemFontOfSize:15];
    [self.view addSubview:bodyLabel];
    
    UILabel * priceLabel = [[UILabel alloc]init];
    priceLabel.frame = CGRectMake(20, 150,300, 100);
    priceLabel.textColor = [UIColor redColor];
    priceLabel.text =[NSString stringWithFormat:@"价格：%.2f",self.price];
    priceLabel.font =[UIFont systemFontOfSize:15];

    [self.view addSubview:priceLabel];
	
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 300, 300, 100);
    [button setTitle:@"支付" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //点击支付
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}










#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)btnClick
{

	
	/*
	 *商户的唯一的parnter和seller。
	 *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
	 */
    
/*============================================================================*/
/*=======================需要填写商户app申请的===================================*/
/*============================================================================*/
	NSString *partner = @"订单号";
    NSString *seller = @"账号";
    NSString *privateKey =@"秘钥";
/*============================================================================*/
/*============================================================================*/
/*============================================================================*/
	
	//partner和seller获取失败,提示
	if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少partner或者seller或者私钥。"
													   delegate:self
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
     
		return;
	}
	
	/*
	 *生成订单信息及签名
	 */
	//将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
	order.partner = partner;
	order.sellerID = seller;
	order.outTradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.subject = self.subject; //商品标题
	order.body = self.body; //商品描述
	order.totalFee = [NSString stringWithFormat:@"%.2f",self.price]; //商品价格
	order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
	NSString *appScheme = @"AlipayTest";
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner(privateKey);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
  
}



@end
