//
//  ViewController.m
//  flicker
//
//  Created by Raman Singh on 2018-04-26.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

#import "ViewController.h"
#import "PhotoObject.h"
#import "CustomCollectionViewCell.h"

@interface ViewController ()
@property (nonatomic) NSMutableArray *allPhotos;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic) NSMutableArray *allImages;
@property (nonatomic) UIImage *useImage;
@property (nonatomic) PhotoObject *thisPhotoObject;

@end
static NSString * const reuseIdentifier = @"Cell";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadJson];
    self.allPhotos = [NSMutableArray new];
    self.allImages = [NSMutableArray new];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}//


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPhotos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PhotoObject *newPhotoObject = [self.allPhotos objectAtIndex:indexPath.row];
    cell.imageView.image = newPhotoObject.image;
    NSLog(@"%@", newPhotoObject.photoURL);
    //    NSLog(@"%d photos", self.allPhotos.count);
    
    
    
    return cell;
    
}//cellForItem





-(void)loadJson {
    NSLog(@"loadjsoncalled");
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=df067bfc5c1fcc1d784b40d2751e0355&tags=cat"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *photos = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        
        NSDictionary *photoDict = [NSDictionary new];
        
        photoDict = photos[@"photos"];
        
        
        NSArray *allPhotosInDict = photoDict[@"photo"];
        NSDictionary *currentPhoto = [NSDictionary new];
        
        
        for (int i=0; i<allPhotosInDict.count; i++) {
            PhotoObject *myPhotoObject = [PhotoObject new];
            currentPhoto = [allPhotosInDict objectAtIndex:i];
            myPhotoObject.photoID = currentPhoto[@"id"];
            myPhotoObject.owner = currentPhoto[@"owner"];
            myPhotoObject.secret = currentPhoto[@"secret"];
            myPhotoObject.server = currentPhoto[@"server"];
            myPhotoObject.farm = [currentPhoto[@"farm"] intValue];
            myPhotoObject.title = currentPhoto[@"title"];
            myPhotoObject.ispublic = [currentPhoto[@"ispublic"] intValue];
            myPhotoObject.isfriend = [currentPhoto[@"isfriend"] intValue];
            myPhotoObject.isfamily = [currentPhoto[@"isfamily"] intValue];
            [myPhotoObject makeURL];
            [self.allPhotos addObject:myPhotoObject];
            
            NSURL *thisURL = [NSURL URLWithString:myPhotoObject.photoURL];
            
            [self loadImageWithURLandReturnImage:thisURL forPhotoObject:myPhotoObject];
            
        }//forLoop
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            //doThingsHere
            
        }];
        
    }];
    
    [dataTask resume]; // 6
}//loadJson

-(void)loadImageWithURLandReturnImage:(NSURL *)imageURL forPhotoObject:(PhotoObject *)thisPhotoObject{
    NSLog(@"running loadImageWithURLandReturnImage");
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:imageURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            thisPhotoObject.image = image;
            [self.collectionView reloadData];
        }];
    }];
    
    [downloadTask resume];
    
}
@end
