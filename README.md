# BashFileCreator

It creates a PBS bash file for every Abaqus input (`.inp`) file in a directory.

There are two versions:

- **`Bash_file_creator.m`**, the MATLAB script. It asks you to pick a folder and writes a `.pbs` next to each `.inp`.
- **`index.html`**, a browser version that does the same thing. Open it at **https://guruprksh.github.io/BashFileCreator/**. Nothing is uploaded; the browser only reads the file names.

## Using the web version

1. Click **Open folder** (or drop the folder onto the page) and choose the folder with your `.inp` files. You can also choose single files or type names.
2. Set the e-mail address and the Abaqus version. By default each job gets 16 cpus/ppn, the first 5 jobs go to `asm-medium` and the rest go to `asm-small`, as in the MATLAB script. You can switch to cpus per queue and change the queue for each job.
3. Optional: turn on post-processing (`abaqus cae noGUI=<script>`) and attach the `.py` file to bundle it into the ZIP.
4. Click **Save to folder**. The `.pbs` files are written next to the `.inp` files, just like the MATLAB script does, and you are asked before any existing `.pbs` is overwritten. The browser asks once for permission to edit the folder.
   - Saving straight to a folder works in **Chrome and Edge** (desktop). In Firefox or Safari, the scripts are downloaded instead, either one at a time or as `pbs_scripts.zip`.
   - You can also have a `submit_all.sh` written to the folder, if you want it.

Settings are saved in your browser. Files are written with Unix (LF) line endings.

## Enabling GitHub Pages

Go to **Settings → Pages → Build and deployment**, choose *Deploy from a branch*, pick `main` and `/ (root)`, and save.
