//
//  ImageCell.m
//  Mars
//
//  Created by wiseyep on 16/2/18.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "ImageCell.h"
@interface ImageCell()

@property (weak, nonatomic) IBOutlet UIImageView *tyImageView;
@property (weak, nonatomic) IBOutlet UILabel *tyLabel;

@end

@implementation ImageCell

- (instancetype)initWithImage:(NSString *)imageName tyName:(NSString *)tyName
{
    self.tyImageView.image = [UIImage imageNamed:imageName];
    self.tyLabel.text = tyName;
    [self.tyLabel setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:18.0]];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
