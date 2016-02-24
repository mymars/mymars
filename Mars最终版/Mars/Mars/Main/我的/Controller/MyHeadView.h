//
//  MyHeadView.h
//  Mars
//
//  Created by wiseyep on 16/2/18.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHeadView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
- (instancetype)initWithAvatar:(NSString *)avatarString name:(NSString *)name;

@end
