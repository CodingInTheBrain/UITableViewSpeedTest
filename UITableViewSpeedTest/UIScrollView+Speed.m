
//  UIScrollView+Speed.m
//  NSCachTest
//
//  Created by surio on 2018/6/12.
//  Copyright © 2018年 surio. All rights reserved.
//

#import "UIScrollView+Speed.h"
#import <objc/runtime.h>

CGFloat UIScrollViewSpeedLow    = 1000.f;
CGFloat UIScrollViewSpeedNormal = 2000.f;
CGFloat UIScrollViewSpeedFast   = 3000.f;

@interface UIScrollView () <UIScrollViewDelegate>
/**
 记录最近一次滚动时的 NSDate
 */
@property (nonatomic ,strong)NSDate *lastDate;

/**
 记录最近一次滚动时的 contentOffset.y
 */
@property (nonatomic) CGFloat lastOffSetY;

@end

@implementation UIScrollView (Speed)

+ (void)load {
    static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                SEL originalSelectior   =   @selector(setDelegate:);
                SEL swizzledSelector    =   @selector(setPDelegate:);
                Class class = [self class];
                [class exchageSelctior:originalSelectior withSwizzledSelector:swizzledSelector withClass:class];
            });
}

- (void)setSpeed:(CGFloat)speed {
    
    objc_setAssociatedObject(self, @selector(speed), [NSNumber numberWithFloat:speed], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)speed {
    
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setLastDate:(NSDate *)lastDate {
    
    objc_setAssociatedObject(self, @selector(lastDate), lastDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)lastDate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLastOffSetY:(CGFloat)lastOffSetY {
    objc_setAssociatedObject(self, @selector(lastOffSetY), [NSNumber numberWithFloat:lastOffSetY], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lastOffSetY {
    
    return  [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setPDelegate:(id<UIScrollViewDelegate>)delegate {
    
    [self setPDelegate:delegate];
    Class delegateClass = [self.delegate class];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeScrollViewDidScrollMethod:delegateClass];
        [self exchageScrollViewDidEndDeceleratingMethod:delegateClass];
    });
    
}

- (void)exchangeScrollViewDidScrollMethod:(Class)class {
  
    SEL originalSelectior   =   @selector(scrollViewDidScroll:);
    SEL swizzledSelector    =   @selector(scrollViewDidScrollToSpeed:);
    [[self class] exchageSelctior:originalSelectior withSwizzledSelector:swizzledSelector withClass:class];
}

- (void)exchageScrollViewDidEndDeceleratingMethod:(Class)class {
    
    SEL originalSelectior   =   @selector(scrollViewDidEndDecelerating:);
    SEL swizzledSelector    =   @selector(scrollViewDidEndDeceleratingToSpeed:);
    [[self class] exchageSelctior:originalSelectior withSwizzledSelector:swizzledSelector withClass:class];
}

+ (void)exchageSelctior:(SEL)originalSelectior withSwizzledSelector:(SEL)swizzledSelector withClass:(Class)class {
    
    Method originalMethod   =   class_getInstanceMethod(class, originalSelectior);
    Method swizzleMethod    =   class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelectior, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}

#pragma - mark UIScrollViewDelegate

//避免当对象没有实现UIScollViewDelegate代理方法时，方法无法替换
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

//替换scrollViewDidScroll代理方法
- (void)scrollViewDidScrollToSpeed:(UIScrollView *)scrollView {
    
    CGFloat y = scrollView.contentOffset.y;
    NSDate *date = [NSDate date];
    NSTimeInterval timeBetween = [date timeIntervalSinceDate:self.lastDate];
    CGFloat speed = (y - self.lastOffSetY)/timeBetween;
    //取绝对值
    self.speed = fabs(speed);
    NSLog(@"speed: %f",self.speed);
    self.lastDate = date;
    self.lastOffSetY = y;
//    调用原有scrollViewDidScroll代理方法
    [self scrollViewDidScrollToSpeed:scrollView];
}

//避免当对象没有实现UIScollViewDelegate代理方法时，方法无法替换
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

//替换scrollViewDidEndDeceleratingToSpeed代理方法
- (void)scrollViewDidEndDeceleratingToSpeed:(UIScrollView *)scrollView {
    self.speed = 0.0;
    
//    调用原有scrollViewDidEndDecelerating方法
    [self scrollViewDidEndDeceleratingToSpeed:scrollView];
}




@end
