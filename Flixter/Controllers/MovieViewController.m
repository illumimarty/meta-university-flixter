//
//  MovieViewController.m
//  Flixter
//
//  Created by Marty Nodado on 5/16/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "PosterViewController.h"
#import "Movie.h"
#import "MovieAPIManager.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MovieViewController ()
@property (strong, nonatomic) NSMutableArray *movies;
@property (strong, nonatomic) NSArray *filteredMovies;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchMovies];
    [self formatInterface];
    [self initalizeRefreshControl];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.mySearchBar.delegate = self;
}

- (void)initalizeRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)fetchMovies {
    [self.activityIndicator startAnimating];
    
    MovieAPIManager *manager = [MovieAPIManager new];
    [manager fetchMovies:^(NSArray *movies, NSError *error) {
        self.movies = (NSMutableArray *)movies;
        self.filteredMovies = self.movies; // this stays here, not in APIManager
        [self.tableView reloadData];
    }];
    [self.activityIndicator stopAnimating];
}


- (void)formatInterface {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.view.backgroundColor = UIColorFromRGB(0x121212);
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(0x181818);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.whiteColor}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tableView.backgroundColor = UIColorFromRGB(0x181818);
    self.tabBarController.tabBar.barTintColor = UIColorFromRGB(0x121212);
    self.tabBarController.tabBar.tintColor = UIColor.whiteColor;
    self.mySearchBar.barTintColor = UIColorFromRGB(0x181818);
    self.mySearchBar.searchTextField.textColor = UIColor.whiteColor;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Movie *evaluatedObject, NSDictionary *bindings) {
            NSString *title = evaluatedObject.title;
            return [title containsString:searchText];
        }];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
        NSLog(@"%@", self.filteredMovies);
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"posterSegue"]) {
        PosterViewController *vc = [segue destinationViewController];
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        Movie *movie = self.filteredMovies[indexPath.row];

        vc.movie = movie;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    cell.movie = self.filteredMovies[indexPath.row];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:cell.movie.posterUrl];

    __weak MovieCell *weakSelf = cell;
    [cell.posterImage setImageWithURLRequest:request placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        // imageResponse will be nil if the image is cached
                                        if (imageResponse) {
                                            NSLog(@"Image was NOT cached, fade in image");
                                            weakSelf.posterImage.alpha = 0.0;
                                            weakSelf.posterImage.image = image;
                                            
                                            //Animate UIImageView back to alpha 1 over 0.3sec
                                            [UIView animateWithDuration:0.3 animations:^{
                                                weakSelf.posterImage.alpha = 1.0;
                                            }];
                                        }
                                        else {
                                            NSLog(@"Image was cached so just update the image");
                                            weakSelf.posterImage.image = image;
                                        }
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        // do something for the failure condition
                                    }];
    
    
    [cell setMovie:cell.movie];
    
    return cell;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {

        // Create NSURL and NSURLRequest
        NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=35a7cf82e598703e220a9b9924350685"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:nil
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
           // ... Use the new data to update the data source ...

           // Reload the tableView now that there is new data
            [self.tableView reloadData];

           // Tell the refreshControl to stop spinning
            [refreshControl endRefreshing];

        }];
    
        [task resume];
}

@end
