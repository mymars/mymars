//
//  MyViewController.m
//  Mars
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "MyViewController.h"
#import "UIView+ext.h"
#import "MyHeadView.h"
#import "ImageCell.h"
#import "LabelCell.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (assign, nonatomic) CGFloat offsetY;
@property (strong, nonatomic) MyHeadView *headView;

@end

@implementation MyViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _nameLabel.hidden = YES;
    [_nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
    
    _bgView.hidden = YES;
    _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTable.backgroundColor = [UIColor clearColor];
    UINib *imageNib = [UINib nibWithNibName:@"ImageCell" bundle:[NSBundle mainBundle]];
    [_myTable registerNib:imageNib forCellReuseIdentifier:@"ImageCell"];
    
    UINib *labelNib = [UINib nibWithNibName:@"LabelCell" bundle:[NSBundle mainBundle]];
    [_myTable registerNib:labelNib forCellReuseIdentifier:@"LabelCell"];
    
    _offsetY = 0.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    
    for (UIView *view in self.view.subviews) {
        if ([view isMemberOfClass:[BottomGrayView class]]) {
            [view removeFromSuperview];
        }

    }

}

- (IBAction)settingAction:(UIButton *)sender {
}


#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0)
    {
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
        cell = [cell initWithImage:@"place_icon" tyName:@"Place"];
        return cell;
    }
    else if (indexPath.row == 1)
    {
        LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
        cell = [cell initWithLabelName:@"我评价的地点"];
        return cell;
    }
    else if (indexPath.row == 2)
    {
        LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
        cell = [cell initWithLabelName:@"我关注的地点"];
        return cell;
    }
    else if (indexPath.row == 3)
    {
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
        cell = [cell initWithImage:@"area_icon" tyName:@"Area"];
        return cell;
    }
    else if (indexPath.row == 4)
    {
        LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
        cell = [cell initWithLabelName:@"我关注的商圈"];
        return cell;
    }
    else if (indexPath.row == 5)
    {
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
        cell = [cell initWithImage:@"feature_icon" tyName:@"Feature"];
        return cell;
    }
    else if (indexPath.row == 6)
    {
        LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
        cell = [cell initWithLabelName:@"我关注的专题"];
        return cell;
    }
    else if (indexPath.row == 7)
    {
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
        cell = [cell initWithImage:@"line_icon" tyName:@"Line"];
        return cell;
    }
    else if (indexPath.row == 8)
    {
        LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
        cell = [cell initWithLabelName:@"我关注的线路"];
        return cell;
    }
    else if (indexPath.row == 9)
    {
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
        cell = [cell initWithImage:@"people_icon" tyName:@"People"];
        return cell;
    }
    else
    {
        LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
        cell = [cell initWithLabelName:@"我关注的人"];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headView = [[MyHeadView alloc] initWithAvatar:@"moren_head" name:@"好人一生平安"];
    return _headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([UIScreen mainScreen].bounds.size.height - 69)/11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 234;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat lastOffsetY = scrollView.contentOffset.y;
    
    CGFloat distance = _headView.bgImageView.bottom - _navView.bottom;
    
    if (lastOffsetY > _offsetY)
    {
        //向上滚动
        if (lastOffsetY >= distance)
        {
            _nameLabel.hidden = NO;
            _bgView.hidden = NO;
        }
        
    }
    else
    {
        //向下滚动
        if (lastOffsetY <= distance)
        {
            _nameLabel.hidden = YES;
            _bgView.hidden = YES;
        }
    }
    
    _offsetY = lastOffsetY;
    
    
    UIImageView *userHeadpicImage = [_headView viewWithTag:666];
    if (scrollView.contentOffset.y > 0) {
        
        NSLog(@"%f",scrollView.contentOffset.y);
        CGFloat scale = 20 / ((scrollView.contentOffset.y * 1) + 20);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            userHeadpicImage.transform = CGAffineTransformMakeScale(scale, scale);
        });
    }
    else  {
        dispatch_async(dispatch_get_main_queue(), ^{
            userHeadpicImage.transform = CGAffineTransformIdentity;
        });
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中单元格事件
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
