//
//  BizareaInfoOneTableView.m
//  Mars
//
//  Created by Macx on 16/2/21.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "BizareaInfoOneTableView.h"
#import "BizareaModel.h"
#import "BizareaInfoOneHeadView.h"

static NSString *bizareaInfoOneIndentifier = @"bizareaInfoOneIndentifier";

@interface BizareaInfoOneTableView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BizareaInfoOneTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:bizareaInfoOneIndentifier];
    
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
//        if ([view isKindOfClass:[BizareaInfoOneHeadView class]]) {
            [view removeFromSuperview];
//        }
    }
    
    BizareaInfoOneHeadView * headView = [[NSBundle mainBundle] loadNibNamed:@"BizareaInfoOneHeadView" owner:self options:nil].lastObject;
    
    
    headView.frame = superView.bounds;
    headView.indexSelect = _indexSelect;
    headView.model = _model;
    
    [superView addSubview:headView];
    
    
}

- (void)_createIndexPath1WithView:(UIView *)superView {

    for (UIView *view in superView.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView *address = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 30)];
    address.image = [UIImage imageNamed:@"location_icon"];
    
    [superView addSubview:address];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, kScreenWidth / 2.0 - 35, 50)];
    
    label.numberOfLines = 2;
    
    label.text = _model.storesAddress[_indexSelect];
    label.font = [UIFont systemFontOfSize:14];
    
    [superView addSubview:label];
    
    UIImageView *favo = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 15, 20, 20)];
    
    favo.image = [UIImage imageNamed:@"heart_icon"];

    if ([_model.storesIsFavorite[_indexSelect - 1] integerValue] == 1) {
        favo.image = [UIImage imageNamed:@"heart_p"];
    }
    [superView addSubview:favo];
    
    UIImageView *phone = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 + 10, 15, 20, 20)];
    
    phone.image = [UIImage imageNamed:@"tel_icon"];
    
    [superView addSubview:phone];
    
}

#pragma mark - tableview delegeta

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bizareaInfoOneIndentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        
        [self _createIndexPath0WithView:cell.contentView];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row == 1) {
        cell.backgroundColor = [UIColor whiteColor];
        [self _createIndexPath1WithView:cell.contentView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 50;
    }
    
    NSString *desc = _model.storesDescription[_indexSelect - 1];
    
    CGFloat height = [desc boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
    
    return height + 210 + 10;
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
