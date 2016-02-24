//
//  LabelCell.m
//  Mars
//
//  Created by wiseyep on 16/2/18.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "LabelCell.h"

@interface LabelCell()

@property (weak, nonatomic) IBOutlet UILabel *seLabel;

@end

@implementation LabelCell

- (instancetype)initWithLabelName:(NSString *)string
{
    self.seLabel.text = string;
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
