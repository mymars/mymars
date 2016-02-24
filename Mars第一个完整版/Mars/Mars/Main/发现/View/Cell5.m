//
//  Cell5.m
//  Mars
//
//  Created by Macx on 16/2/22.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "Cell5.h"
#import "Cell4Model.h"
@implementation Cell5

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(Cell4Model *)model {
    if (model != _model) {
        _model = model;
        
        //        Cell1Model *model1 = [[Cell1Model alloc] init];
        
        
        [_img1 sd_setImageWithURL:[NSURL URLWithString:model.img1]];
        [_img2 sd_setImageWithURL:[NSURL URLWithString:model.img2]];
        [_img3 sd_setImageWithURL:[NSURL URLWithString:model.img3]];
        [_img4 sd_setImageWithURL:[NSURL URLWithString:model.img4]];
//        [_img5 sd_setImageWithURL:[NSURL URLWithString:model.img5]];
//        _label1.text = model.title1;
        _label.text = model.title;
        //        NSLog(@"%@",model.title);
    }
}
@end
