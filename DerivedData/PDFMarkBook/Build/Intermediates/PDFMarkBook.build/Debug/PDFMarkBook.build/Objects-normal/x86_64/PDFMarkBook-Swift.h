// Generated by Apple Swift version 1.2 (swiftlang-602.0.53.1 clang-602.0.53)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
#if __has_feature(nullability)
#  define SWIFT_NULLABILITY(X) X
#else
# if !defined(__nonnull)
#  define __nonnull
# endif
# if !defined(__nullable)
#  define __nullable
# endif
# if !defined(__null_unspecified)
#  define __null_unspecified
# endif
#  define SWIFT_NULLABILITY(X)
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import AppKit;
@import Foundation;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class PDFModel;
@class NSNotificationCenter;
@class NSNotification;
@class PDFPage;
@class PDFDocument;
@class NSPopUpButton;
@class NSButton;
@class NSMenuItem;
@class NSTextField;
@class NSSearchField;
@class NSWindow;
@class PDFView;
@class NSMenu;
@class NSView;

SWIFT_CLASS("_TtC11PDFMarkBook11AppDelegate")
@interface AppDelegate : NSObject <NSApplicationDelegate, NSOpenSavePanelDelegate>
@property (nonatomic) PDFModel * __nullable model;
@property (nonatomic) NSNotificationCenter * __nonnull notification;
@property (nonatomic, copy) NSString * __nonnull recentsAutosaveName;
@property (nonatomic, weak) IBOutlet NSWindow * __null_unspecified window;
@property (nonatomic, weak) IBOutlet PDFView * __null_unspecified pdfView;
@property (nonatomic, weak) IBOutlet NSMenu * __null_unspecified menu;
@property (nonatomic, weak) IBOutlet NSMenuItem * __null_unspecified openFile;
@property (nonatomic, weak) IBOutlet NSMenuItem * __null_unspecified saveFile;
@property (nonatomic, weak) IBOutlet NSMenuItem * __null_unspecified prevPageMenu;
@property (nonatomic, weak) IBOutlet NSMenuItem * __null_unspecified nextPageMenu;
@property (nonatomic, weak) IBOutlet NSMenuItem * __null_unspecified zoomOutMenu;
@property (nonatomic, weak) IBOutlet NSMenuItem * __null_unspecified zoomInMenu;
@property (nonatomic, weak) IBOutlet NSTextField * __null_unspecified pageCount;
@property (nonatomic, weak) IBOutlet NSButton * __null_unspecified prevButton;
@property (nonatomic, weak) IBOutlet NSButton * __null_unspecified nextButton;
@property (nonatomic, weak) IBOutlet NSButton * __null_unspecified prevPage;
@property (nonatomic, weak) IBOutlet NSButton * __null_unspecified nextPage;
@property (nonatomic, weak) IBOutlet NSTextField * __null_unspecified pageNumber;
@property (nonatomic, weak) IBOutlet NSButton * __null_unspecified zoomOutButton;
@property (nonatomic, weak) IBOutlet NSButton * __null_unspecified zoomInButton;
@property (nonatomic, weak) IBOutlet NSView * __null_unspecified view;
@property (nonatomic, weak) IBOutlet NSPopUpButton * __null_unspecified documentButton;
@property (nonatomic, weak) IBOutlet NSButton * __null_unspecified markCheck;
@property (nonatomic, weak) IBOutlet NSTextField * __null_unspecified markTextField;
@property (nonatomic, weak) IBOutlet NSSearchField * __null_unspecified searchField;
@property (nonatomic, weak) IBOutlet NSTextField * __null_unspecified searchLabel;

/// Initialising function that sets properties for the application. It is called when the 
/// application received a notification
/// it has finished launching.
///
/// :param aNotification notfication reveived from the notification centre
- (void)applicationDidFinishLaunching:(NSNotification * __nonnull)aNotification;
- (NSRect)getScreenSize;
- (void)applicationWillTerminate:(NSNotification * __nonnull)aNotification;

/// <dl><dt>checks whether current document is the first or last document</dt><dd><p>and sets forward and back documents to be enabled or dis-abled</p></dd></dl>
- (void)validateDocumentButtons;

/// <dl><dt>checks whether current document is at the first or last page</dt><dd><p>and sets forward and back documents to be enabled or dis-abled</p><dl><dt>param</dt><dd><p>page No the current page number in the document</p></dd><dt>param</dt><dd><p>direction whether last page change was forward > 0 or backward < 0</p></dd></dl></dd></dl>
- (void)validatePageButtons:(PDFPage * __nonnull)page;

/// <dl><dt>called when the current page changes sends updated page</dt><dd><p>to model</p><dl><dt>param</dt><dd><p>notfication received from NSNoftication centre</p></dd></dl><ul><li></li></ul></dd></dl>
- (void)pageChangedNotification:(NSNotification * __nonnull)notification;

/// <dl><dt>called when new documents are open. Sets page changed notification</dt><dd><p>and enables buttons and textfields on toolbar</p><dl><dt>param</dt><dd><p>document the PDF document being opened</p></dd></dl></dd></dl>
- (void)documentsFinishedLoading:(PDFDocument * __nonnull)document;

/// <dl><dt>displays the current pdf document in the PDF view, sets attributes and</dt><dd><p>does button validation.</p><dl><dt>param</dt><dd><p>document the current PDF document being displayed</p></dd><dt>param</dt><dd><p>index the index of the document in the document array</p></dd></dl></dd></dl>
- (void)documentDidChange:(PDFDocument * __nonnull)document index:(NSInteger)index;

/// <dl><dt>gets the index of the current page and updates page textfield</dt><dd><p>then sends current page to goToPage function</p><dl><dt>param</dt><dd><p>page the current page being displayed</p></dd><dt>param</dt><dd><p>direction whether user is navigating forward or backwards</p></dd></dl></dd></dl>
- (void)pageDidChange:(PDFPage * __nonnull)page direction:(NSInteger)direction;

/// gets the mark from the current document and sets in textfield
///
/// <blockquote><dl><dt>param</dt><dd><p>index of the current document</p></dd></dl></blockquote>
- (void)syncMark:(NSInteger)index;
- (IBAction)changeDocument:(NSPopUpButton * __nonnull)sender;
- (IBAction)autoScale:(NSButton * __nonnull)sender;
- (IBAction)autoScaleMenu:(NSMenuItem * __nonnull)sender;
- (IBAction)prevPage:(NSButton * __nonnull)sender;
- (IBAction)nextPage:(NSButton * __nonnull)sender;
- (IBAction)nextPageKey:(NSMenuItem * __nonnull)sender;
- (IBAction)previousPageKey:(NSMenuItem * __nonnull)sender;
- (IBAction)goBackMenu:(NSMenuItem * __nonnull)sender;
- (IBAction)aboutMenu:(id __nonnull)sender;
- (IBAction)goForwardMenu:(NSMenuItem * __nonnull)sender;
- (IBAction)zoomOutMenu:(NSMenuItem * __nonnull)sender;
- (IBAction)zoomInMenu:(NSMenuItem * __nonnull)sender;
- (IBAction)zoomIn:(NSButton * __nonnull)sender;
- (IBAction)zoomOut:(NSButton * __nonnull)sender;
- (IBAction)nextDocument:(NSButton * __nonnull)sender;
- (IBAction)prevDocument:(NSButton * __nonnull)sender;
- (IBAction)goToPage:(NSTextField * __nonnull)sender;
- (IBAction)markDocument:(NSTextField * __nonnull)sender;
- (IBAction)search:(NSSearchField * __nonnull)sender;
- (IBAction)saveFile:(NSMenuItem * __nonnull)sender;
- (NSString * __nonnull)openPBMFile:(NSString * __null_unspecified)path;
- (IBAction)openFile:(NSMenuItem * __nonnull)sender;
- (SWIFT_NULLABILITY(nonnull) instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSMutableArray;
@class PDFDestination;

SWIFT_CLASS("_TtC11PDFMarkBook8PDFModel")
@interface PDFModel : NSObject
@property (nonatomic) NSMutableArray * __null_unspecified pdfArray;
@property (nonatomic) NSMutableArray * __nonnull titleArray;
@property (nonatomic) NSMutableArray * __nonnull refArray;
@property (nonatomic) NSMutableArray * __nonnull pageHistory;
@property (nonatomic) NSInteger documentIndex;
@property (nonatomic) PDFPage * __nullable currentPage;
@property (nonatomic) PDFPage * __nullable previousPage;
@property (nonatomic) PDFDocument * __nullable currentDocument;
@property (nonatomic) PDFDestination * __nullable destination;

/// adds documents being opened to the pdfArray and initialises document index
///
/// <blockquote><dl><dt>param</dt><dd><p>count the number of documents being opened</p></dd></dl></blockquote>
- (void)loadDocuments:(NSInteger)count;

/// <dl><dt>navigates to next document and sends current document and index and</dt><dd><p>current page and direction (direction zero as page not being changed to controller</p></dd></dl>
- (void)nextDocument;

/// <dl><dt>navigates to previous document and sends current document and index and</dt><dd><p>current page and direction (direction zero as page not being changed to controller</p></dd></dl>
- (void)prevDocument;

/// <dl><dt>navigates to next page by sending current page to controller and direction 1 as</dt><dd><p>page is being moved forward. also updates current page index</p></dd></dl>
- (void)nextPage;

/// <dl><dt>navigates to previous page by sending current page to controller and direction -1 as</dt><dd><p>page is being moved back. Also updates current page index</p></dd></dl>
- (void)prevPage;

/// not used 
- (void)goBack;

/// updates the current document in the pdfArray sends current document to controller
///
/// <blockquote><dl><dt>param</dt><dd><p>index of current document</p></dd></dl></blockquote>
- (void)updateDocument:(NSInteger)index;

/// updates current documents mark in its MarkBook object then writes to disk
///
/// <blockquote><dl><dt>param</dt><dd><p>mark the mark of the documet</p></dd></dl></blockquote>
- (void)updateMark:(NSString * __nonnull)mark;

/// writes .pmb file to disk in the document directory. Writes the url and mark of each document
- (void)writeFile;

/// <dl><dt>obtains current page from controller and checks if page is valid, updates model </dt><dd><p>then sends information back to controller for update
/// :param: pageNumber the new pageNumber requested</p></dd></dl>
- (void)goToPage:(NSString * __nonnull)pageNumber;

/// <dl><dt>updates current page and sends new page to controller his function is used when</dt><dd><p>navigating to page through the textfiled on user interface</p><dl><dt>param</dt><dd><p>the page requested</p></dd></dl></dd></dl>
- (void)updatePage:(PDFPage * __nonnull)page;

/// uses current page in dex and previous page index to establish direction the user is navigating
///
/// <blockquote><dl><dt>param</dt><dd><p>current the current PDF page</p></dd><dt>param</dt><dd><p>previous the previous PDF page</p></dd><dt>return</dt><dd><p>direction the direction the user is navigating</p></dd></dl></blockquote>
- (NSInteger)getDirection:(PDFPage * __nonnull)current previous:(PDFPage * __nonnull)previous;
- (SWIFT_NULLABILITY(nonnull) instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop
