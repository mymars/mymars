//
//  BizareaModel.h
//  Mars
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <Foundation/Foundation.h>
//首页商圈店铺model

@interface BizareaModel : NSObject
@property (nonatomic,copy)NSString *bizareaID;    //id
@property (nonatomic,copy)NSString *name;       //name
@property (nonatomic,copy)NSString *englishName;//english_name
@property (nonatomic,copy)NSString *headPic;    //headpic
@property (nonatomic,copy)NSMutableArray *storesEnglishName;//store_english_name合集
@property (nonatomic,copy)NSMutableArray *storesName;  //store_name合集


@property (nonatomic,copy)NSMutableArray *storesHeadpic;  //headpic合集

@property (nonatomic,copy)NSMutableArray *storesTagName;
@property (nonatomic,copy)NSMutableArray *storesScore;
@property (nonatomic,copy)NSMutableArray *storesIcon;
@property (nonatomic,copy)NSMutableArray *storesDescription;
@property (nonatomic,copy)NSMutableArray *storesAddress;
@property (nonatomic,copy)NSMutableArray *storesIsFavorite;
@property (nonatomic,copy)NSString *placeDesc;
@property (nonatomic,copy)NSMutableArray *storesPics;

@end
