//
//  Cell2.m
//  Mars
//
//  Created by Macx on 16/2/22.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "Cell2.h"
#import "Cell2Model.h"
@implementation Cell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(Cell2Model *)model {
    if (model != _model) {
        _model = model;
        
        //        Cell1Model *model1 = [[Cell1Model alloc] init];
        
        
        [_img2 sd_setImageWithURL:[NSURL URLWithString:model.img1]];
        [_img1 sd_setImageWithURL:[NSURL URLWithString:model.img2]];
        [_img3 sd_setImageWithURL:[NSURL URLWithString:model.img3]];
        [_img4 sd_setImageWithURL:[NSURL URLWithString:model.img4]];
        [_img5 sd_setImageWithURL:[NSURL URLWithString:model.img5]];
        _label1.text = model.title1;
        _label.text = model.title;
        //        NSLog(@"%@",model.title);
    }
}
@end
