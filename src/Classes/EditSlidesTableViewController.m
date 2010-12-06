//
//  EditSlidesTableViewController.m
//  MobileDesigner
//

#import "EditSlidesTableViewController.h"
#import "EditSlideViewController.h"
#import "Project.h"
#import "Slide.h"

@implementation EditSlidesTableViewController

@synthesize project;
@synthesize managedObjectContext;

- initInManagedObjectContext:(NSManagedObjectContext *)context forProject:(Project *)proj
{
	if (self = [super initWithStyle:UITableViewStylePlain])
	{
		self.managedObjectContext = context;
		self.project = proj;
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		request.entity = [NSEntityDescription entityForName:@"Slide" inManagedObjectContext:context];
		request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"number"
																					   ascending:YES]];
		
		request.predicate = [NSPredicate predicateWithFormat:@"project == %@", project];
		request.fetchBatchSize = 20;
		
		NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
										   initWithFetchRequest:request
										   managedObjectContext:context
										   sectionNameKeyPath:nil
										   cacheName:nil];
		
		[request release];
		
		self.fetchedResultsController = frc;
		[frc release];
		
		self.titleKey = @"text";
		self.searchKey = @"text";
	}
	return self;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
	Slide *slide = (Slide *)managedObject;
	NSLog(@"selected a slide");
	EditSlideViewController *esvc = [[EditSlideViewController alloc] initWithSlide:slide];
	esvc.delegate = self;
	[self.navigationController pushViewController:esvc animated:YES];
//	[self.navigationController popViewControllerAnimated:NO];
//	[delegate openProject:proj];
}

- (UIImage*)thumbnailImageForManagedObject:(NSManagedObject *)managedObject
{
	Slide *slide = (Slide *)managedObject;
	return [UIImage imageWithData:slide.image];
}

- (void)updateTableData
{
	[self.tableView reloadData];
}

@end
