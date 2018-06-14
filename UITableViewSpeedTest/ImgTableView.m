//
//  ImgTableView.m
//  UITableViewSpeedTest
//
//  Created by surio on 2018/6/13.
//  Copyright © 2018年 surio. All rights reserved.
//

#import "ImgTableView.h"
#import "ImgCell.h"
#import "ImgModel.h"

@implementation ImgTableView

#pragma - mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImgCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = _data[indexPath.row];
    return cell;
}
#pragma - mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImgModel *model = _data[indexPath.row];
    return model.height;
}

#pragma - mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    for (ImgCell *cell in self.visibleCells) {
        UIImageView *view = [cell valueForKey:@"_imgV"];
        if (!view.image) {
            [self reloadData];
            break;
        }
    }
    
}

@end
