//
//  BizareaInfoController.m
//  Mars
//
//  Created by Macx on 16/2/21.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "BizareaInfoController.h"
#import "BizareaModel.h"
#import "BizareaInfoAllTableView.h"
#import "BizareaInfoOneTableView.h"

@interface BizareaInfoController ()
@property (nonatomic,strong)UIImageView *headViewOne;
@end

@implementation BizareaInfoController

- (void)setIndexSelect:(NSInteger)indexSelect {
    if (_indexSelect != indexSelect) {
        _indexSelect = indexSelect;
    
        if (_headViewOne == nil) {
            
            _headViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
            _headViewOne.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_1-_h.png"]];
            
            _headViewOne.tag = 11;
            
            [self.view addSubview:_headViewOne];
            UIView *grayView = [[UIView alloc] initWithFrame:_headViewOne.bounds];
            
            grayView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
            
            [_headViewOne addSubview:grayView];
            
        }
        
        if (_indexSelect == 7 || _indexSelect == 6) {
            [self _createAllTableView];
        }
        else {
            [self _createOneTableView];
        }
    
    }
}

- (void)_createOneTableView {
    
    [_headViewOne sd_setImageWithURL:[NSURL URLWithString:_bizareaModel.storesHeadpic[_indexSelect - 1]]];

    UIImageView *scoreView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 80 - 10, 10, 80, 20)];
    
    [self.view addSubview:scoreView];
    
    NSInteger score = [_bizareaModel.storesScore[_indexSelect - 1] integerValue];
    
    score = score > 5 ? 5 : score;
    scoreView.hidden = YES;
    if (score > 0) {
        scoreView.hidden = NO;
        scoreView.image = [UIImage imageNamed:[NSString stringWithFormat:@"score_%ld",score]];
    }
    
    
    BizareaInfoOneTableView *table = [[BizareaInfoOneTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];

    [self.view addSubview:table];
    
    table.indexSelect = _indexSelect;
    table.model = _bizareaModel;
}

- (void)_createAllTableView {
    
    [_headViewOne sd_setImageWithURL:[NSURL URLWithString:_bizareaModel.headPic]];
    
    BizareaInfoAllTableView *table = [[BizareaInfoAllTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    
    [self.view addSubview:table];
    
    table.indexSelect = _indexSelect;
    table.model = _bizareaModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"在bizareainfocontroller界面中遇到一个问题,导航栏和tabbar都为(null)%@%@",self.navigationController.navigationBar,self.tabBarController.tabBar);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_1-_h.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
