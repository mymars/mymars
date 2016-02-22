//
//  BizareaInfoAllTableView.m
//  Mars
//
//  Created by Macx on 16/2/21.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "BizareaInfoAllTableView.h"
#import "BizareaModel.h"
#import "ChangingHeightLabel.h"
#import "BizareaInfoAllStoreView.h"

static NSString *bizareaInfoAllIndentifier = @"bizareaInfoAllIndentifier";


@interface BizareaInfoAllTableView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign)BOOL isClick;
@end

@implementation BizareaInfoAllTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:bizareaInfoAllIndentifier];
        
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}

- (void)setModel:(BizareaModel *)model {
    
    if (_model != model) {
        _model = model;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    }
    
}

- (void)_createIndexPath0WithView:(UIView *)superView {

    for (UIView *view in superView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *english = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 40)];
    
    english.text = _model.englishName;
    english.textAlignment = NSTextAlignmentCenter;
    english.font = [UIFont boldSystemFontOfSize:37];
    english.textColor = [UIColor whiteColor];
    
    [superView addSubview:english];
    
    UILabel *chinese = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, kScreenWidth, 30)];
    
    chinese.text = _model.name;
    chinese.textAlignment = NSTextAlignmentCenter;
    chinese.textColor = [UIColor whiteColor];
    chinese.font = [UIFont systemFontOfSize:25];
    
    [superView addSubview:chinese];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, kScreenWidth, superView.height - 130)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    [superView addSubview:whiteView];

    ChangingHeightLabel *desc = [[ChangingHeightLabel alloc] initWithFrame:CGRectMake(0, 130, kScreenWidth, 65) withString:_model.placeDesc withFlag:_isClick withSuperView:superView];
}

- (void)_createIndexPath1WithView:(UIView *)superView withIndexPath:(NSInteger)indexPathRow{
    for (UIView *view in superView.subviews) {
        [view removeFromSuperview];
    }
    
    
    BizareaInfoAllStoreView * allStoreView =  [[NSBundle mainBundle] loadNibNamed:@"BizareaInfoAllStoreView" owner:self options:nil].lastObject;
    
    allStoreView.frame = CGRectMake(10, 10, kScreenWidth - 20, 310);
    
    allStoreView.indexPathRow = indexPathRow;
    allStoreView.model = _model;
    
    [superView addSubview:allStoreView];

}

#pragma mark - tableView delegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1 + _model.storesHeadpic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bizareaInfoAllIndentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor clearColor];
        [self _createIndexPath0WithView:cell.contentView];
    }
    else {
        cell.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"button_1-_h.png"]];
        [self _createIndexPath1WithView:cell.contentView withIndexPath:indexPath.row - 1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGFloat heightBase = [@"测试用的单行文字高度" boundingRectWithSize:CGSizeMake(kScreenWidth, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
        CGFloat height = [_model.placeDesc boundingRectWithSize:CGSizeMake(kScreenWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
        
        NSInteger x = height / heightBase;
        
        if (x <= 3) {
            return height + 130 + 10;
        }
        else {
            if (_isClick == NO) {
                return 65 + 10 + 130 + 10;
            }
            else {
                return height + 130 + 10 + 10;
            }
        }
    }
    
    return 330;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        _isClick = !_isClick;
        
        [tableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIImageView *_headView = [self.superview viewWithTag:11];
    
    CGFloat y = scrollView.contentOffset.y;
    if (y < 0) {
        CGFloat scale = -y / 130 + 1;
        
        _headView.transform = CGAffineTransformMakeScale(scale, scale);
        
        _headView.top = 0;
        _headView.bottom = -y + 130;
        
    }
    
}

@end
