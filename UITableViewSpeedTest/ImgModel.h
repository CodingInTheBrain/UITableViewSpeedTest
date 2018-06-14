//
//  ImgModel.h
//  UITableViewSpeedTest
//
//  Created by surio on 2018/6/13.
//  Copyright © 2018年 surio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImgModel : NSObject

/**
 图片 URl地址
 */
@property (nonatomic ,copy) NSString *imgUrl;

/**
 ImgCell高度
 */
@property (nonatomic)       CGFloat height;


/**
 高度是否为非默认高度
 */
@property (nonatomic)       BOOL isRegisterHeight;

/**
 初始化模型
 
 @param dic 模型字典
 @return 返回模型对象
 */
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
