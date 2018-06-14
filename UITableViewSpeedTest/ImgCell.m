//
//  ImgCell.m
//  UITableViewSpeedTest
//
//  Created by surio on 2018/6/13.
//  Copyright © 2018年 surio. All rights reserved.
//

#import "ImgCell.h"
#import "UIScrollView+Speed.h"
#import "ImgCacheManage.h"
#import "ImgTableView.h"

#define ScreenHeight    [UIScreen mainScreen].bounds.size.height
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width

#define safeOnMain(block)       \
if ([NSThread isMainThread]) {  \
    block();                    \
} else {                        \
    dispatch_async(dispatch_get_main_queue(), block);\
}

@interface ImgCell()
{
    __weak IBOutlet UIImageView *_imgV;
}
@end

@implementation ImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(ImgModel *)model {
    _model = model;
    
    _imgV.image = nil;
    ImgTableView *tableView = [self getTableView];

    ImgCacheManage *manage = [ImgCacheManage shareManage];
    UIImage *img = [manage cacheForUrl:_model.imgUrl];
    NSIndexPath *path = [NSIndexPath indexPathForRow:_indexPath.row inSection:_indexPath.section];
    if (img) {
        _imgV.image = img;
    } else {
     
        NSString *url = _model.imgUrl;
        if ([tableView.indexPathsForVisibleRows containsObject:path] && tableView.speed < UIScrollViewSpeedFast ) {
            [manage diskForUrl:url complete:^(UIImage *img) {
                    if (img) {
                        img = [self reDrawImg:img];
                        NSUInteger cost = img.size.width * img.size.height * 4;
                        
                        [manage cacheWithObject:img With:url cost:cost];
                        ImgModel *model = tableView.data[path.row];
                        model.height = img.size.height;
                        if ([tableView.indexPathsForVisibleRows containsObject:path] && tableView.speed < UIScrollViewSpeedFast) {
                            safeOnMain(^{
                                if (_model.isRegisterHeight) {
                                    _imgV.image = img;

                                } else {
                                    _model.isRegisterHeight = YES;
                                    [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
                                }
                                
                            });
                        }
                    }
                }];
            }
    }
    
}

- (UIImage *)reDrawImg:(UIImage *)img {
    
    CGFloat hfactor = img.size.height / ScreenHeight;
    CGFloat wfactor = img.size.width / ScreenWidth;
    CGFloat factor  =  hfactor > wfactor ? hfactor : wfactor;
    
    CGFloat newWidth    = img.size.width / factor;
    CGFloat newHeight   = img.size.height / factor;
    CGSize  newSize     = CGSizeMake(newWidth, newHeight);
    
    UIGraphicsBeginImageContext(newSize);
    [img drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    img = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, 1)];
    return img;
}

- (ImgTableView *)getTableView {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[ImgTableView class]]) {
            return (ImgTableView *)responder;
        }
    }
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
