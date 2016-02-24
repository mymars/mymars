//
//  BizareaInfoOneTableView.h
//  Mars
//
//  Created by Macx on 16/2/21.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BizareaModel;
@interface BizareaInfoOneTableView : UITableView
@property (nonatomic,strong)BizareaModel *model;
@property (nonatomic,assign)NSInteger indexSelect;
@end
