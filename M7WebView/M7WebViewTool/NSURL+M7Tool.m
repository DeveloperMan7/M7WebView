//
//  NSURL+M7Tool.m
//  Pkit
//
//  Created by DevMan7 on 2017/12/22.
//  Copyright © 2017年 llyouss. All rights reserved.
//

#import "NSURL+M7Tool.h"
#import <UIKit/UIKit.h>
#import "UIAlertController+WKWebAlert.h"
#import "registerURLSchemes.h"

#define IOS10BWK [[UIDevice currentDevice].systemVersion floatValue] >= 10
#define IOS9BWK [[UIDevice currentDevice].systemVersion floatValue] >= 9

@implementation NSURL (M7Tool)

+ (NSURL *)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:params];
    NSMutableArray* pairs = [NSMutableArray array];
    
    for (NSString* key in param.keyEnumerator) {
        NSString *value = [NSString stringWithFormat:@"%@",[param objectForKey:key]];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    
    NSString *query = [pairs componentsJoinedByString:@"&"];
    
#ifdef IOS9BWK
    
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet];
    baseURL  = [baseURL stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    
#else
    
    baseURL = [baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
#endif
    
    NSString* url = @"";
    if ([baseURL containsString:@"?"]) {
        url = [NSString stringWithFormat:@"%@&%@",baseURL, query];
    }
    else {
        url = [NSString stringWithFormat:@"%@?%@",baseURL, query];
    }
    
    return [NSURL URLWithString:url];
}

+ (void)openURL:(NSURL *)URL
{
    __weak typeof(self)weekSelf = self;
    if ([URL.host.lowercaseString isEqualToString:@"itunes.apple.com"] ||
        [URL.host.lowercaseString isEqualToString:@"itunesconnect.apple.com"]) {
        
        [UIAlertController M7lertWithTitle:[NSString stringWithFormat:@"即将打开Appstore下载应用"] message:@"如果不是本人操作，请取消" action1Title:@"取消" action2Title:@"打开" action1:^{
   
        } action2:^{
            
           [weekSelf safariOpenURL:URL];
        }];
    }else{
        
        //获取应用名字
        NSDictionary *urlschemes = [registerURLSchemes urlschemes];
        NSDictionary *appInfo = [urlschemes objectForKey:URL.scheme];
        NSString *name =[appInfo objectForKey:@"name"];

        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            
            if(!name) name = URL.scheme;
            [UIAlertController M7lertWithTitle:[NSString stringWithFormat:@"即将打开%@",name] message:@"如果不是本人操作，请取消" action1Title:@"取消" action2Title:@"打开" action1:^{
                
            } action2:^{
                
                [weekSelf safariOpenURL:URL];
            }];
            
        }else{
            
            if (!appInfo) return;
            NSString *urlString = [appInfo objectForKey:@"url"];
            if (!urlString) return;
            NSURL *appstoreURL = [NSURL URLWithString:urlString];
            [UIAlertController M7lertWithTitle:[NSString stringWithFormat:@"前往Appstore下载"] message:@"你还没安装该应用，是否前往Appstore下载？" action1Title:@"取消" action2Title:@"去下载" action1:^{
    
            } action2:^{
                
                [weekSelf safariOpenURL:appstoreURL];
            }];
        }
    }
}

+ (void)safariOpenURL:(NSURL *)URL
{
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success)
         {
             if (!success) {
                 [UIAlertController M7lertWithTitle:@"提示" message:@"打开失败" completion:nil];
             }
         }];
    } else {
        
        if (![[UIApplication sharedApplication] canOpenURL:URL]) {
            [UIAlertController M7lertWithTitle:@"提示" message:@"打开失败" completion:nil];
        }
    }
}

@end
