//
//  ToplistIndexView.m
//  Mars
//
//  Created by Macx on 16/2/18.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "ToplistIndexView.h"
#import "ToplistIndexModel.h"

@interface ToplistIndexView ()

@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIImageView *headpic;
@property (weak, nonatomic) IBOutlet UIImageView *storeIcon;
@property (weak, nonatomic) IBOutlet UILabel *storeBizinfo;
@property (weak, nonatomic) IBOutlet UILabel *storeTagName;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UIImageView *storePic1;
@property (weak, nonatomic) IBOutlet UIImageView *storePic2;
@property (weak, nonatomic) IBOutlet UIImageView *storePic3;
@property (weak, nonatomic) IBOutlet UILabel *storeDesc;
@property (weak, nonatomic) IBOutlet UIImageView *storeScore;

@end

@implementation ToplistIndexView

- (void)setToplistIndexModel:(ToplistIndexModel *)toplistIndexModel {

    if (_toplistIndexModel != toplistIndexModel) {
        _toplistIndexModel = toplistIndexModel;

        _storeScore.hidden = YES;
        _storePic1.hidden = YES;
        _storePic2.hidden = YES;
        _storePic3.hidden = YES;
        //imageView调灰图层
        _grayView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];

        [_headpic sd_setImageWithURL:[NSURL URLWithString:_toplistIndexModel.storesHeadpic[_indexCount]]];
        [_storeIcon sd_setImageWithURL:[NSURL URLWithString:_toplistIndexModel.storesIcon[_indexCount]]];
        _storeBizinfo.text = _toplistIndexModel.storesBizinfo[_indexCount];
        _storeTagName.text = _toplistIndexModel.storesTagName[_indexCount];
        _storeName.text = ((NSString *)_toplistIndexModel.storesName[_indexCount]).length > 0 ? _toplistIndexModel.storesName[_indexCount] : _toplistIndexModel.storesEnglishName[_indexCount];

        NSArray *picUrls = _toplistIndexModel.storesPics[_indexCount];

        NSInteger count = picUrls.count > 3 ? 3: picUrls.count;

        switch (count) {
            case 1:
                _storePic1.hidden = NO;
                [_storePic1 sd_setImageWithURL:[NSURL URLWithString:picUrls[0]]];
                break;
            case 2:
                _storePic1.hidden = NO;
                _storePic2.hidden = NO;
                [_storePic1 sd_setImageWithURL:[NSURL URLWithString:picUrls[0]]];
                [_storePic2 sd_setImageWithURL:[NSURL URLWithString:picUrls[1]]];
                break;
            case 3:
                _storePic1.hidden = NO;
                _storePic2.hidden = NO;
                _storePic3.hidden = NO;
                [_storePic1 sd_setImageWithURL:[NSURL URLWithString:picUrls[0]]];
                [_storePic2 sd_setImageWithURL:[NSURL URLWithString:picUrls[1]]];
                [_storePic3 sd_setImageWithURL:[NSURL URLWithString:picUrls[2]]];
                break;
            default:
                break;
        }
        _storeDesc.text = _toplistIndexModel.storesDesc[_indexCount];

        NSInteger score = [_toplistIndexModel.storesScore[_indexCount] integerValue];

        score = score > 5 ? 5 : score;

        if (score > 0) {
            _storeScore.hidden = NO;
            _storeScore.image = [UIImage imageNamed:[NSString stringWithFormat:@"score_%ld",score]];
        }

        
        //给icon添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction :)];
        [self addGestureRecognizer:tap];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {

    CGPoint p = [tap locationInView:self];
    
    CGFloat withIcon = (kScreenWidth - 60) / 3.0;
    
    NSMutableArray *pics = [NSMutableArray array];
    
#warning there is a bug will break down in the future
    /**
     *  这里需要考虑未加载完成时点击image,任意一张图没被加载完成时点击都会崩溃
     */
    
    if (!_storePic1.hidden) {
        [pics addObject:_storePic1.image ? _storePic1.image : [NSNull null]];
    }
    if (!_storePic2.hidden) {
        [pics addObject:_storePic2.image ? _storePic2.image : [NSNull null]];
    }
    if (!_storePic3.hidden) {
        [pics addObject:_storePic3.image ? _storePic3.image : [NSNull null]];
    }
    NSString *address = _toplistIndexModel.storesAddress[_indexCount];

    address = address.length > 0 ? address : @"";
    
    if (p.y >= 230 && p.y <= 320) {
        if (p.x >= 10 && p.x <= (10 + withIcon)) {

            _topicInfoImageShowBlock(@{@"pics":pics,@"index":@1,@"address":address});

        }
        else if (p.x >= (20 + withIcon) && p.x <= (20 + 2 * withIcon)) {
            _topicInfoImageShowBlock(@{@"pics":pics,@"index":@2,@"address":address});

        }
        else if (p.x >= (30 + 2 * withIcon) && p.x <= (30 + 3 * withIcon)) {
            _topicInfoImageShowBlock(@{@"pics":pics,@"index":@3,@"address":address});

        }
    }
}

@end
