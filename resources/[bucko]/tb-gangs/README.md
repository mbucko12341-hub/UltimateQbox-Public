# TB-Gangs — Advanced Gang, Turf, Reputation & 3D Graffiti System (Qbox)

**`tb-gangs`** is a complete, database-driven gang management, territory warfare, 3D compound stash, and 3D PNG wall-spraying system built natively for **Qbox (`qbx_core`)**.

---

## 🌟 Features Overview

* **Realistic Tablet OS (`gangtablet`)**:
  * Custom iPad Pro / Tactical OS interface with hardware bezels, power/volume buttons, live clock, status bar, widgets, and app dock.
  * Spawns a physical 3D tablet prop with a holding animation when used from inventory.
  * Leaders can view live **Gang Reputation (Rep)**, track city territories, invite nearby players, promote/demote members, kick members, and manage their compound safe.
* **3D Wall PNG Graffiti System (`spraycan`)**:
  * Using a `spraycan` opens a thumbnail selector showing your gang's custom `.png` spray tags.
  * Live 3D wall raycast preview with **Scroll Wheel** resizing (`0.8m` – `3.5m`) and true 32-bit PNG transparency.
  * Permanently saved to SQL and rendered on the wall for all players.
* **Territory Control, Custom HUD & Gang Reputation**:
  * Color-coded radius blips and center icons on the GTA pause map for every territory.
  * Custom animated **Territory Entry HUD Banner** slides down at the top of the screen when gang members enter friendly or hostile turf.
  * Tagging walls inside enemy gang territories awards cash/`black_money`, strips enemy turf influence, and grants **Gang Reputation (+REP)** with a custom on-screen toast notification.
* **3D Compound Safe Stashes**:
  * Gang leaders can place and rotate a physical safe (`prop_ld_int_safe_01`) anywhere inside a territory/compound their gang controls.
  * Each gang gets its own isolated `ox_inventory` stash with customizable minimum rank permissions (`Rank 0+` by default).
  * Gang members can open their safe via **`ox_target` (Third-Eye)** or by pressing **`[E]`**.
* **In-Game Admin Gang & Turf Creator (`/gangadmin`)**:
  * Create brand-new gangs in-game (custom ranks, map blip color, and instant compound zone) without editing core files—automatically registered into `qbx_core` on every server startup.
  * Create or delete territory map markers, appoint gang leaders, wipe/disband gangs, and remove nearby wall sprays in real time.

---

## 📦 Dependencies

Make sure these resources are installed and started **before** `tb-gangs` in your `server.cfg`:
* `qbx_core`
* `ox_lib`
* `ox_inventory`
* `ox_target`
* `oxmysql`

---

## 🛠️ Installation Guide

### Step 1: Database Setup (`sql.sql`)
Run the following SQL queries in your database (HeidiSQL / phpMyAdmin):

```sql
CREATE TABLE IF NOT EXISTS `tb_gang_custom` (
    `gang` VARCHAR(50) NOT NULL PRIMARY KEY,
    `label` VARCHAR(100) NOT NULL,
    `color` INT(11) NOT NULL DEFAULT 1,
    `grades` LONGTEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS `tb_gang_stashes` (
    `gang` VARCHAR(50) NOT NULL PRIMARY KEY,
    `coords` LONGTEXT NOT NULL,
    `heading` FLOAT NOT NULL DEFAULT 0.0,
    `min_grade` INT(11) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `tb_gang_turfs` (
    `zone_id` VARCHAR(50) NOT NULL PRIMARY KEY,
    `label` VARCHAR(100) NOT NULL,
    `coords` LONGTEXT NOT NULL,
    `radius` FLOAT NOT NULL DEFAULT 110.0,
    `owner` VARCHAR(50) NOT NULL DEFAULT 'none',
    `points` INT(11) NOT NULL DEFAULT 100
);

CREATE TABLE IF NOT EXISTS `tb_gang_sprays` (
    `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `gang` VARCHAR(50) NOT NULL,
    `image` VARCHAR(255) NOT NULL,
    `coords` LONGTEXT NOT NULL,
    `normal` LONGTEXT NOT NULL,
    `size` FLOAT NOT NULL DEFAULT 1.8,
    `zone_id` VARCHAR(50) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `tb_gang_rep` (
    `gang` VARCHAR(50) NOT NULL PRIMARY KEY,
    `rep` INT(11) NOT NULL DEFAULT 0
);
```

---

### Step 2: Add Items to `ox_inventory`
Open **`ox_inventory/data/items.lua`** and add the `gangtablet` and `spraycan` items before the final closing `}`:

```lua
    ['gangtablet'] = {
        label = 'Gang Tablet',
        weight = 1000,
        stack = false,
        close = true,
        description = 'A tablet used to manage your gang.',
        client = {
            image = 'gangtablet.png',
            export = 'tb-gangs.useGangTablet'
        }
    },

    ['spraycan'] = {
        label = 'Spray Can',
        weight = 250,
        stack = true,
        close = true,
        description = 'A can of aerosol paint used for tagging gang territories.',
        client = {
            image = 'spraycan.png',
            export = 'tb-gangs.useSprayCan'
        }
    },
```
* Place `gangtablet.png` and `spraycan.png` into `ox_inventory/web/images/`.

---

### Step 3: Add to `server.cfg`
```cfg
ensure oxmysql
ensure ox_lib
ensure qbx_core
ensure ox_target
ensure ox_inventory
ensure tb-gangs
```

---

## 🎨 How to Add New Gang Sprays (PNGs)

Adding a custom spray logo for a new gang takes 3 quick steps:

### 1. Prepare Your PNG Image
* **Dimensions:** `512x512` pixels (1:1 square).
* **Background:** Transparent (32-bit PNG with alpha channel).
* **Padding:** Leave a `15px–20px` transparent margin around the edges of the artwork so it doesn't clip at the border.
* **File Name:** Lowercase with no spaces (e.g., `dockers.png`).

### 2. Drop the PNG into the `sprays` Folder
Place your `.png` file inside:
```text
tb-gangs/web/sprays/dockers.png
```
*(Because `fxmanifest.lua` includes `'web/sprays/*.png'`, any `.png` dropped into this folder is automatically streamed by FiveM).*

### 3. Register the Spray in `config.lua`
Open **`tb-gangs/config.lua`**, find `Config.SprayDesigns`, and add an entry for your new gang:

```lua
Config.SprayDesigns = {
    -- Existing sprays...
    {
        id = 'dockers_tag',        -- Unique ID for this spray design
        label = 'The Dockers',     -- Name shown in the Spray Selector popup
        image = 'dockers.png',     -- Exact filename inside tb-gangs/web/sprays/
        gang = 'dockers'           -- Exact Gang ID from the database (or nil so all gangs can use it)
    },
}
```

> **Important Note on Gang IDs:**
> The `gang = 'dockers'` field **must match** the lowercase **Gang ID** you typed when creating the gang in `/gangadmin` (stored in the `gang` column of the `tb_gang_custom` database table, or in `qbx_core/shared/gangs.lua`).
> * **Database Gang ID:** `dockers`
> * **Display Name:** `The Dockers`
> * **PNG File:** `dockers.png`

---

## 🎮 How to Use In-Game

### 1. Admin Setup (`/gangadmin`)
Run **`/gangadmin`** in-game (requires `group.admin`) to open the Admin Management menu:

* **Create Brand New Gang**:
  * Enter the **Gang ID** (lowercase, no spaces, e.g. `dockers`).
  * Enter the **Gang Display Label** (e.g. `The Dockers`).
  * Pick a **Map Blip Color** and customize the **4 Rank Names** (`Rank 0` to `Rank 3`).
  * Check **"Create Compound Zone at My Current Location"** to automatically create their home turf & map blip right where you are standing.
  * Enter a **Leader Server ID** to immediately appoint the gang leader and give them a `gangtablet`.
* **Create New Territory / Compound Here**:
  * Creates an additional turf zone and map blip at your current coordinates.
* **Set Player as Gang Leader**:
  * Appoints any online player as the leader of an existing gang and gives them a `gangtablet` (also available via `/setgangleader [id] [gang]`).
* **Remove Nearest Wall Spray**:
  * Deletes the closest sprayed PNG wall tag within 10 meters.
* **Delete a Gang (& Stash / Markers)**:
  * Completely disbands a gang, resets all online/offline members to `none`, removes their physical safe stash, wipes their wall sprays, and removes their map blips.
* **Delete a Territory / Map Marker**:
  * Permanently deletes any specific territory zone and its blip from the map.

---

### 2. Gang Leader Guide (`gangtablet`)
1. **Open the Tablet**: Use the **`gangtablet`** item from your inventory.
2. **Recruit Members**: Open the **Boss Ops** app, enter a nearby player's Server ID, and click **Recruit**.
3. **Manage Ranks & Roster**: Promote, demote, or kick online members using the dropdowns in the **Active Syndicate Roster** list.
4. **Place Your Compound Safe**:
   * Stand inside a territory/compound owned by your gang.
   * Open the **Boss Ops** app on your tablet, choose which ranks can open the safe (`Allow All Gang Members` by default), and click **Place / Move Safe in Compound**.
   * Aim where you want the safe:
     * **`[Scroll Wheel]`**: Rotate the safe.
     * **`[E]`**: Bolt the safe down.
     * **`[Backspace]`**: Cancel.
   * Once placed, all authorized members of your gang can open it using **`ox_target` (Third-Eye)** or pressing **`[E]`**.

---

### 3. Spraying Walls & Claiming Turf (`spraycan`)
1. Make sure you have a **`spraycan`** in your inventory and are in a gang.
2. Walk up to any vertical wall (inside an enemy territory if you want to earn cash, strip turf influence, and gain **Gang Rep**).
3. Use the **`spraycan`** from your inventory (or click **Spray Wall** on your Gang Tablet).
4. Click your gang's logo in the **Select Graffiti Tag** popup menu.
5. Aim at the wall to position the live 3D preview:
   * **`[Scroll Wheel]`**: Make the logo larger or smaller.
   * **`[E]`**: Start spraying the tag onto the wall.
   * **`[Backspace]`**: Cancel.
6. When the progress bar finishes:
   * Your PNG is permanently painted onto the wall.
   * If you are in an enemy gang's territory, you earn cash/`black_money`, **`+15 REP`** (plus **`+50 REP`** bonus if your tag captures the zone), and strip `25%` of the enemy gang's turf control. At `0%`, the map blip flips to your gang's color!

---

## 📂 Resource File Structure
```text
tb-gangs/
├── fxmanifest.lua
├── config.lua
├── sql.sql
├── README.md
├── client/
│   └── main.lua
├── server/
│   └── main.lua
└── web/
    ├── index.html
    ├── style.css
    ├── script.js
    └── sprays/
        ├── ballas.png
        ├── vagos.png
        ├── families.png
        ├── marabunta.png
        ├── dockers.png
        └── skull.png
```