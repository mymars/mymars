//
//  Cell1.m
//  Mars
//
//  Created by Macx on 16/2/20.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "Cell1.h"
#import "Cell1Model.h"
@implementation Cell1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(Cell1Model *)model {
    if (model != _model) {
        _model = model;

//        Cell1Model *model1 = [[Cell1Model alloc] init];

        
        [_imgView2 sd_setImageWithURL:[NSURL URLWithString:model.img1]];
        [_imgView1 sd_setImageWithURL:[NSURL URLWithString:model.img2]];
        [_imgView3 sd_setImageWithURL:[NSURL URLWithString:model.img3]];
        [_imgView4 sd_setImageWithURL:[NSURL URLWithString:model.img4]];
        [_imgView5 sd_setImageWithURL:[NSURL URLWithString:model.img5]];
        _label.text = model.title;
//        NSLog(@"%@",model.title);
    }
}
@end
