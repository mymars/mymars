//
//  HomeViewController.m
//  Mars
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
#import "ToplistModel.h"
#import "BizareaModel.h"
#import "BizareaView.h"

static NSString *bizareaIdentify = @"bizarea";
static NSString *commentIdentify = @"comment";

@interface HomeViewController () <NSURLSessionDownloadDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy)NSMutableArray *topicModelArr;
@property (nonatomic,copy)NSMutableArray *bizareaModelArr;
@property (nonatomic,copy)NSMutableArray *commentModelArr;


@end

@implementation HomeViewController


/**
 *  主页面中scrollview的图片加载完毕后,应当将图片存起来,下次从下方拖动回第一行时再次加载回来,现在有个问题就是页面拉下去拉回来后,原来加载的图片没有了
 *
 *  @param storeID <#storeID description#>
 *
 *  @return <#return value description#>
 */

- (NSString *)clientSecret:(NSString *)storeID {
    
    NSDictionary *dicConfig = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ClientSecretShangHai.plist" ofType:nil]];
    
    NSString *str = dicConfig[storeID];
    
    if (str.length == 0) {
        NSLog(@"出现了未知storeid以及对应密码");
    }
    
    return str.length > 0 ? str : nil;
}

- (void)postRequest:(NSString *)urlString {
    
    //获取_scrollview上的专题列表data
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    
    [task resume];
    
}

#pragma mark - CreateView

- (void)_createTableView {

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.tabBarController.tabBar.height)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bizareaIdentify];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commentIdentify];
    
    [self.view addSubview:tableView];
    

}

- (void)_createScrollView:(UIView *)superView {

    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 80)];
    
    CGFloat imageViewWidth = kScreenWidth - 100;
    CGFloat spaceWidth = 10;                        //间隔宽度
    
    _scrollView.contentSize = CGSizeMake(imageViewWidth * 6 + spaceWidth * 7, 0);
    
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [superView addSubview:_scrollView];
    
    for (int i = 0; i < 6; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewWidth * i + spaceWidth * (i + 1), 0, imageViewWidth, 80)];
        
        imageView.backgroundColor = [UIColor redColor];
        
        imageView.tag = 100 + i;
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        
        [imageView addGestureRecognizer:tap];
        
        [_scrollView addSubview:imageView];
        
    }


}

- (void)_createLookView:(UIView *)superView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    imageView.image = [UIImage imageNamed:@"FOCUS.png"];
    
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 40)];
    
    label.text = @"随便看看";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    
    [view addSubview:label];
    
    [superView addSubview:view];
}

- (void)_createBizareaView:(UIView *)superView withBizareaModel:(BizareaModel *)model {

    BizareaView *bizareaView = [[NSBundle mainBundle] loadNibNamed:@"Bizarea" owner:self options:nil].lastObject;
    
    bizareaView.frame = CGRectMake(10, 0, kScreenWidth - 20, 340);
    
    [superView addSubview:bizareaView];
    
    bizareaView.bizareaModel = model;
}

#pragma mark - Action

- (void)tapAction:(UITapGestureRecognizer *)tap {

    for (int i = 0; i < 6; i++) {
        
        UIImageView *imageView = [self.view viewWithTag:100 + i];
        
        CGPoint point = [tap locationInView:imageView];
        
        if (point.x >= 0 && point.x <= imageView.bounds.size.width) {
            NSLog(@"%d",i);
            
            if (_topicModelArr.count == 0) {
                
            }
            else {
            
                NSString *storeID = ((ToplistModel *)_topicModelArr[i]).storeID;
                
                NSString *urlString = [NSString stringWithFormat:@"http://www.yohomars.com/api/v1/topic/topic/info?app_version=1.0.2&client_secret=%@&client_type=iphone&id=%@&os_version=9.2&screen_size=320x480&session_code=010024f1fd91db5ddbccabbcdfc5cf41&v=1", [self clientSecret:storeID], storeID];
            
                [self postRequest:urlString];
                
                NSLog(@"%@",urlString);

            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createTableView];
    
    if (_bizareaModelArr == nil) {
        _bizareaModelArr = [NSMutableArray array];
        _topicModelArr = [NSMutableArray array];
    }
    
    for (int i = 0; i < 3; i++) {
        BizareaModel *model = [[BizareaModel alloc] init];
        [_bizareaModelArr addObject:model];
    }

    _commentModelArr = @[@"a",@"b",@1,@1,@1];

    [self postRequest:@"http://www.yohomars.com/api/v1/topic/topics/topiclist?app_version=1.0.2&city_id=890&client_secret=6ab317809518b7487405ae896c29d4a9&client_type=iphone&limit=6&os_version=9.2&page=1&rand=1&screen_size=320x480&session_code=010024f1937d789cdcc03e7ada750070&v=1"];
}

#pragma mark -NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {

}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    //这里遇到了一个问题:json中包含\r\n,这应该被替换掉,还有@"👀"这个也要被替换
    if (data) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"str = %@",str);
        str = [str stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"ArthurChangeLine1106"];
        data = [str dataUsingEncoding:NSUTF8StringEncoding];
    }
//    str = [str stringByReplacingOccurrencesOfString:@"👀" withString:@"ArthurChangeline1105"];
//
//    str = [str stringByReplacingOccurrencesOfString:@"*" withString:@"ArthurChangeLine1104"];
//    NSLog(@"---%@",str);
//    NSLog(@"data = %@",data);
    
//    NSLog(@"data=%@",data);
    NSError *jsonError = NULL;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves error:&jsonError];
    
    if (jsonError) {
    
        NSLog(@"jsonError=%@", jsonError);
//        NSLog(@"--%@,%ld",str,str.length);
    }
    else {
//        NSLog(@"dic = %@",dic);
    }
    if (dic) {
        NSArray *list = [dic[@"data"] objectForKey:@"list"];
        if (list) {
            
            for (int i = 0; i < 6; i++) {
                NSLog(@"%@",[list[i] objectForKey:@"id"]);
                NSString *str = [list[i] objectForKey:@"cover"];
//取下来的网址是http://img01.yohomars.com/mars/2016/01/19/80d4ee3c3cbf6e8be71d7bab73dfe657.jpg?imageView/{mode}/w/{width}/h/{height},必须除掉imageview开始的字符串才能作为url访问
                NSString *strDelete = @"?imageView/{mode}/w/{width}/h/{height}";
                
                NSString *subStr = [str substringToIndex:str.length - strDelete.length];
                
                ToplistModel *model = [[ToplistModel alloc] init];
                
                model.storeID = [list[i] objectForKey:@"id"];
                model.cover = subStr;
                
                [_topicModelArr addObject:model];
                
                NSURL *url = [NSURL URLWithString:subStr];
                
                [((UIImageView *)[self.view viewWithTag:100 + i]) sd_setImageWithURL:url];
            }
        }
    }
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//一个scrollview,一个eyeicon
    return 1 + 1 + _bizareaModelArr.count + _commentModelArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        
        [self _createScrollView:cell.contentView];
        
        cell.backgroundColor = [UIColor clearColor];
     
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self _createLookView:cell.contentView];
        
        return cell;
    }
    if (indexPath.row > 1 && indexPath.row <= _bizareaModelArr.count + 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bizareaIdentify forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self _createBizareaView:cell.contentView withBizareaModel:_bizareaModelArr[indexPath.row - 2]];
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return 100;
    }
    if (indexPath.row == 1) {
        return 40;
    }
    if (indexPath.row > 1 && indexPath.row <= _bizareaModelArr.count + 1) {
        return 350;
    }
    return 100;
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
