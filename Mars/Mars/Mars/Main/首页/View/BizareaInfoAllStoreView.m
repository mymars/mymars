//
//  BizareaInfoAllStoreView.m
//  Mars
//
//  Created by Macx on 16/2/22.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "BizareaInfoAllStoreView.h"
#import "BizareaModel.h"

@interface BizareaInfoAllStoreView ()
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIImageView *score;
@property (weak, nonatomic) IBOutlet UILabel *tagName;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *pic1;
@property (weak, nonatomic) IBOutlet UIImageView *pic2;
@property (weak, nonatomic) IBOutlet UIImageView *pic3;

@end

@implementation BizareaInfoAllStoreView

- (void)setModel:(BizareaModel *)model {
   
    if (_model != model) {
        _model = model;
        
        [_headView sd_setImageWithURL:[NSURL URLWithString:_model.storesHeadpic[_indexPathRow]]];

        _grayView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
        
        NSInteger score = [_model.storesScore[_indexPathRow] integerValue];
        
        score = score > 5 ? 5 : score;
        _score.hidden = YES;
        if (score > 0) {
            _score.hidden = NO;
            _score.image = [UIImage imageNamed:[NSString stringWithFormat:@"score_%ld",score]];
        }
        
        _tagName.text = _model.storesTagName[_indexPathRow];
        [_icon sd_setImageWithURL:[NSURL URLWithString:_model.storesIcon[_indexPathRow]]];
        _name.text = ((NSString *)_model.storesName[_indexPathRow]).length > 0 ? _model.storesName[_indexPathRow] : _model.storesEnglishName[_indexPathRow];
        
        _pic1.hidden = YES;
        _pic2.hidden = YES;
        _pic3.hidden = YES;
        
        NSArray *pics = _model.storesPics[_indexPathRow];
        if (pics.count == 1) {
            _pic1.hidden = NO;
            [_pic1 sd_setImageWithURL:[NSURL URLWithString:pics[0]]];
        }
        if (pics.count == 2) {
            _pic1.hidden = NO;
            [_pic1 sd_setImageWithURL:[NSURL URLWithString:pics[0]]];
            _pic2.hidden = NO;
            [_pic2 sd_setImageWithURL:[NSURL URLWithString:pics[1]]];
        }
        if (pics.count >= 3) {
            _pic1.hidden = NO;
            [_pic1 sd_setImageWithURL:[NSURL URLWithString:pics[0]]];
            _pic2.hidden = NO;
            [_pic2 sd_setImageWithURL:[NSURL URLWithString:pics[1]]];
            _pic3.hidden = NO;
            [_pic3 sd_setImageWithURL:[NSURL URLWithString:pics[2]]];
        }
    }

}

@end
