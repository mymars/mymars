//
//  SettingTableViewCell.m
//  Mars
//
//  Created by wiseyep on 16/2/19.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "SettingTableViewCell.h"

@interface SettingTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *tyLabel;
@property (weak, nonatomic) IBOutlet UILabel *memorLabel;

@end

@implementation SettingTableViewCell

- (instancetype)initWithType:(NSString *)type memory:(CGFloat)memory indexRow:(NSInteger)row
{
    self.tyLabel.text = type;
    self.memorLabel.text = [NSString stringWithFormat:@"(%.2fMB)",memory];
    if (row != 2)
    {
        self.memorLabel.hidden = YES;
    }
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
