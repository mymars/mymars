//
//  LastCell.m
//  Mars
//
//  Created by Macx on 16/2/19.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "LastCell.h"
#import "Model4.h"
@implementation LastCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setArr4:(NSMutableArray *)arr4 {
    if (arr4 != _arr4) {
        _arr4 = arr4;
        Model4 *model = [[Model4 alloc] init];
        
        model = arr4[0];

        [_imageView1 sd_setImageWithURL:[NSURL URLWithString:model.imageName]];
        
        model = arr4[1];

        [_imageView2 sd_setImageWithURL:[NSURL URLWithString:model.imageName]];
        
        model = arr4[2];

        [_imageView3 sd_setImageWithURL:[NSURL URLWithString:model.imageName]];
        
        model = arr4[3];

        [_imageView4 sd_setImageWithURL:[NSURL URLWithString:model.imageName]];
    }
}
@end
