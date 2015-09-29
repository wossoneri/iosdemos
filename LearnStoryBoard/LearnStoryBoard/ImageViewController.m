//
//  ImageViewController.m
//  LearnStoryBoard
//
//  Created by mythware on 6/23/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController
	
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UIImage *currentImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageName]];
//    self.imageView.image = currentImage;
    
//    if(! _imageView)
//        _imageView = [[UIImageView alloc]init];
//    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
//    [self.imageView sizeToFit];
//    [self.view addSubview:self.imageView];
    [self.scrollView addSubview:self.imageView];
}

-(void)setImageURL:(NSURL *)imageURL{
    _imageURL = imageURL;
//    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
    [self startDownloadingImage];
}

-(void)setImage:(UIImage *)image{
    self.imageView.image = image;
    [self.imageView sizeToFit];
    
    [self.spinner stopAnimating];
}

-(UIImageView *)imageView{
    if(! _imageView)
        _imageView = [[UIImageView alloc]init];
    return _imageView;
}


-(void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2,0;
    _scrollView.delegate = self;
    self.scrollView.contentSize = self.image.size;
}

-(UIImage *)image{
    return self.imageView.image;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

//async download images
-(void)startDownloadingImage{
    self.image = nil;
    if(self.imageURL){
        [self.spinner startAnimating];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error){
            if(!error){
                if([request.URL isEqual:self.imageURL]){
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{self.image = image;});
                }
            }
        }];
        [task resume];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
