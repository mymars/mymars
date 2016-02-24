//
//  SettingViewController.m
//  Mars
//
//  Created by wiseyep on 16/2/19.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign,nonatomic) CGFloat memor;
@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    UINib *nib = [UINib nibWithNibName:@"SettingTableViewCell" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib forCellReuseIdentifier:@"SCell"];
    
    [self canculateMemory];
    
    for (UIView *view in self.view.subviews) {
        if ([view isMemberOfClass:[BottomGrayView class]]) {
            [view removeFromSuperview];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}



#pragma mark - 计算缓存
- (void)canculateMemory
{
    //计算缓存
    //获取缓存文件夹路径
    NSString *homePath = NSHomeDirectory();
    /*
     /Users/wiseyep/Library/Developer/CoreSimulator/Devices/BD3101F1-87F9-42C1-A3F2-FEE8405F7C9B/data/Containers/Data/Application/A0A4AE3F-D197-473E-912E-E9E92AA77CEF
     */
    //拼接路径
    NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/default/com.hackemist.SDWebImageCache.default",homePath];
    //文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    //文件名
    NSArray *fileNames = [manager subpathsOfDirectoryAtPath:filePath error:nil];
    
    long long size = 0;
    for (NSString *fileName in fileNames)
    {
        //拼接获取文件路径
        NSString *subFilePath = [NSString stringWithFormat:@"%@/%@",filePath,fileName];
        //获取文件信息
        NSDictionary *fileDic = [manager attributesOfItemAtPath:subFilePath error:nil];
        //获取单个文件的大小
        NSNumber *sizeNum = fileDic[NSFileSize];
        long long subFileSize = [sizeNum longLongValue];
        size += subFileSize;
    }
    _memor = size/1024.0/1024;
    [_tableView reloadData];
    
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = @[@"消息推送",@"关于MARS",@"清理缓存",@"意见反馈",@"使用协议条款",@"隐私条款",@"更多应用"];
   
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCell" forIndexPath:indexPath];
    cell = [cell initWithType:array[indexPath.row] memory:_memor indexRow:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中单元格事件
    if (indexPath.row == 2)
    {
        //清理缓存
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否清理缓存" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //取消
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //清理缓存
            //获取缓存文件夹路径
            NSString *homePath = NSHomeDirectory();
            /*
             /Users/wiseyep/Library/Developer/CoreSimulator/Devices/BD3101F1-87F9-42C1-A3F2-FEE8405F7C9B/data/Containers/Data/Application/A0A4AE3F-D197-473E-912E-E9E92AA77CEF
             */
            //拼接路径
            NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/default/com.hackemist.SDWebImageCache.default",homePath];
            //文件管理对象
            NSFileManager *manager = [NSFileManager defaultManager];
            //文件名
            NSArray *fileNames = [manager subpathsOfDirectoryAtPath:filePath error:nil];
            
            for (NSString *fileName in fileNames)
            {
                //拼接获取文件路径
                NSString *subFilePath = [NSString stringWithFormat:@"%@/%@",filePath,fileName];
                [manager removeItemAtPath:subFilePath error:nil];
            }
            __weak typeof(self) weakSelf = self;
            [weakSelf canculateMemory];
        }];
        
        [alertCon addAction:cancelAction];
        [alertCon addAction:otherAction];
        
        [self presentViewController:alertCon animated:YES completion:nil];
    }
}


- (IBAction)exitAction:(UIButton *)sender
{
    //退出登录
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
