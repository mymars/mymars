//
//  MyHeadView.m
//  Mars
//
//  Created by wiseyep on 16/2/18.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "MyHeadView.h"

@interface MyHeadView()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MyHeadView

- (instancetype)initWithAvatar:(NSString *)avatarString name:(NSString *)name
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:nil options:nil];
    MyHeadView *view = array[0];
    view.nameLabel.text = name;
    [view.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:23.0]];
    
    view.avatarView.image = [UIImage imageNamed:avatarString];

    
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarView.layer.borderWidth = 4.0;
    _avatarView.layer.cornerRadius = _avatarView.width/4;
    _avatarView.layer.masksToBounds = YES;
    
    _avatarView.tag = 666;
}



@end
