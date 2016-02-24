//
//  ToplistView.h
//  Mars
//
//  Created by Macx on 16/2/17.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ToplistChooseIndexBlock)(NSString *);
@interface ToplistView : UIView
@property (nonatomic,copy)NSArray *toplistModelArray;
@property (nonatomic,copy)ToplistChooseIndexBlock block;
@end
