//
//  ECapAFN.m
//  DatastreamBank
//   对于AFN简单的封装
//  Created by OsnDroid on 15/11/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "ECapAFN.h"
#import "AFHTTPRequestOperationManager.h"

@implementation ECapAFN


+(void)PostUrl:(NSString *)url
        method:(NSString *)method
    parameters:(id)parameters
       success:(void (^)(id parameters, id responseObject))success {
    
    [self PostUrl:url method:method parameters:parameters success:^(id parameters, id responseObject) {
        success(parameters,responseObject);
    } failure:^(id parameters, NSError *error) {
        
    }];
}


+(void)PostUrl:(NSString *)url
        method:(NSString *)method
    parameters:(id)parameters
       success:(void (^)(id parameters, id responseObject))success
       failure:(void (^)(id parameters, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[url stringByAppendingString:method] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(parameters,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(parameters,error);
    }];

}

+(void)PostUrl:(NSString *)url
        method:(NSString *)method
    parameters:(id)parameters {


}
@end
