//
//  ViewController.m
//  DYImageCache
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 TOPRAND. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+DYImageViewCache.h"


#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIImageView *photoImageView1;
@property (nonatomic, strong) UIProgressView *progressView1;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIButton *buttonLoad;

@end

@implementation ViewController

- (void) initData{
    
    self.dataArray = @[@"http://img15.3lian.com/2015/f2/50/d/70.jpg",
                       @"http://img04.tooopen.com/images/20130204/tooopen_22285818.jpg",
                       @"http://picapi.ooopic.com/10/51/81/77b1OOOPICe7.jpg",
                       @"http://www.16sucai.com/uploadfile/2012/0722/20120722010004359.jpg",
                       @"http://sc.jb51.net/uploads/allimg/130716/2-130G61S233G3.jpg",
                       @"http://c.hiphotos.baidu.com/image/pic/item/242dd42a2834349b49f953d4cbea15ce37d3bee7.jpg"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor orangeColor];
//    self.tableView = [[UITableView alloc]init];
//    self.tableView.frame = self.view.bounds;
//    self.tableView.backgroundColor = [UIColor orangeColor];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.rowHeight = 300;
//    [self.view addSubview:self.tableView];
    [self createUI];
}

- (void) createUI{
    
    self.photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 20, SCREENWIDTH - 100, 200 )];
    self.photoImageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.photoImageView];
    
    
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(10,(self.photoImageView.frame.size.height - 20 ) / 2, self.photoImageView.frame.size.width - 20, 20)];
    //已下载进度的颜色
    self.progressView.progressTintColor = [UIColor greenColor];
    self.progressView.trackTintColor = [UIColor blackColor];
    self.progressView.backgroundColor  = [UIColor clearColor];
    [self.photoImageView addSubview:self.progressView];
    
    
    
    self.photoImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(50, 240, SCREENWIDTH - 100, 200 )];
    self.photoImageView1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.photoImageView1];
    
    
    self.progressView1 = [[UIProgressView alloc]initWithFrame:CGRectMake(10,(self.photoImageView.frame.size.height - 20 ) / 2, self.photoImageView.frame.size.width - 20, 20)];
    //已下载进度的颜色
    self.progressView1.progressTintColor = [UIColor greenColor];
    self.progressView1.trackTintColor = [UIColor blackColor];
    self.progressView1.backgroundColor  = [UIColor clearColor];
    [self.photoImageView1 addSubview:self.progressView1];
    
    
    self.buttonLoad = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.buttonLoad.frame = CGRectMake((SCREENWIDTH - 100)/ 2, SCREENHEIGHT - 80, 100, 50);
    self.buttonLoad.backgroundColor = [UIColor orangeColor];
    [self.buttonLoad setTitle:@"下载" forState:0];
    [self.buttonLoad setTitleColor:[UIColor blueColor] forState:0];
    [self.buttonLoad addTarget:self action:@selector(loadAction:) forControlEvents:1 <<  6];
    [self.view addSubview:self.buttonLoad];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellidentify = @"CellID";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentify];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellidentify];
    }
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    [self loadCellImageWithCell:cell withIndex:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (void) loadCellImageWithCell:(UITableViewCell *)cell withIndex:(NSIndexPath *)indexPath{
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 10, SCREENWIDTH, 280);
    [cell addSubview:imageView];
    
    UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(10,(imageView.frame.size.height - 20 ) / 2, imageView.frame.size.width -20, 20)];
    //已下载进度的颜色
    progressView.progressTintColor = [UIColor greenColor];
    progressView.trackTintColor = [UIColor blackColor];
    progressView.backgroundColor  = [UIColor clearColor];
    [imageView addSubview:progressView];
    
    
    [imageView dy_setImageWithUrl:self.dataArray[indexPath.row] progressBlock:^(NSInteger alreadyDownloadSize,NSInteger expectedContentLength){
        
        progressView.progress = alreadyDownloadSize / expectedContentLength;
    } complect:^(NSData *data,UIImage *image,NSError *error,BOOL finished){
        
        imageView.image = image;
        progressView.hidden = YES;
    }];

}


- (void) loadAction:(UIButton *)button{
    
    [self.photoImageView dy_setImageWithUrl:self.dataArray[0] progressBlock:^(NSInteger alreadyDownloadSize,NSInteger expectedContentLength){
//        NSLog(@"----->%ld",(long)alreadyDownloadSize);
        self.progressView.progress = alreadyDownloadSize / expectedContentLength;
    } complect:^(NSData *data,UIImage *image,NSError *error,BOOL finished){
    
        self.photoImageView.image = image;
        self.progressView.hidden = YES;
    }];
    
    [self.photoImageView1 dy_setImageWithUrl:self.dataArray[2] progressBlock:^(NSInteger alreadyDownloadSize,NSInteger expectedContentLength){
//        NSLog(@"----->%ld",(long)alreadyDownloadSize);
        self.progressView1.progress = alreadyDownloadSize / expectedContentLength;
    } complect:^(NSData *data,UIImage *image,NSError *error,BOOL finished){
        
        self.photoImageView1.image = image;
        self.progressView1.hidden = YES;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
