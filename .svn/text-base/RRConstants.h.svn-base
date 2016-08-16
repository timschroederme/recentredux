//
//  RRConstants.h
//  Recent Redux
//
//  Created by Tim Schröder on 22.01.11.
//  Copyright 2011 Tentacle Forge. All rights reserved.
//

// Konstanten für Suchschlüssel der Recent Items

// Schnell, wenig Ergebnisse (nur die Files, die vom Nutzer geöffnet wurden)
#define SEARCH_KEY_1 @"kMDItemLastUsedDate" 

// Schnell, aber viele Ergebnisse
#define SEARCH_KEY_2 @"kMDItemContentModificationDate"	

// Achtung, hier dauert Abfrage länger usw.
//#define SEARCH_KEY_2	@"kMDItemFSContentChangeDate"		
//#define SEARCH_KEY_2	@"kMDItemAttributeChangeDate"

// Konstanten für Filesize

#define GByte 1073741824.0 // 1024*1024*1024
#define MByte 1048576.0 // 1024*1024
#define KByte 1024.0

// Konstanten für Mail-Versand

#define MAILCLIENT_TITLE @"MailClientTitle"
#define MAILCLIENT_LONGTITLE @"MailClientLongTitle"
#define MAILCLIENT_VERSION @"MailClientVersion"
#define MAILCLIENT_IDENTIFIER @"MailClientIdentifier"
#define MAILCLIENT_ICON @"MailClientIcon"
#define MAILCLIENT_URL @"MailClientURL"

#define CLIENT_APPLEMAIL @"com.apple.mail"
#define CLIENT_APPLEMAIL_TITLE @"Mail"
#define CLIENT_ENTOURAGE @"com.microsoft.Entourage"
#define CLIENT_ENTOURAGE_TITLE @"Microsoft Entourage 2008"
#define CLIENT_OUTLOOK @"com.microsoft.Outlook"
#define CLIENT_OUTLOOK_TITLE @"Microsoft Outlook"
#define CLIENT_POSTBOX @"com.postbox-inc.postbox"
#define CLIENT_POSTBOX_TITLE @"Postbox"


// Maximale Attachment-Größe für Mailversand

#define MAX_ATTACHMENT_SIZE MByte*25


// Fehlermeldungen für Email-Versand

#define ERROR_CODE_ATTACHMENT 0
#define ERROR_ATTACHMENT_TITLE NSLocalizedString (@"ERROR_ATTACHMENT_TITLE", )
#define ERROR_ATTACHMENT_NOTICE NSLocalizedString (@"ERROR_ATTACHMENT_NOTICE", )

#define ERROR_CODE_SCRIPT 1
#define ERROR_SCRIPT_TITLE	NSLocalizedString (@"ERROR_SCRIPT_TITLE", ) 
#define ERROR_SCRIPT_NOTICE NSLocalizedString (@"ERROR_SCRIPT_NOTICE", )

#define ERROR_CODE_CLIENT 2
#define ERROR_CLIENT_TITLE NSLocalizedString (@"ERROR_CLIENT_TITLE", )
#define ERROR_CLIENT_NOTICE NSLocalizedString (@"ERROR_CLIENT_NOTICE", )


// Konstanten für Spotlight

#define SPOTLIGHT_PATH_PREFPANE @"PreferencePanes/Spotlight.prefPane"


// Konstanten für Multi-Threading

#define THREAD_INITIALQUERY @"Initial Query"
#define THREAD_UPDATEQUERY	@"Update Query"
#define THREAD_SENDMAIL @"Send Mail"


// Konstanten für die Default Items' Preferences

#define DEFAULTS_SCOPEFILTER @"ScopeFilter"

#define DEFAULTS_SEARCHINTERVAL @"SearchInterval"
#define DEFAULTS_SEARCHINTERVAL_PRESET @"72"

#define DEFAULTS_SEARCHSCOPE @"SearchScope"
#define DEFAULTS_SEARCHSCOPE_PRESET @"0"

#define DEFAULTS_SEARCHLOCATION @"SearchLocation"
#define DEFAULTS_SEARCHLOCATION_PRESET	@"0"

#define DEFAULTS_HOTKEY @"UseGlobalHotkey"
#define DEFAULTS_HOTKEY_PRESET	@"1"

#define DEFAULTS_ALWAYSINFRONT @"AlwaysInFront"
#define DEFAULTS_ALWAYSINFRONT_PRESET @"NO"

#define DEFAULTS_MAILCLIENT @"MailClient"
#define DEFAULTS_MAILCLIENT_PRESET @""

#define SCOPE_DICT_TITLE @"title"
#define SCOPE_DICT_DESCRIPTION @"description"
#define SCOPE_DICT_PREDICATE @"predicate"
#define SCOPE_DICT_HIDDEN @"hidden"
#define SCOPE_DICT_ENABLED	@"enabled"
#define SCOPE_DICT_EDITABLE @"editable"
#define SCOPE_DICT_TAG @"tag"


// Konstanten für die Default-Werte der Scope-Items

#define SCOPE_TITLE_ALL NSLocalizedString (@"SCOPE_TITLE_ALL", )
#define SCOPE_DESCRIPTION_ALL NSLocalizedString (@"SCOPE_DESCRIPTION_ALL", )
#define SCOPE_PREDICATE_ALL @""

#define SCOPE_TITLE_DOCUMENTS NSLocalizedString (@"SCOPE_TITLE_DOCUMENTS", )
#define SCOPE_DESCRIPTION_DOCUMENTS NSLocalizedString (@"SCOPE_DESCRIPTION_DOCUMENTS", )

#define SCOPE_PREDICATE_DOCUMENTS @"(itemType CONTAINS 'com.microsoft.word.doc' OR itemType CONTAINS 'com.microsoft.word.dot' OR itemType CONTAINS 'com.microsoft.excel.xls' OR itemType CONTAINS 'com.microsoft.excel.xlt' OR itemType CONTAINS 'com.microsoft.powerpoint.pot')"

#define SCOPE_TITLE_PDF NSLocalizedString (@"SCOPE_TITLE_PDF", )
#define SCOPE_DESCRIPTION_PDF NSLocalizedString (@"SCOPE_DESCRIPTION_PDF", )
#define SCOPE_PREDICATE_PDF @"itemType CONTAINS 'com.adobe.pdf'"

#define SCOPE_TITLE_MEDIA NSLocalizedString (@"SCOPE_TITLE_MEDIA", )
#define SCOPE_DESCRIPTION_MEDIA NSLocalizedString (@"SCOPE_DESCRIPTION_MEDIA", )
#define SCOPE_PREDICATE_MEDIA @"(itemType CONTAINS 'public.audiovisual-content') || (itemType CONTAINS 'public.audio') || (itemType CONTAINS 'public.movie')"

#define SCOPE_TITLE_IMAGES NSLocalizedString (@"SCOPE_TITLE_IMAGES", )
#define SCOPE_DESCRIPTION_IMAGES NSLocalizedString (@"SCOPE_DESCRIPTION_IMAGES", )
#define SCOPE_PREDICATE_IMAGES	@"(itemType CONTAINS 'public.image')"

#define SCOPE_TITLE_FOLDERS NSLocalizedString (@"SCOPE_TITLE_FOLDERS", )
#define SCOPE_DESCRIPTION_FOLDERS NSLocalizedString (@"SCOPE_DESCRIPTION_FOLDERS", )
#define SCOPE_PREDICATE_FOLDERS @"(itemType CONTAINS 'public.folder')"

#define SCOPE_TITLE_MESSAGES NSLocalizedString (@"SCOPE_TITLE_MESSAGES", )
#define SCOPE_DESCRIPTION_MESSAGES NSLocalizedString (@"SCOPE_DESCRIPTION_MESSAGES", )
#define SCOPE_PREDICATE_MESSAGES @"(itemType CONTAINS 'public.email-message')"

#define SCOPE_TITLE_APPS NSLocalizedString (@"SCOPE_TITLE_APPS", )
#define SCOPE_DESCRIPTION_APPS NSLocalizedString (@"SCOPE_DESCRIPTION_APPS", )
#define SCOPE_PREDICATE_APPS @"(itemType CONTAINS 'com.apple.bundle')"


// Konstanten für die Darstellung der Scopebar

#define SCOPE_BAR_BORDER_WIDTH 1.0 // bottom line's width
#define SCOPE_BAR_H_INSET 4.0 // inset on left and right
#define SCOPE_BAR_ITEM_SPACING	4.0 // spacing between buttons/separators/labels
#define SCOPE_BAR_MORE_BUTTON_WIDTH 13.0 // Breite des More-Buttons

#define SCOPE_BAR_MENU 1 // Tag-Wert
#define SCOPE_BAR_BUTTON 2 // Tag-Wert
#define SCOPE_BAR_OVERFLOW_MENU 3 // Tag-Wert


// Konstanten für Keypaths der Items im Hauptarray

#define ITEM_NAME @"name"
#define ITEM_RAWNAME @"rawName"
#define ITEM_ICON @"icon"
#define ITEM_RAWDATE @"rawDate"
#define ITEM_DAY @"openDay"
#define ITEM_TIME @"openTime"
#define ITEM_KIND @"itemKind"
#define ITEM_META @"metadataItem"
#define ITEM_TYPE @"itemType"


// Konstanten für Zugriff auf Query-Metadata-Items

#define MDI_PATH @"kMDItemPath"
#define MDI_SIZE @"kMDItemFSSize"
#define MDI_FILE_NAME @"kMDItemFSName"
#define MDI_KIND @"kMDItemKind"
#define MDI_TYPE @"kMDItemContentTypeTree"
#define MDI_IDENTIFIER @"kMDItemCFBundleIdentifier"


// Konstanten für die Menüs (Hauptmenü und Contextmenü)

#define MENU_STANDARD NSLocalizedString (@"MENU_STANDARD", )
#define MENU_QUICKLOOK_ACTIVE NSLocalizedString (@"MENU_QUICKLOOK_ACTIVE", )
#define MENU_OPENWITHCAPTION NSLocalizedString (@"MENU_OPENWITHCAPTION", )
#define MENU_OTHERAPP NSLocalizedString (@"MENU_OTHERAPP", )

#define MENU_ABOUT NSLocalizedString (@"MENU_ABOUT", )
#define MENU_PREFERENCES NSLocalizedString (@"MENU_PREFERENCES", )
#define MENU_SERVICES NSLocalizedString (@"MENU_SERVICES", )
#define MENU_HIDE NSLocalizedString (@"MENU_HIDE", )
#define MENU_HIDEOTHERS NSLocalizedString (@"MENU_HIDEOTHERS", )
#define MENU_SHOWALL NSLocalizedString (@"MENU_SHOWALL", )
#define MENU_QUIT NSLocalizedString (@"MENU_QUIT", )

#define MENU_FILE NSLocalizedString (@"MENU_FILE", )
#define MENU_QUICKLOOK	NSLocalizedString (@"MENU_QUICKLOOK", )
#define MENU_OPEN NSLocalizedString (@"MENU_OPEN", )
#define MENU_OPENWITH NSLocalizedString (@"MENU_OPENWITH", )
#define MENU_SHOWINFINDER NSLocalizedString (@"MENU_SHOWINFINDER", )
#define MENU_SHARE NSLocalizedString (@"MENU_SHARE", )
#define MENU_EMAIL NSLocalizedString (@"MENU_EMAIL", )

#define MENU_EDIT NSLocalizedString (@"MENU_EDIT", )
#define MENU_UNDO NSLocalizedString (@"MENU_UNDO", )
#define MENU_REDO NSLocalizedString (@"MENU_REDO", )
#define MENU_CUT NSLocalizedString (@"MENU_CUT", )
#define MENU_COPY NSLocalizedString (@"MENU_COPY", )
#define MENU_COPY_FILE NSLocalizedString (@"MENU_COPY_FILE", )
#define MENU_COPYPATH NSLocalizedString (@"MENU_COPYPATH", )
#define MENU_PASTE NSLocalizedString (@"MENU_PASTE", )
#define MENU_DELETE NSLocalizedString (@"MENU_DELETE", )
#define MENU_SELECTALL NSLocalizedString (@"MENU_SELECTALL", )
#define MENU_FIND NSLocalizedString (@"MENU_FIND", )
#define MENU_FINDSOMETHING NSLocalizedString (@"MENU_FINDSOMETHING", )
#define MENU_FINDNEXT NSLocalizedString (@"MENU_FINDNEXT", )
#define MENU_FINDPREVIOUS NSLocalizedString (@"MENU_FINDPREVIOUS", )
#define MENU_FINDUSESELECTION NSLocalizedString (@"MENU_FINDUSESELECTION", )
#define MENU_FINDJUMPTOSELECTION NSLocalizedString (@"MENU_FINDJUMPTOSELECTION", )

#define MENU_FILTER NSLocalizedString (@"MENU_FILTER", )
#define MENU_EDITFILTERS NSLocalizedString (@"MENU_EDITFILTERS", )

#define MENU_WINDOW NSLocalizedString (@"MENU_WINDOW", )
#define MENU_ALWAYSINFRONT NSLocalizedString (@"MENU_ALWAYSINFRONT", )
#define MENU_MINIMIZE NSLocalizedString (@"MENU_MINIMIZE", )
#define MENU_ZOOM NSLocalizedString (@"MENU_ZOOM", )
#define MENU_CLOSE NSLocalizedString (@"MENU_CLOSE", )
#define MENU_BRINGALLTOFRONT NSLocalizedString (@"MENU_BRINGALLTOFRONT", )

#define MENU_HELPCAPTION NSLocalizedString (@"MENU_HELPCAPTION", )
#define MENU_HELP NSLocalizedString (@"MENU_HELP", )


#define MENU_OPENWITHENTRY_TAG 0
#define MENU_QUICKLOOK_TAG 100
#define MENU_OPENFILE_TAG 101
#define MENU_COPYPATH_TAG 102
#define MENU_SHOWINFINDER_TAG 103
#define MENU_EMAIL_TAG 104
#define MENU_OPENWITH_TAG 105
#define MENU_UNDO_TAG 200
#define MENU_REDO_TAG 201
#define MENU_CUT_TAG 202
#define	MENU_COPY_TAG 203
#define MENU_PASTE_TAG 204
#define	MENU_DELETE_TAG 205
#define MENU_SELECTALL_TAG 206
#define MENU_ALWAYSINFRONT_TAG 300
#define MENU_CLOSE_TAG 400
#define MENU_PREFERENCES_TAG 500
#define MENU_EDITFILTERS_TAG 600
#define MENU_EDITFILTERSSEP_TAG 601


// Konstanten für Status Bar

#define STATUS_FETCHING NSLocalizedString (@"STATUS_FETCHING", )
#define STATUS_UPDATING NSLocalizedString (@"STATUS_UPDATING", )
#define STATUS_EMAIL NSLocalizedString (@"STATUS_EMAIL", )
#define STATUS_ITEM_PLURAL NSLocalizedString (@"STATUS_ITEM_PLURAL", );
#define STATUS_ITEM_SINGULAR NSLocalizedString (@"STATUS_ITEM_SINGULAR", );


// Konstanten für Tasten

#define KEY_SPACE 0x31
#define KEY_CURSOR_DOWN 0x7D
#define KEY_CURSOR_UP 0x7E


// Konstanten für Open-With-Panel

#define OPEN_WITH_CAPTION NSLocalizedString (@"OPEN_WITH_CAPTION", ) // Für open-with-Fenster
#define OPEN_WITH_CANCEL_ORG @"Cancel"
#define OPEN_WITH_OK_LOC NSLocalizedString (@"OPEN_WITH_OK_LOC", )


// Konstanten für Lokalisierung Email-Client-Window

#define MAILWINDOW_HEADING NSLocalizedString (@"MAILWINDOW_HEADING", )
#define MAILWINDOW_LINEABOVE NSLocalizedString (@"MAILWINDOW_LINEABOVE", )
#define MAILWINDOW_LINEBELOW NSLocalizedString (@"MAILWINDOW_LINEBELOW", )


// Konstante für Lokalisierung Preferences-Window

#define	PREFWINDOW_TITLE NSLocalizedString (@"PREFWINDOW_TITLE", )
#define PREFWINDOW_GENERALPANE NSLocalizedString (@"PREFWINDOW_GENERALPANE", )
#define PREFWINDOW_SEARCHPANE NSLocalizedString (@"PREFWINDOW_SEARCHPANE", )
#define PREFWINDOW_QUERIESPANE NSLocalizedString (@"PREFWINDOW_QUERIESPANE", )

#define PREFWINDOW_HOTKEY NSLocalizedString (@"PREFWINDOW_HOTKEY", )
#define PREFWINDOW_HOTKEYCHECK NSLocalizedString (@"PREFWINDOW_HOTKEYCHECK", )
#define PREFWINDOW_SENDEMAILWITH NSLocalizedString (@"PREFWINDOW_SENDEMAILWITH", )

#define PREFWINDOW_SEARCHTIME NSLocalizedString (@"PREFWINDOW_SEARCHTIME", )
#define PREFWINDOW_SEARCHTIMEPREFIX NSLocalizedString (@"PREFWINDOW_SEARCHTIMEPREFIX", )
#define PREFWINDOW_SEARCHTIMESUFFIX NSLocalizedString (@"PREFWINDOW_SEARCHTIMESUFFIX", )

#define PREFWINDOW_SEARCHSCOPE NSLocalizedString (@"PREFWINDOW_SEARCHSCOPE", )
#define PREFWINDOW_SEARCHSCOPESMALL NSLocalizedString (@"PREFWINDOW_SEARCHSCOPESMALL", )
#define PREFWINDOW_SEARCHSCOPEBIG NSLocalizedString (@"PREFWINDOW_SEARCHSCOPEBIG", )

#define PREFWINDOW_SEARCHLOCATION NSLocalizedString (@"PREFWINDOW_SEARCHLOCATION", )
#define PREFWINDOW_SEARCHLOCATIONSMALL NSLocalizedString (@"PREFWINDOW_SEARCHLOCATIONSMALL", )
#define PREFWINDOW_SEARCHLOCATIONBIG NSLocalizedString (@"PREFWINDOW_SEARCHLOCATIONBIG", )

#define PREFWINDOW_QUERYTITLE NSLocalizedString (@"PREFWINDOW_QUERYTITLE", )
#define PREFWINDOW_QUERYDESCRIPTION NSLocalizedString (@"PREFWINDOW_QUERYDESCRIPTION", )
#define PREFWINDOW_QUERYENABLEDCHECKBOX NSLocalizedString (@"PREFWINDOW_QUERYENABLEDCHECKBOX", )
#define PREFWINDOW_EDITQUERYBUTTON NSLocalizedString (@"PREFWINDOW_EDITQUERYBUTTON", )
#define PREFWINDOW_EDITOROKBUTTON NSLocalizedString (@"PREFWINDOW_EDITOROKBUTTON", )
#define PREFWINDOW_EDITORCANCELBUTTON NSLocalizedString (@"PREFWINDOW_EDITORCANCELBUTTON", )


// Konstanten für Query-Elemente

#define QUERY_DEFAULTTITLE NSLocalizedString (@"QUERY_DEFAULTTITLE", )
#define QUERY_DEFAULTDESCRIPTION NSLocalizedString (@"QUERY_DEFAULTDESCRIPTION", )


// Sonstige Konstanten

#define OKBUTTONCAPTION NSLocalizedString (@"OKBUTTONCAPTION", )
#define CANCELBUTTONCAPTION NSLocalizedString (@"CANCELBUTTONCAPTION", )

#define ITEM_KIND_UNKNOWN NSLocalizedString (@"ITEM_KIND_UNKNOWN", ) // Für Beschriftung in AppDelegate

#define RRNotFound -1 // Vergleichsoperator

#define MAX_MENU_LENGTH 25 // Ab dieser Länge werden Menüeinträge gekürzt dargestellt

#define FIRSTRESPONDERKEY @"firstResponder"

#define PATH_MAINAPPDIR @"/Applications"
#define PATH_DEVELOPAPPDIR @"/Developer/Applications"

