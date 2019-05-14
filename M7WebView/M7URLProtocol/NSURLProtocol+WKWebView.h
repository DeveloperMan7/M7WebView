//
//  NSURLProtocol+WKWebView.h
//  Pkit
//
//  Created by DevMan7 on 2019/9/7.
//  Copyright © 2018年 llyouss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLProtocol (WKWebView)

+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;

@end
