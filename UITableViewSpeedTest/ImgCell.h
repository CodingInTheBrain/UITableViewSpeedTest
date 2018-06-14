//
//  ImgCell.h
//  UITableViewSpeedTest
//
//  Created by surio on 2018/6/13.
//  Copyright © 2018年 surio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImgModel.h"
@interface ImgCell : UITableViewCell
@property (nonatomic, strong) ImgModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
