//
//  ViewController.m
//  NetworkDemo
//
//  Created by wossoneri on 16/7/5.
//  Copyright © 2016年 wossoneri. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"

@interface ViewController () <NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
{
    UIImageView *iv;
}
@end

@implementation ViewController

NS_ENUM(NSInteger, TagURLSessionType) {
    TagGet = 1,
    TagPost,
    TagDownload,
    TagAFNCreateDownload,
    TagAFNCreateDataTask,
    TagAFNCreateUpload
};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    iv = [[UIImageView alloc] init];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIButton *btnGet = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnGet setTitle:@"GET" forState:UIControlStateNormal];
    [btnGet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnGet addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnGet.backgroundColor = [UIColor orangeColor];
    btnGet.tag = TagGet;
    
    UIButton *btnPost = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPost setTitle:@"POST" forState:UIControlStateNormal];
    [btnPost setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnPost addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnPost.backgroundColor = [UIColor orangeColor];
    btnPost.tag = TagPost;
    
    UIButton *btnDownload = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDownload setTitle:@"DOWNLOAD" forState:UIControlStateNormal];
    [btnDownload setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDownload addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnDownload.backgroundColor = [UIColor orangeColor];
    btnDownload.tag = TagDownload;
    
    UIButton *btnAFNDownload = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAFNDownload setTitle:@"AFN_DOWNLOAD" forState:UIControlStateNormal];
    [btnAFNDownload setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnAFNDownload addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnAFNDownload.backgroundColor = [UIColor orangeColor];
    btnAFNDownload.tag = TagAFNCreateDownload;
    
    UIButton *btnAFNDataTask = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAFNDataTask setTitle:@"AFN_DATATASK" forState:UIControlStateNormal];
    [btnAFNDataTask setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnAFNDataTask addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnAFNDataTask.backgroundColor = [UIColor orangeColor];
    btnAFNDataTask.tag = TagAFNCreateDataTask;

    UIButton *btnAFNUpload = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAFNUpload setTitle:@"AFN_DATATASK" forState:UIControlStateNormal];
    [btnAFNUpload setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnAFNUpload addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnAFNUpload.backgroundColor = [UIColor orangeColor];
    btnAFNUpload.tag = TagAFNCreateUpload;

    
    
    [self.view addSubview:btnGet];
    [self.view addSubview:btnPost];
    [self.view addSubview:btnDownload];
    [self.view addSubview:btnAFNDownload];
    [self.view addSubview:btnAFNDataTask];
    [self.view addSubview:btnAFNUpload];
    

    
    [btnGet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view.mas_top).offset(30);
        make.width.mas_equalTo(@160);
    }];
    
    [btnPost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(btnGet.mas_top);
        make.width.mas_equalTo(@160);
    }];

    [btnDownload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnGet);
        make.top.equalTo(btnGet.mas_bottom).offset(20);
        make.width.mas_equalTo(@160);
    }];
    
    
    [btnAFNDownload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnGet.mas_left);
        make.top.equalTo(btnDownload.mas_bottom).offset(30);
        make.width.mas_equalTo(@160);
    }];
    
    [btnAFNDataTask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnPost);
        make.top.equalTo(btnAFNDownload);
        make.width.mas_equalTo(@160);
    }];
    
    [btnAFNUpload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnAFNDownload);
        make.top.equalTo(btnAFNDownload.mas_bottom).offset(20);
        make.width.mas_equalTo(@160);
    }];
    
    [self.view addSubview:iv];
    [self.view bringSubviewToFront:iv];
    
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.width.mas_equalTo(@150);
        make.height.mas_equalTo(@150);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onBtnClicked:(id)button
{
    UIButton *btn = (UIButton *)button;
    switch (btn.tag) {
            
        case TagGet: {
            NSURL *url = [NSURL URLWithString:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?date=20131129&startRecord=1&len=5&udid=1234567890&terminalType=Iphone&cid=213"];
            
            NSURLSession *session = [NSURLSession sharedSession];
            
            //如果请求的数据比较简单,也不需要对返回的数据做一些复杂的操作.那么我们可以使用带block
            NSURLSessionTask *task = [session dataTaskWithURL:url
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                
                                                NSError *newError = nil;
                                                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&newError];
                                                
                                                NSArray *array = dictionary[@"news"];
                                                NSDictionary *dic = array[0];
                                                NSLog(@"%@", dic[@"title"]);
                                            }];
            
            
            [task resume];//所有类型task都要调用resume才会开始请求

        }            
            break;
            
        case TagPost: {
            //POST和GET的区别就在于request,所以使用session的POST请求和GET过程是一样的,区别就在于对request的处理.
            //post会将请求参数以请求体的形式存储起来，在向服务器发送请求时，我们不会看到里面的具体参数，例如当我们填写私密表单，或者登录什么账号的时候，自然是不希望别人能看到我们的账号密码，所以这时候采用post请求更为安全。
            
            NSURL *url = [NSURL URLWithString:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?"];
            //除了get请求可以使用NSUrlRequest之外，其他请求必须使用NSMutableURLRequset，明确的指定当前的HTTPMethod是什么请求。
            //封装请求
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            //请求方式
            request.HTTPMethod = @"POST";
            //请求体
            NSData *data = [@"date=20131129&startRecord=1&len=5&udid=1234567890&terminalType=Iphone&cid=213" dataUsingEncoding:NSUTF8StringEncoding];
            request.HTTPBody = data;
            
            //发送请求
            NSURLSession *session = [NSURLSession sharedSession];
            
            //由于要先对request进行处理，通过request初始化task
            NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
               
                NSError *newError = nil;
                // 获取数据
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&newError];
                
                
                NSArray *array = dict[@"news"];
                NSDictionary *dic = array[0];
                NSLog(@"%@", dic[@"title"]);

            }];
            
            [task resume];
        }
            
            break;
            
        case TagDownload: {
            NSURLSession *session = [NSURLSession sharedSession];
            NSURL *url = [NSURL URLWithString:@"http://blog.jobbole.com/wp-content/themes/jobboleblogv3/_assets/img/jobbole-logo.png"];
            NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                // location是沙盒中tmp文件夹下的一个临时url,文件下载后会存到这个位置,由于tmp中的文件随时可能被删除,所以我们需要自己需要把下载的文件挪到需要的地方
                NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
                //剪切文件
                [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:nil];
                
            }];
            
            [task resume];
        }
            
            break;
            
        case TagAFNCreateDownload: {
            //1.默认的default....Configuration是指的什么:是一个新创建的对象。这个
            NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            
            //2.创建AFmanager
            AFURLSessionManager * manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
            
            //3.创建URL
            NSString * urlStr = @"http://192.168.1.110/~wossoneri/pay.png";
            urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *URL = [NSURL URLWithString:urlStr];
            
            //4.创建申请
            NSURLRequest * requese = [NSURLRequest requestWithURL:URL];
            //5.创建下载任务
            NSURLSessionDownloadTask * downloadTask = [manager downloadTaskWithRequest:requese progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                // 这里直接设置下载的文件路径，很方便
                //5.1 获取到文件路径
                NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                //5.2 返回文件绝对路径
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                //下载结束后，文件就保存到了上面设置的路径里面.
                NSLog(@"File download to:%@",filePath);
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@""];
                NSLog(@"do ==%@",documentsDirectory);
                NSString *URLImg = [documentsDirectory stringByAppendingPathComponent:@"pay.png"];
                
                NSLog(@"==%@",URLImg);
                UIImage *imgAvtar = [UIImage imageWithContentsOfFile:URLImg];
                // 新路径前面少了 file://
                
                iv.image = imgAvtar;
            }];
            
            //6.开始任务
            [downloadTask resume];
        }
            break;
            
        case TagAFNCreateDataTask: {
            
            NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager * manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
            
            NSURL * URL = [NSURL URLWithString:@"http://192.168.1.110/~wossoneri/sample.json"];
            NSURLRequest * request = [NSURLRequest requestWithURL:URL];
            
            NSURLSessionDataTask * dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error: %@",error);
                }
                else
                {
                    NSLog(@"%@ \n %@",response,responseObject);
                }
            }];
            
            [dataTask resume];
        }
            break;
            
        case TagAFNCreateUpload: {
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            // fix  Request failed: unacceptable content-type: text/html
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSURL *URL = [NSURL URLWithString:@"http://192.168.1.110/~wossoneri/upload"];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@""];
            NSLog(@"do ==%@",documentsDirectory);
            NSString *URLImg = [documentsDirectory stringByAppendingPathComponent:@"pay.png"];
            URLImg = [@"file://" stringByAppendingString:URLImg];
            
            NSURL *filePath = [NSURL fileURLWithPath:URLImg];
            NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"Success: %@  \n %@", response, responseObject);
                }
            }];
            [uploadTask resume];
        }
            break;
            
    }
}


#pragma mark - NSURLSessionDataDelegate
// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
    NSLog(@"did receive response");
}

// 2.接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    //处理每次接收的数据
    NSLog(@"did receive data");
}

// 3.请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //请求完成 成功或者失败的处理
    NSLog(@"complete with error: %@", error);
}


#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // 可在这里通过已写入的长度和总长度算出下载进度
    CGFloat progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"progress %f",progress);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"did finish download");
    // location还是一个临时路径,需要自己挪到需要的路径(caches下面)
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
}




@end
