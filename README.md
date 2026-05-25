# Shared Spending — Samet & Ellen

A two-person household spending tracker. Groceries + Misc, receipt photos,
week/month statistics, and a weekly budget. Data syncs live between both
iPhones through Supabase. Installs to the home screen with its own icon.

You'll do about 15 minutes of setup, all clicking and pasting. Follow the
steps in order. Where you see **[YOU]**, that's a step only you can do
because it involves your own accounts.

---

## What each file is

| File | What it does |
|------|--------------|
| `index.html` | The whole app |
| `config.js` | Where you paste your Supabase URL + key |
| `supabase-setup.sql` | Run once to create the database + storage |
| `manifest.json`, `icon-*.png` | Home-screen app icon + name |
| `README.md` | This guide |

---

## Step 1 — [YOU] Create a free Supabase project

1. Go to https://supabase.com and sign up (free, GitHub login works).
2. Click **New project**. Give it any name, e.g. `household`.
3. Set a database password (save it somewhere; you won't need it daily).
4. Pick the region closest to you — **Frankfurt (eu-central)** is good
   from the Netherlands.
5. Click **Create**. Wait ~2 minutes for it to finish provisioning.

## Step 2 — [YOU] Copy your two keys into config.js

1. In your project, click the **gear / Project Settings** (bottom left) →
   **API**.
2. Copy the **Project URL** — looks like `https://abcd1234.supabase.co`.
3. Copy the **anon / public** API key (a long string). Use the one
   labelled **anon public**, NOT the service_role key.
4. Open `config.js` in this folder and paste both in:

   ```js
   const SUPABASE_URL  = "https://abcd1234.supabase.co";
   const SUPABASE_ANON_KEY = "paste-the-long-anon-key-here";
   ```

   Leave `HOUSEHOLD_ID` as it is. Save the file.

## Step 3 — [YOU] Create the database tables

1. In Supabase, open the **SQL Editor** (left sidebar) → **New query**.
2. Open `supabase-setup.sql`, copy ALL of it, paste it into the editor.
3. Click **Run**. You should see "Success". This creates the expenses
   table, the budget setting, the receipts photo bucket, and turns on
   live sync. You only ever do this once.

## Step 4 — Test it on your computer first

Before putting it online, confirm it works locally:

- Easiest: just **double-click `index.html`** to open it in your browser.
- If receipt photos or sync misbehave when opened that way, run a tiny
  local server instead (some browsers are strict about local files):
  - Open a terminal in this folder and run: `python3 -m http.server 8000`
  - Then visit `http://localhost:8000` in your browser.

Add a test expense. If the dot near the top turns green and says
"Synced", and the expense appears in your Supabase **Table Editor →
expenses**, everything is wired correctly. Delete the test row after.

## Step 5 — [YOU] Put it on GitHub + GitHub Pages (free hosting)

GitHub stores the code; GitHub Pages serves it as a live website your
phones can open.

1. Go to https://github.com and sign in. Click **New repository**.
2. Name it e.g. `household-spending`. Choose **Public** (Pages is free
   for public repos). Don't add a README (you already have one). Create.
3. Upload the files: on the new repo page click **uploading an existing
   file**, then drag in EVERYTHING in this folder (index.html, config.js,
   manifest.json, all icon png files, supabase-setup.sql, README.md).
   Click **Commit changes**.
4. Go to the repo's **Settings → Pages**. Under "Build and deployment",
   set **Source = Deploy from a branch**, **Branch = main**, folder
   **/(root)**. Save.
5. Wait ~1 minute. Pages will show a green link like
   `https://YOURNAME.github.io/household-spending/`. That's your app's
   live address. Open it to confirm it loads.

   > Note: because `config.js` is in a public repo, your Supabase keys
   > are visible to anyone who finds the repo. The anon key is meant to
   > be public, and your data is only reachable by someone who has BOTH
   > the URL and key. If you'd rather keep the repo private, GitHub Pages
   > on private repos needs a paid plan — alternatively host on **Vercel**
   > or **Netlify** (both free, both let you keep the repo private). The
   > app files work the same on any of them.

## Step 6 — [YOU] Add it to each iPhone home screen

On **both** your phones:

1. Open **Safari** (must be Safari, not Chrome) and go to your Pages URL.
2. Tap the **Share** button (the square with the up arrow).
3. Scroll down, tap **Add to Home Screen**.
4. Name it "Spending" and tap **Add**.

You'll now have the green receipt icon on your home screen. Tapping it
opens the app full screen, no browser bars — it feels like a native app.

Done. Add an expense on one phone and watch it appear on the other.

---

## Everyday use

- Tap **Samet** or **Ellen** at the top to mark who's logging.
- Enter an amount, pick Groceries or Misc, optionally snap a receipt.
- Toggle **This week / This month** for the stats and budget view.
- Tap the weekly budget number to change it (syncs to both phones).
- Tap the picture icon on any entry to view its receipt.
- Tap ✕ on an entry to delete it.

## If something's wrong

- **Red dot / "Sync error"**: re-check `config.js` URL + key, and that
  you ran the SQL in Step 3.
- **"Not configured" banner**: `config.js` still has the placeholder
  text — paste your real values.
- **Photos won't show**: confirm Step 3 ran fully (it creates the
  `receipts` storage bucket).

## Making it more private later (optional)

This build uses no login for simplicity. To lock it to just the two of
you, add **Supabase Auth** (email magic links), then change the policies
in `supabase-setup.sql` from `using (true)` to check `auth.uid()`. Happy
to walk you through that whenever you want.
