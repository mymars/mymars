//
//  MyCell.m
//  Mars
//
//  Created by Macx on 16/2/19.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "MyCell.h"
#import "Model3.h"
@implementation MyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setArr3:(NSMutableArray *)arr3 {

    
    if (arr3 != _arr3) {
        _arr3 = arr3;

        if (arr3.count == 9) {
            Model3 *model = [[Model3 alloc] init];
            
            model = arr3[0];
            _label1.text = model.title;
            [_imageView1 sd_setImageWithURL:[NSURL URLWithString:model.image]];
            _imageView1.contentMode = UIViewContentModeRedraw;
            model = arr3[1];
            _label2.text = model.title;
            [_imageView2 sd_setImageWithURL:[NSURL URLWithString:model.image]];
            
            model = arr3[2];
            _label3.text = model.title;
            [_imageView3 sd_setImageWithURL:[NSURL URLWithString:model.image]];
            
            model = arr3[3];
            _label4.text = model.title;
            [_imageView4 sd_setImageWithURL:[NSURL URLWithString:model.image]];
            
            model = arr3[4];
            _label5.text = model.title;
            [_imageView5 sd_setImageWithURL:[NSURL URLWithString:model.image]];
      
            model = arr3[5];
            _label6.text = model.title;
            [_imageView6 sd_setImageWithURL:[NSURL URLWithString:model.image]];

           
            model = arr3[6];
            _label7.text = model.title;
            [_imageView7 sd_setImageWithURL:[NSURL URLWithString:model.image]];
            
            model = arr3[7];
            _label8.text = model.title;
            [_imageView8 sd_setImageWithURL:[NSURL URLWithString:model.image]];
            
            model = arr3[8];
            _label9.text = model.title;
            [_imageView9 sd_setImageWithURL:[NSURL URLWithString:model.image]];
        }
    }
}




@end
