//
//  ThirdViewController.m
//  Mars
//
//  Created by Macx on 16/2/20.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "SecondViewController.h"
#import "FirstCell.h"
#import "Cell2.h"
#import "Cell2Model.h"

CGFloat imageHeight = 150;
@interface  SecondViewController()
{
    UITableView *_tableView;
    UIImageView *_imgView;
    NSMutableArray *arr;
    UIActivityIndicatorView *_activityView;

}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self _createHeaderView];
    [self _createTableView];
    [self _requestData];

}

- (void)_requestData {
    arr = [NSMutableArray array] ;
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_activityView];
    _activityView.color = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem = item;
    [_activityView startAnimating];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://www.yohomars.com/api/v1/topic/topic/info?app_version=1.0.2&client_secret=058a233258670f4df0e414246bd7130e&client_type=iphone&id=61&os_version=9.2.1&screen_size=320x568&session_code=00ffc80f207f8153b7c0cea94759ce74&v=1"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data || error) {
            NSLog(@"mainViewCommentDataWithUrl中加载数据失败");
            return ;
        }
        
        NSError *jsonError = NULL;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        //                NSLog(@"dic = %@",dic);
        if (jsonError) {
            //            NSLog(@"jsonError = %@",jsonError);
            return;
        }
        
        if (dic) {

            NSString *url = [self imageUrlDeleteImageView:[dic[@"data"] objectForKey:@"cover"]];
//            NSLog(@"%@",url);
            [_imgView sd_setImageWithURL:[NSURL URLWithString:url]];
            NSArray *list = [dic[@"data"] objectForKey:@"stores"] ;
            
            if (list) {
                for (int i = 0; i < list.count; i++) {
                    Cell2Model *model = [[Cell2Model alloc] init];
                    model.img1 = [self imageUrlDeleteImageView:[list[i] objectForKey:@"icon"]];
                    
                    model.img2 = [self imageUrlDeleteImageView:[list[i] objectForKey:@"headpic"]];
                    model.title1 = [list[i] objectForKey:@"description"];
                    model.title = [list[i] objectForKey:@"store_english_name"];
                    NSLog(@"%@",model.title1);
                    NSArray *array = [list[i] objectForKey:@"pics"];
                    
                    if (array.count == 3) {
                        model.img3 = [self imageUrlDeleteImageView:[array[0] objectForKey:@"url"]];
                        model.img4 = [self imageUrlDeleteImageView:[array[1] objectForKey:@"url"]];
                        model.img5 = [self imageUrlDeleteImageView:[array[2] objectForKey:@"url"]];
                    }
                    
                    [arr addObject:model];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_tableView reloadData];
                    
                    NSLog(@"mainViewCommentDataWithUrl加载完数据刷新tableview");
                    [_activityView stopAnimating];
                });
            }
            
        }
    }];
    [task resume];
    
    

}
- (void)_createHeaderView
{
    //1、图片
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, imageHeight)];
    _imgView.backgroundColor = [UIColor clearColor];
//    [self.view insertSubview:_imgView belowSubview:_tableView];
    [self.view addSubview:_imgView];
    
    
}
- (void)_createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _tableView.separatorStyle = NO;

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerNib:[UINib nibWithNibName:@"FirstCell" bundle:nil] forCellReuseIdentifier:@"FirCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"Cell2" bundle:nil] forCellReuseIdentifier:@"identity12"];
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 150;
    }
    return 450;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        FirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    else {
    Cell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"identity12" forIndexPath:indexPath];
        cell.model = arr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    }
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //    NSLog(@"%lf", offsetY);
    if (offsetY > 0) { //向上滑动
        _imgView.top = -offsetY;
        
    }else{
        
        //1、计算图片增大之后的高度
        //ABS是取绝对值
        CGFloat height = ABS(offsetY) + imageHeight;
        //原宽度/ 原高度 = 放大宽度 / 放大高度
        CGFloat width = kScreenWidth / imageHeight * height;
        
        CGRect frame = CGRectMake(- (width - kScreenWidth) / 2, 0, width, height);
        
        _imgView.frame = frame;
    }
    
}


- (NSString *)imageUrlDeleteImageView:(NSString *)str {
    //取下来的网址是http://img01.yohomars.com/mars/2016/01/19/80d4ee3c3cbf6e8be71d7bab73dfe657.jpg?imageView/{mode}/w/{width}/h/{height}
    if (str.length == 0) {
        return @"";
    }
    
    if ([str rangeOfString:@"?imageView/{mode}/w/{width}/h/{height}"].location != NSNotFound) {
        
        NSString *strDelete = @"?imageView/{mode}/w/{width}/h/{height}";
        
        NSString *subStr = [str substringToIndex:str.length - strDelete.length];
        
        return subStr;
    }
    else {
        return str;
    }
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
