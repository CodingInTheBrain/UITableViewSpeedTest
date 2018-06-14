//
//  ViewController.m
//  UITableViewSpeedTest
//
//  Created by surio on 2018/6/13.
//  Copyright © 2018年 surio. All rights reserved.
//

#import "ViewController.h"
#import "ImgTableView.h"
#import "ImgModel.h"
@interface ViewController ()
{
    __weak IBOutlet ImgTableView *_tableView;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    
}

- (void)initViews {
    _tableView.delegate     =   _tableView;
    _tableView.dataSource   =   _tableView;

    [_tableView registerNib:[UINib nibWithNibName:@"ImgCell" bundle:nil] forCellReuseIdentifier:@"ImgCell"];
    _tableView.data = [self loadData];


}

- (NSArray *)loadData {
    
    NSString *path = [[NSBundle mainBundle] resourcePath];
    NSString *imgPath = [path stringByAppendingPathComponent:@"TestImg"];
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 1; i<= 8; i++) {
        NSString *string = [NSString stringWithFormat:@"%@/%03d.jpeg",imgPath,i];
        ImgModel *model = [[ImgModel alloc] initWithDic:@{@"imgUrl":string}];
        [data addObject:model];
    }
    NSArray *arr = [NSArray arrayWithArray:data];

    return arr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
