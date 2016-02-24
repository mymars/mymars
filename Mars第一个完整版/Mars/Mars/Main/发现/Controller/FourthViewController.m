//
//  FourthViewController.m
//  Mars
//
//  Created by Macx on 16/2/20.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "FourthViewController.h"
#import "Cell4.h"
#import "Cell5.h"
#import "Cell4Model.h"
CGFloat imageHeight2 = 150;

@interface FourthViewController ()
{
    UITableView *_tableView;
    UIImageView *_imgView;
    NSMutableArray *arr;
    UIScrollView *_scrollView;
}
@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self _createTableView];

    [self _createHeaderView];
    [self _requestData];
     self.tabBarController.tabBar.hidden = YES;
}


- (void)_requestData {
    arr = [NSMutableArray array] ;

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://www.yohomars.com/api/v1/line/line/info?app_version=1.0.2&client_secret=35a8745c0597c6c2afaccaf7b78069bc&client_type=iphone&id=74&os_version=9.2.1&screen_size=320x568&session_code=00ffc80ffb9a8a667b8f3428be78e93c&v=1"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
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
            
            NSString *url = [self imageUrlDeleteImageView:[dic[@"data"] objectForKey:@"line_pic"]];
            //            NSLog(@"%@",url);
            [_imgView sd_setImageWithURL:[NSURL URLWithString:url]];
            
            NSArray *list = [dic[@"data"] objectForKey:@"stores"] ;
            
            if (list) {
                for (int i = 0; i < list.count; i++) {
                    Cell4Model *model = [[Cell4Model alloc] init];
//                    model.img1 = [self imageUrlDeleteImageView:[list[i] objectForKey:@"icon"]];
                    
                    model.img1 = [self imageUrlDeleteImageView:[list[i] objectForKey:@"headpic"]];
//                    model.title1 = [list[i] objectForKey:@"description"];
                    model.title = [list[i] objectForKey:@"store_english_name"];
                    NSLog(@"%@",model.title);
                    NSArray *array = [list[i] objectForKey:@"pics"];
                    
                    if (array.count == 3) {
                        model.img2 = [self imageUrlDeleteImageView:[array[0] objectForKey:@"url"]];
                        model.img3 = [self imageUrlDeleteImageView:[array[1] objectForKey:@"url"]];
                        model.img4 = [self imageUrlDeleteImageView:[array[2] objectForKey:@"url"]];
                    }
                    
                    [arr addObject:model];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
             
                    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                        // 进入刷新状态后会自动调用这个block
                        [_tableView reloadData];
                        [self performSelector:@selector(_delay) withObject:nil afterDelay:1];
                    }];
                    
                    [_tableView.mj_header beginRefreshing];
           
                    
                    NSLog(@"mainViewCommentDataWithUrl加载完数据刷新tableview");

                });
            }
            
        }
    }];
    [task resume];
    
    
    
}

- (void)_delay {
    [_tableView.mj_header endRefreshing];
}

- (void)_createHeaderView
{
    //1、图片
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, imageHeight2)];
    _scrollView.contentSize = CGSizeMake(330, 150);
    [self.view addSubview:_scrollView];
   
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.maximumZoomScale = 3.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.delegate = self;
   
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, imageHeight2)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;

    [_scrollView addSubview:_imgView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 2;
   
    _imgView.userInteractionEnabled = YES;
    
    [_imgView addGestureRecognizer:tap];
   
}


-(void)tap:(UITapGestureRecognizer *)tap
{
    if (_scrollView.zoomScale > 1) {
        [_scrollView setZoomScale:1 animated:YES];
    }else{
        [_scrollView setZoomScale:3 animated:YES];
    }
}

- (void)_createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _tableView.separatorStyle = NO;

    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerNib:[UINib nibWithNibName:@"Cell4" bundle:nil] forCellReuseIdentifier:@"identity14"];
    [_tableView registerNib:[UINib nibWithNibName:@"Cell5" bundle:nil] forCellReuseIdentifier:@"identity15"];
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
    return 250;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        Cell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"identity14" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    else {
        Cell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"identity15" forIndexPath:indexPath];
        cell.model = arr[indexPath.row];
        cell.label1.text = [NSString stringWithFormat:@"%lu",indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"%@",cell.label1.text);
        return cell;
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imgView;
}
#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //    NSLog(@"%lf", offsetY);
    if (offsetY < 0) { //向上滑动
        _scrollView.top = -offsetY;
    
    }else {
        _scrollView.top = 0;
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
