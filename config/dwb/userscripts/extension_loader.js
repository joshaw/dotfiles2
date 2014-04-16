#!javascript
////<adblock_subscriptions___SCRIPT
//extensions.load("adblock_subscriptions", {
////<adblock_subscriptions___CONFIG
//// To take effect dwb needs to be restarted
//
//// Shortcut to subscribe to a filterlist
//scSubscribe : as,
//// Command to subscribe to a filterlist
//cmdSubscribe : "adblock_subscribe",
//
//// Shortcut to unsubscribe from a filterlist
//scUnsubscribe : null,
//
//// Command to unsubscribe from a filterlist
//cmdUnsubscribe : "adblock_unsubscribe",
//
//// Path to the filterlist directory, will be created if it doesn't exist.
//filterListDir : data.configDir + "/adblock_lists"
////>adblock_subscriptions___CONFIG
//
//});
//>adblock_subscriptions___SCRIPT
//<simplyread___SCRIPT
extensions.load("simplyread", {
//<simplyread___CONFIG
// Shortcut to toggle simplyread
shortcut : "SR", 

// Command to toggle simplyread
command : "simplyread",

// Whether to use a stylesheet
nostyle : false, 

// Whether to show links
nolinks : false 

//>simplyread___CONFIG
});
//>simplyread___SCRIPT
