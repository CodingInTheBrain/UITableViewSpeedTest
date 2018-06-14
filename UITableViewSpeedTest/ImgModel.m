//
//  ImgModel.m
//  UITableViewSpeedTest
//
//  Created by surio on 2018/6/13.
//  Copyright © 2018年 surio. All rights reserved.
//

#import "ImgModel.h"

@implementation ImgModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        _imgUrl = [dic valueForKey:@"imgUrl"];
        _height = 200;
    }
    return self;
}

@end
