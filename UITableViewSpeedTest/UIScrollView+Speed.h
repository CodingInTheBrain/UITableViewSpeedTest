//
//  UIScrollView+Speed.h
//  NSCachTest
//
//  Created by surio on 2018/6/12.
//  Copyright © 2018年 surio. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat UIScrollViewSpeedLow;
UIKIT_EXTERN CGFloat UIScrollViewSpeedNormal;
UIKIT_EXTERN CGFloat UIScrollViewSpeedFast;

@interface UIScrollView (Speed)
/**
 用于描述ScrollView的滑动速度 单位 px/s
 */
@property (nonatomic ,readonly) CGFloat speed;

@end
