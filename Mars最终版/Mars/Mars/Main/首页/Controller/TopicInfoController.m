//
//  TopicInfoController.m
//  Mars
//
//  Created by Macx on 16/2/18.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "TopicInfoController.h"
#import "ToplistIndexModel.h"
#import "ToplistIndexView.h"
#import "ChangingHeightLabel.h"

static NSString *headCellIdentifier = @"headCellIdentifier";
static NSString *textCellIdentifier = @"textCellIdentifier";
static NSString *infoCellIndetifier = @"infoCellIndetifier";


@interface TopicInfoController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIImageView *headView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIImage *saveImage;

@property (nonatomic,assign)NSInteger indexImage;       //存放保存的图片的index
@property (nonatomic,copy)NSMutableDictionary *dicImageBlock;   //block中返回的数组存放
@property (nonatomic,assign)CGFloat heightIndexPath1;  //存放indexpath[1]的行高
@property (nonatomic,assign)BOOL isClick; //判断是否点击了indexpath[1]的button

@end


@implementation TopicInfoController

- (void)dealloc {
    NSLog(@"TopicInfoController被销毁");
    self.tabBarController.tabBar.hidden = NO;
}

- (void)_createBackBarButtonItem {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    button.tag = 50;
    
    [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)_createTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.tag = 20;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:headCellIdentifier];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:textCellIdentifier];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:infoCellIndetifier];
    
    _tableView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:_tableView];
}

- (void)setToplistIndexModel:(ToplistIndexModel *)toplistIndexModel {
    
    if (_toplistIndexModel != toplistIndexModel) {
        _toplistIndexModel = toplistIndexModel;
   
        [_headView sd_setImageWithURL:[NSURL URLWithString:toplistIndexModel.cover]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{

            self.title = toplistIndexModel.title;
            [_tableView reloadData];
        });
    }
    
}

- (void)_createTopicDescView:(UIView *)superView withToplistIndexModel:(ToplistIndexModel *)model {

    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }

    ChangingHeightLabel *label = [[ChangingHeightLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65) withString:model.storeDescription withFlag:_isClick withSuperView:superView];


}
//------------这里下面代码需要检查,问题出在indexpath[2]以及之后
- (void)_createTopicInfoView:(UIView *)superView withIndexCount:(NSInteger )indexCount withToplistIndexModel:(ToplistIndexModel *)model {
    
    for (UIView *view1 in superView.subviews) {
        if ([view1 isKindOfClass:[ToplistIndexView class]]) {
            [view1 removeFromSuperview];
        }
    }
    
    ToplistIndexView *view = [[NSBundle mainBundle] loadNibNamed:@"ToplistIndexView" owner:self options:nil].lastObject;
    
    view.indexCount = indexCount;
    view.toplistIndexModel = model;
    [superView addSubview:view];
    
    CGFloat heightLabel = [((NSString *)model.storesDesc[indexCount]) boundingRectWithSize:CGSizeMake(kScreenWidth - 40, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
    
    view.frame = CGRectMake(10, 10, kScreenWidth - 20, 330 + 10 + heightLabel);
    
    
    view.topicInfoImageShowBlock = ^(NSDictionary *dic){
        
        if (((NSArray *)dic[@"pics"]).count >= [dic[@"index"] integerValue]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self presentViewController:[self _createPresentView:dic] animated:NO completion:NULL];
//            });
        }
        
    };
}

- (UIViewController *)_createPresentView:(NSDictionary *)dic {

    if (_dicImageBlock == nil) {
        _dicImageBlock = [NSMutableDictionary dictionary];
    }
    _dicImageBlock = [dic mutableCopy];
    
    UIViewController *vc = [[UIViewController alloc] init];

    UIView *view = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    view.backgroundColor = [UIColor whiteColor];
    [vc.view addSubview:view];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 35, 20, 20)];

    [button setBackgroundImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [vc.view addSubview:button];
    
    NSArray *pics = dic[@"pics"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, kScreenHeight - 80 - 80)];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.tag = 19;

    scrollView.contentSize = CGSizeMake(kScreenWidth * pics.count, kScreenHeight - 80 - 80);
    
    [vc.view addSubview:scrollView];
    
    for (int i = 0; i < pics.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + kScreenWidth * i, (kScreenHeight - 300 - 160) / 2.0, kScreenWidth - 10, 300)];
        imageView.image = pics[i];
        
        [scrollView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 + kScreenWidth * i, kScreenHeight - 160 - 25, kScreenWidth / 2.0, 20)];
        
        label.text = dic[@"address"];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        
        [scrollView addSubview:label];
        
        UIImageView *address = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb_home_n"]];
        
        address.frame = CGRectMake(kScreenWidth / 2.0 - 15 + kScreenWidth * i , kScreenHeight - 160 - 25, 10, 15);
        
        [scrollView addSubview:address];
    }
    
    //实现直接显示点击的那张图片而不是从头开始浏览图片
    [scrollView scrollRectToVisible:CGRectMake(kScreenWidth * ([dic[@"index"] integerValue] - 1), 0, kScreenWidth, 300) animated:NO];
    
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(5, kScreenHeight - 80, kScreenWidth - 10, 1)];
    
    line.backgroundColor = [UIColor whiteColor];
    
    [vc.view addSubview:line];
    
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(5, kScreenHeight - 70, 40, 40)];
    
    [save setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    
    save.tag = 49;
    
    [vc.view addSubview:save];
    
    [save addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return vc;
}

#pragma mark - Action

- (void)buttonAction:(UIButton *)button {

    if (button.tag == 50) {
        [self.navigationController popViewControllerAnimated:YES];

        return;
    }
    if (button.tag == 49) {
        NSArray *pics = _dicImageBlock[@"pics"];
        
        UIImageWriteToSavedPhotosAlbum(pics[_indexImage], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        return;
    }
    
    [self dismissViewControllerAnimated:NO completion:NULL];


}

- (void)timerAction:(NSTimer *)timer {

    [[[UIApplication sharedApplication].keyWindow viewWithTag:18] removeFromSuperview];
    [timer invalidate];
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    if (error == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *success = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2.0, (kScreenHeight - 50) / 2.0, 100, 50)];
            
            success.tag = 18;
            success.backgroundColor = [UIColor grayColor];
            [[UIApplication sharedApplication].keyWindow addSubview:success];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
            label.text = @"保存成功";
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [success addSubview:label];

            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        });
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBarController.tabBar.hidden = YES;

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_1-_h.png"]];

    if (_headView == nil) {
        
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        _headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_1-_h.png"]];

        [self.view addSubview:_headView];
    }
    
    [self _createBackBarButtonItem];
    [self _createTableView];

}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //imageView + textlabel + _toplistIndexModel

    if (_toplistIndexModel.storesHeadpic.count) {
        
        return 1 + 1 + _toplistIndexModel.storesHeadpic.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headCellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellIdentifier forIndexPath:indexPath];

        cell.contentView.backgroundColor = [UIColor whiteColor];

        [self _createTopicDescView:cell.contentView withToplistIndexModel:_toplistIndexModel];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellIndetifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_1-_h.png"]];
    
    [self _createTopicInfoView:cell.contentView withIndexCount:indexPath.row - 2 withToplistIndexModel:_toplistIndexModel];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        
        _isClick = !_isClick;
        
        [tableView reloadData];
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 150;
    }
    if (indexPath.row == 1) {
        CGFloat heightBase = [@"测试用的单行文字高度" boundingRectWithSize:CGSizeMake(kScreenWidth, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
        CGFloat height = [_toplistIndexModel.storeDescription boundingRectWithSize:CGSizeMake(kScreenWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
        
        NSInteger x = height / heightBase;
        
        if (x <= 3) {
            return height + 10;
        }
        else {
            if (_isClick == NO) {
                return 65 + 10 + 10;
            }
            else {
                return height + 10 + 10;
            }
        }
    }
    CGFloat heightLabel = [((NSString *)_toplistIndexModel.storesDesc[indexPath.row - 2]) boundingRectWithSize:CGSizeMake(kScreenWidth - 40, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;

    return 330 + 10 + heightLabel + 20;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.tag == 20) {
        
        CGFloat y = scrollView.contentOffset.y;
        if (y < 0) {
            CGFloat scale = -y / 150 + 1;
            
            _headView.transform = CGAffineTransformMakeScale(scale, scale);
            
            _headView.top = 0;
            _headView.bottom = -y + 150;
            
        }
    }
    else if (scrollView.tag == 19) {
        
        _indexImage = scrollView.contentOffset.x / kScreenWidth;
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
