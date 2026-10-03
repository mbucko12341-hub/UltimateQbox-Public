THEBOX RP - QBOX LOADING SCREEN
================================

INSTALLATION
1. Put the folder "thebox_loading_screen" into your FiveM resources folder.
2. Add this to server.cfg:
       ensure thebox_loading_screen
3. Restart the server.

CUSTOMISING
- Put your Discord invite into script.js under CONFIG.discordInvite.
- Optional: add a direct MP3/OGG URL to CONFIG.musicUrl.
- Edit the text in loadscreen.html for your own jobs, rules, features and server information.
- Replace assets/logo.png if you want to use a different logo. Keep the filename the same.

NOTES
- The loading screen listens for FiveM's loadProgress event and displays the real loading percentage when available.
- The screen is fully self-contained apart from the Google Fonts import. If you want it 100% offline, remove the @import line in style.css and use a local font.
- The rules and controls included are placeholders/general examples. Update them to match your actual TheBox server rules and keybinds.


MUSIC
-----
1. Put your MP3 files inside the /music folder.
2. Open script.js and edit CONFIG.tracks.
3. Example:
   { name: 'My Track', file: 'music/my-track.mp3' }
4. The loading screen supports multiple tracks and automatically moves to the next track when one finishes.
5. Players can use the Music button, Previous/Next buttons and volume slider.

IMPORTANT: Some browsers/loadscreen environments may block audio autoplay until the player interacts with the page. The Music button can be used to start playback.


MOUSE CURSOR
The manifest enables the mouse cursor during the FiveM loadscreen so players can click tabs, music controls, the volume slider and buttons.
