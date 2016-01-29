//
//  MainTabBarController.m
//  Mars
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@property (nonatomic,copy)NSArray *itemNames;
@property (nonatomic,copy)NSArray *itemNormalImageNames;
@property (nonatomic,copy)NSArray *itemSelectImageNames;

@end

@implementation MainTabBarController


- (void)_createTabBarButton {

    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }

    //加载tabbar黑色背景
    UIImageView *imav = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
    imav.image = [UIImage imageNamed:@"button_1.png"];
    
    [self.tabBar addSubview:imav];
    
    CGFloat itemHeight = CGRectGetHeight(self.tabBar.frame);
    CGFloat itemWidth = kScreenWidth / _itemNames.count;
    
    for (int i = 0; i < _itemNames.count; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * i, itemHeight - 10, itemWidth, 10)];
        
        label.text = _itemNames[i];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.tag = 200 + i;
        
        [self.tabBar addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, itemHeight)];
        
        UIImage *imageNormal = [UIImage imageNamed:_itemNormalImageNames[i]];
        
        [button setImage:imageNormal forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:_itemSelectImageNames[i]] forState:UIControlStateSelected];
        
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //这里用了点取巧的手段,把button放在label的前面,并且改动他的edgeinset,使button的image调整至合适位置
        //top, left, bottom, right
        CGFloat left = (itemWidth - 30) / 2;
        CGFloat trans = imageNormal.size.width / 30;
        CGFloat imageHeight = imageNormal.size.height / trans;
        CGFloat top = (itemHeight - 10 - imageHeight) / 2.0;

        top = top > 5 ? top : 5;
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(top, left, 10 + top, left)];

        [self.tabBar addSubview:button];
        
        //初始的button显示被选中状态
        if (button.tag == 100) {
            button.selected = YES;
            [label setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"button_1-_h.png"]]];
        }
        
    }


}

- (void)_createView {

    NSArray *arr = @[@"Home",@"Discover",@"Trends",@"News",@"My"];
    
    NSMutableArray *muArr = [NSMutableArray array];
    
    for (NSString *name in arr) {

        [muArr addObject:[[UIStoryboard storyboardWithName:name bundle:nil] instantiateInitialViewController]];
    }

    self.viewControllers = muArr;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    _itemNames = @[@"首页",@"发现",@"动态",@"消息",@"我的"];
    
    _itemNormalImageNames = @[@"tb_home_n", @"tb_found_n", @"tb_eye_n", @"tb_message_n", @"tb_mine_n"];
    
    _itemSelectImageNames = @[@"tb_home_h", @"tb_found_h", @"tb_eye_h", @"tb_message_h", @"tb_mine_h"];
    
    [self _createView];
    
    [self _createTabBarButton];
    
    
}


#pragma mark - buttonAction 

- (void)buttonAction:(UIButton *)button {

    self.selectedIndex = button.tag - 100;

    for (int i = 100; i < 105; i++) {
        if (button.tag != i) {

            ((UIButton *)[button.superview viewWithTag:i]).selected = NO;
            ((UILabel *)[button.superview viewWithTag:i + 100]).textColor = [UIColor whiteColor];
            
        }
        else {
         
            button.selected = YES;
            ((UILabel *)[button.superview viewWithTag:i + 100]).textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_1-_h.png"]];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
