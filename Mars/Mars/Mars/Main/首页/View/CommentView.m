//
//  CommentView.m
//  Mars
//
//  Created by Macx on 16/2/15.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "CommentView.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"

@interface CommentView ()
@property (weak, nonatomic) IBOutlet UIImageView *commentView;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *commentDescription;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadPic;
@property (weak, nonatomic) IBOutlet UIImageView *storeView;

@end

@implementation CommentView



- (void)setCommentModel:(CommentModel *)commentModel {

    if (_commentModel != commentModel) {
        _commentModel = commentModel;
        
        _userHeadPic.layer.cornerRadius = _userHeadPic.frame.size.height / 2.0;
        _userHeadPic.layer.masksToBounds = YES;
        [_userHeadPic.layer setBorderWidth:2];
        [_userHeadPic.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        [_userHeadPic sd_setImageWithURL:[NSURL URLWithString:commentModel.userHeadpic]];
        
        _nickName.text = commentModel.nickName;
        
        _nickName.height = 40;
       
        //找不到_line的图片,用白色背景代替

        _line.backgroundColor = [UIColor whiteColor];
        
        _commentView.image = [UIImage imageNamed:@"home_frame"];
        
        [_storeView sd_setImageWithURL:[NSURL URLWithString:commentModel.imgUrl]];
        
        _storeName.text = commentModel.storeName.length > 0 ? commentModel.storeName : commentModel.storeEnglishName;
        
        _commentDescription.text = commentModel.commentDescription;
        
        _time.text = commentModel.publishTimeStr;
        
    }

}

@end
