    //
//  PresentationTableViewController.m
//  MobileDesigner
//

#import "PresentationTableViewController.h"
#import "PresentedSlideViewController.h"
#import "Project.h"
#import "Slide.h"

@implementation PresentationTableViewController

@synthesize managedObjectContext;
@synthesize project;

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
	PresentedSlideViewController *esvc = [[PresentedSlideViewController alloc] initWithSlide:slide];
	[self.navigationController pushViewController:esvc animated:YES];
}

- (UIImage*)thumbnailImageForManagedObject:(NSManagedObject *)managedObject
{
	Slide *slide = (Slide *)managedObject;
	return [UIImage imageWithData:slide.image];
}

@end
