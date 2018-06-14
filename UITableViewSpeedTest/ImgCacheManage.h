//
//  ImgCacheManage.h
//  UITableViewSpeedTest
//
//  Created by surio on 2018/6/13.
//  Copyright © 2018年 surio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeBlock)(UIImage *img);

@interface ImgCacheManage : NSObject

+ (instancetype)shareManage;

- (UIImage *)cacheForUrl:(NSString *)imgUrl;
- (void)cacheWithObject:(id)objc With:(NSString *)imgUrl cost:(NSUInteger)cost;
- (void)diskForUrl:(NSString *)imgUrl complete:(completeBlock)complete;
@end
