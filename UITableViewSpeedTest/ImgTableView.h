//
//  ImgTableView.h
//  UITableViewSpeedTest
//
//  Created by surio on 2018/6/13.
//  Copyright © 2018年 surio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgTableView : UITableView <UITableViewDelegate ,UITableViewDataSource,UIScrollViewDelegate>

/**
 模型数组
 */
@property (nonatomic ,copy)NSArray *data;
@end
