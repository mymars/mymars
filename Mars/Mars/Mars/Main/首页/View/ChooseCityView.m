//
//  ChooseCityView.m
//  Mars
//
//  Created by Macx on 16/2/22.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "ChooseCityView.h"

@interface ChooseCityView ()
@property (weak, nonatomic) IBOutlet UIButton *beijing;
@property (weak, nonatomic) IBOutlet UIButton *shanghai;
@property (weak, nonatomic) IBOutlet UIButton *tokyo;
@property (weak, nonatomic) IBOutlet UIButton *seoul;
@property (weak, nonatomic) IBOutlet UIImageView *beijingImage;
@property (weak, nonatomic) IBOutlet UIImageView *shanghaiImage;
@property (weak, nonatomic) IBOutlet UIImageView *tokyoImage;
@property (weak, nonatomic) IBOutlet UIImageView *seoulImage;

@end

@implementation ChooseCityView

- (void)setFrame:(CGRect)frame {

    [super setFrame:frame];

    [_beijing setBackgroundImage:[UIImage imageNamed:@"beijng_bg"] forState:UIControlStateNormal];
    [_shanghai setBackgroundImage:[UIImage imageNamed:@"shanghai_bg"] forState:UIControlStateNormal];
    [_tokyo setBackgroundImage:[UIImage imageNamed:@"tokyo_bg"] forState:UIControlStateNormal];
    [_seoul setBackgroundImage:[UIImage imageNamed:@"seoul_bg"] forState:UIControlStateNormal];
    
    _beijingImage.image = [UIImage imageNamed:@"home_beijing"];
    _shanghaiImage.image = [UIImage imageNamed:@"home_shanghai"];
    _tokyoImage.image = [UIImage imageNamed:@"home_tokyo"];
    _seoulImage.image = [UIImage imageNamed:@"home_seoul"];
    
    
    _beijing.tag = 60;
    _shanghai.tag = 61;
    _tokyo.tag = 62;
    _seoul.tag = 63;
    
}

@end
