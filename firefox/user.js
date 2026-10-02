// Firefox user.js, copied into the default profile by setup.sh.
// Each line overrides the matching about:config pref on every startup.

// ============================================================================
// Privacy
// ============================================================================
user_pref("browser.contentblocking.category", "strict");
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("dom.security.https_only_mode", true);
// DNS over HTTPS via Cloudflare, falls back to system DNS if it fails
user_pref("network.trr.mode", 2);
user_pref("network.trr.uri", "https://mozilla.cloudflare-dns.com/dns-query");

// Telemetry / studies off
user_pref("toolkit.telemetry.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("browser.discovery.enabled", false);

// ============================================================================
// Clutter
// ============================================================================
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("extensions.pocket.enabled", false);
user_pref("browser.ipProtection.enabled", false); // VPN button
user_pref("browser.smartwindow.enabled", false);
user_pref("browser.aboutConfig.showWarning", false);

// ============================================================================
// Look (paired with chrome/userChrome.css + userContent.css)
// ============================================================================
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.compactmode.show", true);
user_pref("browser.uidensity", 1);
user_pref("widget.macos.native-context-menus", false); // lets userChrome.css theme menus
user_pref("sidebar.revamp", true);
user_pref("sidebar.verticalTabs", true);
user_pref("sidebar.visibility", "always-show"); // Ctrl+Z: icons <-> hidden (see userChrome.css)
user_pref("sidebar.animation.enabled", false);
user_pref("layout.css.prefers-color-scheme.content-override", 0); // dark sites
user_pref("devtools.theme", "dark");
user_pref("font.name.monospace.x-western", "JetBrainsMono Nerd Font");
user_pref("font.size.monospace.x-western", 13);
user_pref("view_source.wrap_long_lines", true);

// PDF viewer in Mocha, zathura-style
user_pref("pdfjs.forcePageColors", true);
user_pref("pdfjs.pageColorsBackground", "#1a1a24");
user_pref("pdfjs.pageColorsForeground", "#cdd6f4");

// ============================================================================
// Behavior
// ============================================================================
user_pref("browser.urlbar.trimURLs", false);
user_pref("browser.urlbar.trimHttps", false);
user_pref("browser.ctrlTab.sortByRecentlyUsed", true);
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("browser.download.alwaysOpenPanel", false);
user_pref("full-screen-api.transition-duration.enter", "0 0");
user_pref("full-screen-api.transition-duration.leave", "0 0");
user_pref("full-screen-api.warning.timeout", 0);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
// Scroll speed knob (100 = default). Ghostty runs at 0.5; try 50-80 if pages scroll too fast.
// user_pref("mousewheel.default.delta_multiplier_y", 75);
