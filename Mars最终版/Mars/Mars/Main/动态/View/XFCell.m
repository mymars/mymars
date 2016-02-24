//
//  XFCell.m
//  Mars
//
//  Created by Macx on 16/2/23.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "XFCell.h"
#import "NewsModel.h"
@implementation XFCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(NewsModel *)model {
    if (model != _model) {
        _model = model;
        
        [_img1 sd_setImageWithURL:[NSURL URLWithString:model.img1]];
        [_img2 sd_setImageWithURL:[NSURL URLWithString:model.img2]];
        _title.text = model.title;

    }
}
@end
