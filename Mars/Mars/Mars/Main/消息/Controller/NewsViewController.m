//
//  NewsViewController.m
//  Mars
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "NewsViewController.h"
#import "MJRefresh.h"

@interface NewsViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MJRefreshGifHeader *mjHeader;
@property (nonatomic,assign)CGFloat durition;
@property (nonatomic,assign)CGFloat actionHaveBeenTime;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    grayView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
    
    [self.view addSubview:grayView];
    
    UIImageView *empty = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 180) / 2.0, (kScreenHeight - 180 - 49 - 64) / 2.0, 180, 180)];
    empty.image = [UIImage imageNamed:@"empty"];
    
    [self.view addSubview:empty];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, empty.width, 30)];
    
    label.left = empty.left;
    label.top = empty.bottom + 10;
    
    label.text = @"暂时没有消息";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    
    
    [self _createTableView];
    
    _durition = _actionHaveBeenTime = 0;
}

- (void)_createTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.tabBarController.tabBar.height)];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
    
    _mjHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(delayEnd)];
    
    _tableView.mj_header = _mjHeader;
    
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 0; i < 23; i++) {
        [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh%d",i]]];
    }
    
    [_mjHeader setImages:imageArr forState:MJRefreshStateRefreshing];

    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];

}

#pragma mark - action 
- (void)delayEnd {

    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    _actionHaveBeenTime = 0;
    _durition = arc4random() % 4 / 10.0 + arc4random() % 4 ;

}

- (void)timerAction:(NSTimer *)timer {
    NSLog(@"%f,%f",_durition,_actionHaveBeenTime);
    if (_durition == _actionHaveBeenTime) {
        [timer invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mjHeader endRefreshing];
        });
    }
    _actionHaveBeenTime += 0.1;

}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


