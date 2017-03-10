//
//  SQMultiDownloadController.m
//  SQDownloadDemo
//
//  Created by qbshen on 2017/1/19.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import "SQMultiDownloadController.h"
#import "SQEntityModel.h"
#import "SQDownloadManager.h"

@interface SQMultiDownloadController ()

@property (nonatomic) NSMutableArray<SQEntityModel*> * entityModels;
@property (nonatomic, copy) void(^backCompletionHandler)();
@end

@implementation SQMultiDownloadController

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
        
    });
    return sharedManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetData)];
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[SQDownloadManager sharedInstance] cancelAllDownloadsAndRemoveFiles:NO];
}

-(void)loadData
{
    
    if(!self.entityModels){
        self.entityModels = [NSMutableArray new];
    }
    for (NSString* downUrl in [self downUrls]) {
        SQEntityModel * model = [SQEntityModel new];
        model.uuid = [NSString stringWithFormat:@"%d",(int)[[self downUrls] indexOfObject:downUrl]];
        model.downloadUrl = downUrl;
        model.status = SQDownloadStatusUNKnow;
        model.progressL = [self progressL];
        model.descr = @"开始";
        [self.entityModels addObject:model];
    }
    [SQDownloadManager sharedInstance];
    [self.tableView reloadData];
}

-(NSString*)timeUUID
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    return  [NSString stringWithFormat:@"%.0f",time];
}


-(UILabel*)progressL
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 24)];
    label.textColor = [UIColor blackColor];
    return label;
}
-(NSArray*)downUrls
{
    return @[
             @"http://sw.bos.baidu.com/sw-search-sp/software/797b4439e2551/QQ_mac_5.0.2.dmg",
//             @"http://mediags.download.vr.moguv.com/20161205/0841ac674aa747669858cb263e3782b8/0841ac674aa747669858cb263e3782b8_sphere2kTV.ts?token=ba9fc79bdca1236a5c4ef31b7893b685&ts=1485060981542",
             @"http://mediags.download.vr.moguv.com/20161224/5f61e4302e744985aeaf2752730aa2c2/5f61e4302e744985aeaf2752730aa2c2_oct2kTV.ts?token=d6b9999d3d4c6de90ed54965e0a631a2&ts=1484820737748",
//             @"http://mediags.download.vr.moguv.com/20170116/f91c7887f37a4ab8a7539a16b20ee19d/f91c7887f37a4ab8a7539a16b20ee19d_oct2kTV.ts?token=2fe561e2ef54cc4db9082e869acb7345&ts=1484820880036",
             @"http://mediags.download.vr.moguv.com/20161219/acfcf992c066490c94bcf4565f7501b0/acfcf992c066490c94bcf4565f7501b0_oct2kTV.ts?token=3860504f5847a176623ebad39107517d&ts=1484820933261",
//             @"http://mediags.download.vr.moguv.com/20170105/68ea08ca5b94437f961faae90519648a/68ea08ca5b94437f961faae90519648a_oct2kTV.ts?token=b2918a771b82d6c51a751269953332c7&ts=1484825576484",
//             @"http://mediags.download.vr.moguv.com/20170110/2bb51b3019664c24abdfe1c783092f66/2bb51b3019664c24abdfe1c783092f66_oct2kTV.ts?token=62a2a341f560d70e86190f1f61292367&ts=1484825582205",
//             @"http://mediags.download.vr.moguv.com/20170105/1d912bd35cb745e08b902413cd3d8035/1d912bd35cb745e08b902413cd3d8035_oct2kTV.ts?token=4c596cfe634257f13ca839bcc092aaf8&ts=1484825585636",
//             @"http://mediags.download.vr.moguv.com/20170105/d3bf681ee96a4db1bbd1f8f63e99c553/d3bf681ee96a4db1bbd1f8f63e99c553_oct2kTV.ts?token=8d1b65dc7f4ed35976b5a2b27ee0e492&ts=1484825589873",
             ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.entityModels.count;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SQEntityModel * entityModel = self.entityModels[indexPath.row];
    if (UITableViewCellEditingStyleDelete) {
        [self deleteWithModel:entityModel];
        [self.entityModels removeObject:entityModel];
        [self.tableView reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
        
    }
    SQEntityModel * entityModel = self.entityModels[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"          ."];
    [entityModel.progressL removeFromSuperview];
    [cell addSubview:entityModel.progressL];
    entityModel.progressL.text = entityModel.descr;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SQEntityModel * entityModel = self.entityModels[indexPath.row];
    switch (entityModel.status) {
        case SQDownloadStatusDownloading:
        case SQDownloadStatusReady:
            [self pauseDownload:entityModel];
            break;
        case SQDownloadStatusFail:
            [self startDownload:entityModel];
            break;
        case SQDownloadStatusPause:
            [self startDownload:entityModel];
            break;
        case SQDownloadStatusUNKnow:
            [self startDownload:entityModel];
            break;
        default:
            
            break;
    }
    
}

-(void)startDownload:(SQEntityModel * )entityModel
{
    for (SQEntityModel* model in self.entityModels) {
        if (model.downloader && model.status == SQDownloadStatusDownloading) {
            [self pauseDownload:model];
        }
    }
    __weak typeof(self) weakSelf = self;
    entityModel.status = SQDownloadStatusReady;
    entityModel.progressL.text = @"ready";
//    [self.tableView reloadData];
    
    static dispatch_once_t onceToken;
    NSString* fileDir = [entityModel pathToFile];
    NSLog(@"fileDir:%@",fileDir);
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileDir]) {
        /** 创建 */
        NSError *error2;
        BOOL createSuc2 = [[NSFileManager defaultManager] createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:&error2];
        if (!createSuc2) {
            NSLog(@"创建失败:%@", error2);
        }
    }

    NSString* fileName = [NSString stringWithFormat:@"%@.ts",entityModel.uuid];
    SQDownload * download = [[SQDownloadManager sharedInstance] downloadFileAtURL:[NSURL URLWithString:entityModel.downloadUrl] toDirectory:[NSURL URLWithString:entityModel.pathToFile] withName:fileName progression:^(float progress, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        [weakSelf progressBlock:entityModel progress:progress onceToken:&onceToken];
    } completion:^(NSError * _Nullable error, NSURL * _Nullable location) {
        NSLog(@"error: %@\n location: %@",error.description ,location.absoluteString);
        if (!error) {
            entityModel.progressL.text = @"完成";
            entityModel.status = SQDownloadStatusDown;
            [weakSelf startNextDown];
//            [weakSelf.tableView reloadData];
        }else{
            if (error.code == 2) {
                entityModel.restart = YES;
            }else{
                entityModel.restart = NO;
            }
            entityModel.status = SQDownloadStatusFail;
            entityModel.progressL.text = @"下载失败";
//            [weakSelf.tableView reloadData];
        }
    } isReStart:entityModel.restart];
    entityModel.downloader = download;
}

-(void)startNextDown
{
    for (SQEntityModel* model in self.entityModels) {
        if (!model.downloader&&model.status != SQDownloadStatusDown) {
            [self startDownload:model];
            break;
        }
    }
}

-(void)progressBlock:(SQEntityModel * )entityModel progress:(CGFloat)progress onceToken:(dispatch_once_t*)onceToken
{
    NSLog(@"taskIdentifier:%ld progress:%f",entityModel.downloader.downloadTask.taskIdentifier,progress);
    if (entityModel.status == SQDownloadStatusPause) {
        
    }else if (entityModel.status == SQDownloadStatusReady || entityModel.status == SQDownloadStatusDownloading){
        entityModel.progress = progress;
        entityModel.status = SQDownloadStatusDownloading;
        //    entityModel.descr = @"下载中...";
        entityModel.progressL.text = [NSString stringWithFormat:@"%f%@",entityModel.progress*100,@"%"];
        
//        __weak typeof(self) weakSelf = self;
//        dispatch_once(onceToken, ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //            [weakSelf.tableView reloadData];
//            });
//        });
    }
}

-(void)pauseDownload:(SQEntityModel * )entityModel
{
    [[SQDownloadManager sharedInstance] cancelDownload:entityModel.downloader WithResumeData:^(NSData * _Nullable resumeData) {
        NSLog(@"cancel withResumeData");
    }];
//    [entityModel.downloader cancelWithResumeData:^(NSData * _Nullable resumeData) {

//    }];
    entityModel.progressL.text = @"暂停";
    entityModel.status = SQDownloadStatusPause;
    entityModel.downloader = nil;
//    [self.tableView reloadData];
}

-(void)continueDownload:(SQEntityModel * )entityModel
{
    [[SQDownloadManager sharedInstance] resumeDownload:entityModel.downloader];
    entityModel.progressL.text = @"ready";
    entityModel.status = SQDownloadStatusReady;
//    [self.tableView reloadData];

}

- (void)deleteWithModel:(SQEntityModel * )entityModel
{
    NSError * error;
    [[NSFileManager defaultManager] removeItemAtPath:entityModel.pathToFile error:&error];
    NSLog(@"del file error: %@",error.description);
}


-(void)resetData
{
    for (SQEntityModel * model in self.entityModels) {
        [model.progressL removeFromSuperview];
        [model.downloader cancel];
    }
    [self.entityModels removeAllObjects];
    self.entityModels = nil;
    [self loadData];
}

@end
