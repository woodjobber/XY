//
//  ViewController.m
//  XY
//
//  Created by chengbin on 15/9/15.
//  Copyright (c) 2015年 chengbin. All rights reserved.
//

#import "ViewController.h"
#import "UIControl+XY.h"
#import "Radar.h"
#import "BMWaveButton.h"
#import "NSObject+XYJSonValidator.h"
#import <libCoreHelper/CoreHelper.h>
@interface ViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(120, 200, 100, 30);
    [button addTarget:self action:@selector(clickWithInterval:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    button.uxy_acceoptEventInterval = 1.5f;
    [button setTitle:@"click" forState:UIControlStateNormal];
    [self.view addSubview:button];
#if 0
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
  
    
    NSDictionary *json = @{
                           @"tag1": @"star",
                           @"tag2": @"jason",
                           @"totalNum": @(1616),
                           @"start_index": @"60",
                           @"return_number": @(30),
                           @"data" : @[@"1", @"2"],
                           @"tags" : [NSNull null],
                           @"config" : @{
                                   @"max_num" : @(30000),
                                   @"tag" : [NSNull null]
                                   }
                           };
    
    // Normal
    NSDictionary *configDic1 = [json objectForKey:@"config"];
    if (configDic1 != nil && [configDic1 isKindOfClass:[NSDictionary class]]) {
        id number = [configDic1 objectForKey:@"max_num"];
        if ([number isKindOfClass:[NSNumber class]] || [number isKindOfClass:[NSString class]]) {
            NSInteger maxNum = [number integerValue];
            NSLog(@"maxNum 1: %@", @(maxNum));
        }
    }
    
    // Or just this!
    
    NSInteger maxNum = [[json cy_dictionaryKey:@"config"] cy_integerKey:@"max_num"];
    NSLog(@"maxNum: %@", @(maxNum));
    // default value
    NSInteger minNum = [[json cy_dictionaryKey:@"config"] cy_integerKey:@"min_num" defaultValue:-1];
    NSLog(@"minNum: %@", @(minNum));
    
    // Handle NSNull
    NSArray *tags = [json cy_arrayKey:@"tags"];
    NSLog(@"%@", tags);
    
    // Handle wrong type
    NSString *string = [[json cy_dictionaryKey:@"data"] cy_stringKey:@"1"];
    NSLog(@"%@", string);
#endif
}


- (void)clickWithInterval:(UIButton *)sender{
    NSLog(@"%f",sender.uxy_acceoptEventInterval);
//    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    [self.webView loadRequest:request];
//    [self.view addSubview:self.webView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
