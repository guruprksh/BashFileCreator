# BashFileCreator

It creates a PBS bash file for every Abaqus input (`.inp`) file in a directory.

There are two versions:

- **`Bash_file_creator.m`**, the MATLAB script. It asks you to pick a folder and writes a `.pbs` next to each `.inp`.
- **`index.html`**, a browser version that does the same thing. Open it at **https://guruprksh.github.io/BashFileCreator/**. Nothing is uploaded; the browser only reads the file names.

## Using the web version

1. Add `.inp` files by dropping them in, choosing files or a folder, or typing their names.
2. Set the e-mail address and the Abaqus version. By default each job gets 16 cpus/ppn, the first 5 jobs go to `asm-medium` and the rest go to `asm-small`, as in the MATLAB script. You can switch to cpus per queue and change the queue for each job.
3. Optional: turn on post-processing (`abaqus cae noGUI=<script>`) and attach the `.py` file to bundle it into the ZIP.
4. Download each `.pbs` on its own, or all of them as `pbs_scripts.zip`, and unzip it next to the `.inp` files. You can add a `submit_all.sh` to the ZIP if you want it.

Settings are saved in your browser. Files are written with Unix (LF) line endings.

## Enabling GitHub Pages

Go to **Settings → Pages → Build and deployment**, choose *Deploy from a branch*, pick `main` and `/ (root)`, and save.
