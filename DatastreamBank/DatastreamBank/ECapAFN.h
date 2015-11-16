//
//  ECapAFN.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECapAFN : NSObject

//post请求只返回成功的，网络异常用自定义的处理
+(void)PostUrl:(NSString *)url
        method:(NSString *)method
    parameters:(id)parameters
       success:(void (^)(id parameters, id responseObject))success;

//post请求返回成功失败
+(void)PostUrl:(NSString *)url
        method:(NSString *)method
    parameters:(id)parameters
       success:(void (^)(id parameters, id responseObject))success
       failure:(void (^)(id parameters, NSError *error))failure;

//post请求，只是记录，不返回任何成功失败消息
+(void)PostUrl:(NSString *)url
     method:(NSString *)method
    parameters:(id)parameters;

@end
