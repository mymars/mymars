//
//  BizareaInfoOneHeadView.m
//  Mars
//
//  Created by Macx on 16/2/22.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "BizareaInfoOneHeadView.h"
#import "BizareaModel.h"
@interface BizareaInfoOneHeadView ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *tagName;

@end

@implementation BizareaInfoOneHeadView

- (void)setModel:(BizareaModel *)model {

    if (model != _model) {
        _model = model;
     
        [_icon sd_setImageWithURL:[NSURL URLWithString:_model.storesIcon[_indexSelect - 1]]];
        
        _name.text = ((NSString *)_model.storesName[_indexSelect - 1]).length > 0 ? _model.storesName[_indexSelect - 1] : _model.storesEnglishName[_indexSelect - 1];

        _tagName.text = _model.storesTagName[_indexSelect - 1];
        
        _desc.text = _model.storesDescription[_indexSelect - 1];
        
        CGFloat height = [_desc.text boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
        self.height = height + 210 + 10;
    }
}

@end
