//
//  BizareaView.m
//  Mars
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "BizareaView.h"
#import "BizareaModel.h"


@interface BizareaView ()
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIImageView *HeadView;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UIImageView *icon3;
@property (weak, nonatomic) IBOutlet UIImageView *icon4;
@property (weak, nonatomic) IBOutlet UIImageView *icon5;
@property (weak, nonatomic) IBOutlet UIView *MoreView;

@end

@implementation BizareaView

- (void)setFrame:(CGRect)frame {

    [super setFrame:frame];
    
    _HeadView.frame = CGRectMake(0, 0, self.width, 150);
    _grayView.frame = _HeadView.frame;
    
    CGFloat iconWidth = (self.width - 4 * 20) / 3;
    
    _icon1.frame = CGRectMake(20, 160, iconWidth, 80);
    _icon2.frame = CGRectMake(40 + iconWidth, 160, iconWidth, 80);
    _icon3.frame = CGRectMake(60 + iconWidth * 2, 160, iconWidth, 80);
    _icon4.frame = CGRectMake(20, 250, iconWidth, 80);
    _icon5.frame = CGRectMake(40 + iconWidth, 250, iconWidth, 80);
    _MoreView.frame = CGRectMake(60 + iconWidth * 2, 250, iconWidth, 80);
    
    ((UILabel *)[self viewWithTag:300]).bounds = _MoreView.bounds;
    ((UILabel *)[self viewWithTag:300]).left = 0;
    
    _MoreView.backgroundColor = [UIColor blackColor];

}

- (void)setBizareaModel:(BizareaModel *)bizareaModel {

    if (_bizareaModel != bizareaModel) {
        _bizareaModel = bizareaModel;
        
        [_HeadView sd_setImageWithURL:[NSURL URLWithString:_bizareaModel.headPic]];
        _grayView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
        
        NSString *englishName = _bizareaModel.englishName;
        NSString *name = _bizareaModel.name;
        
        if (englishName.length || name.length) {
            UILabel *labelEnglishName = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, _HeadView.width, 30)];
            UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, _HeadView.width, 15)];
            
            labelEnglishName.text = englishName;
            labelEnglishName.textColor = [UIColor whiteColor];
            labelEnglishName.textAlignment = NSTextAlignmentCenter;
            labelEnglishName.numberOfLines = 1;
            labelEnglishName.font = [UIFont boldSystemFontOfSize:35];

            labelName.textAlignment = NSTextAlignmentCenter;
            labelName.text = name;
            labelName.textColor = [UIColor whiteColor];
            labelName.numberOfLines = 1;
            labelName.font = [UIFont boldSystemFontOfSize:25];
            
            [_HeadView addSubview:labelEnglishName];
            [_HeadView addSubview:labelName];
        }
        
        NSArray *iconArr = @[_icon1,_icon2,_icon3,_icon4,_icon5];
        
        for (UIView *view in iconArr) {
            view.hidden = YES;
        }
        
        NSInteger countHeadPic = _bizareaModel.storesHeadpic.count;
        
        countHeadPic = countHeadPic > 5 ? 5 : countHeadPic;
        
        for (int i = 0; i < countHeadPic; i++) {
            
            ((UIImageView *)iconArr[i]).hidden = NO;
            
            [((UIImageView *)iconArr[i]) sd_setImageWithURL:[NSURL URLWithString:_bizareaModel.storesHeadpic[i]]];

            NSString *storeEnglishName = _bizareaModel.storesEnglishName[i];
            NSString *storeName = _bizareaModel.storesName[i];
            
            if (storeName.length || storeEnglishName.length) {
               
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, ((UIImageView *)iconArr[i]).width, 20)];
                
                [((UIImageView *)iconArr[i]) addSubview:label];
                
                label.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];

                label.text = storeEnglishName.length > 0 ? storeEnglishName :storeName;
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14];
                
                label.textColor = [UIColor whiteColor];
                
                label.numberOfLines = 1;
                
            }
        }

        if (_bizareaModel.storesHeadpic.count < 6) {
            _MoreView.hidden = YES;
        }
        else {
            _MoreView.hidden = NO;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        
        [self addGestureRecognizer:tap];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {

    CGPoint p1 = [tap locationInView:_icon1];
    CGPoint p2 = [tap locationInView:_icon2];
    CGPoint p3 = [tap locationInView:_icon3];
    CGPoint p4 = [tap locationInView:_icon4];
    CGPoint p5 = [tap locationInView:_icon5];
    CGPoint p6 = [tap locationInView:_MoreView];
    CGPoint p7 = [tap locationInView:_HeadView];
    
    NSInteger indexSelect = 0;
    
    if (p7.x <= _HeadView.width && p7.x >= 0 && p7.y <= _HeadView.height && p7.y >= 0) {
        indexSelect = 7;
        
    }
    if (p6.x <= _MoreView.width && p6.x >= 0 && p6.y <= _MoreView.height && p6.y >= 0 && _bizareaModel.storesHeadpic.count > 5) {
        indexSelect = 6;
    }
    if (p5.x <= _icon5.width && p5.x >= 0 && p5.y <= _icon5.height && p5.y >= 0 && _bizareaModel.storesHeadpic.count > 4) {
        indexSelect = 5;
    }
    if (p4.x <= _icon4.width && p4.x >= 0 && p4.y <= _icon4.height && p4.y >= 0 && _bizareaModel.storesHeadpic.count > 3) {
        indexSelect = 4;
    }
    if (p3.x <= _icon3.width && p3.x >= 0 && p3.y <= _icon3.height && p3.y >= 0 && _bizareaModel.storesHeadpic.count > 2) {
        indexSelect = 3;
    }
    if (p2.x <= _icon2.width && p2.x >= 0 && p2.y <= _icon2.height && p2.y >= 0 && _bizareaModel.storesHeadpic.count > 1) {
        indexSelect = 2;
    }
    if (p1.x <= _icon1.width && p1.x >= 0 && p1.y <= _icon1.height && p1.y >= 0 && _bizareaModel.storesHeadpic.count > 0) {
        indexSelect = 1;
    }
    
    if (indexSelect != 0) {
        _bizereaStoreShowBlock(@{@"data":_bizareaModel,@"index":[NSNumber numberWithInteger:indexSelect]});
    }
}

@end
