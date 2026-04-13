%% =========================================================
% Creator     : Guru Prakash Sahu
% Version     : v1r3 (optimized)
% Last update : 26-01-2026
% Description : Generate PBS scripts for Abaqus jobs
%% =========================================================

want_FO = false;
generateAbaqusScripts(want_FO);

function generateAbaqusScripts(want_FO)

    %% -------------------------------
    % CONFIGURATION
    %% -------------------------------
    srcDir  = 'C:\Users\gsahu\OneDrive - Delft University of Technology\PhD TUD\3. Research\3.4. Simulations\3.4.0 Supporting_Docs\e. Abaqus Scripts';
    srcFile = 'U1_animation_limits_v1r2.py';
    srcPath = fullfile(srcDir, srcFile);

    abaqusVersion = '2021';
    cpuCount      = 16;
    userEmail     = 'gsahu@tudelft.nl';

    %% -------------------------------
    % SELECT INPUT DIRECTORY
    %% -------------------------------
    inputDir = uigetdir(pwd, 'Select folder with .inp files');
    if inputDir == 0
        disp('No folder selected. Exiting.');
        return;
    end

    %% -------------------------------
    % GET .inp FILES
    %% -------------------------------
    inpFiles = dir(fullfile(inputDir, '*.inp'));
    if isempty(inpFiles)
        msgbox('No .inp files found in the selected folder.', ...
               'No Files', 'warn');
        return;
    end

    %% -------------------------------
    % COPY POST-PROCESSING SCRIPT ONCE
    %% -------------------------------
    if want_FO
        dstPath = fullfile(inputDir, srcFile);
        if ~isfile(srcPath)
            error('Source FO script not found:\n%s', srcPath);
        end

        if ~isfile(dstPath)
            copyfile(srcPath, dstPath);
            fprintf('FO script copied to:\n%s\n', dstPath);
        else
            warning('FO script already exists. Skipping copy.');
        end
    end

    %% -------------------------------
    % GENERATE PBS FILES
    %% -------------------------------
    createdCount = 0;

    for i = 1:numel(inpFiles)

        inpName = inpFiles(i).name;
        jobName = erase(inpName, '.inp');
        pbsPath = fullfile(inputDir, jobName + ".pbs");

        fid = fopen(pbsPath, 'w');
        if fid < 0
            warning('Failed to create: %s', pbsPath);
            continue;
        end

        % Queue logic
        if i < 6
            queueName = 'asm-medium';
        else
            queueName = 'asm-small';
        end

        %% ---- PBS HEADER ----
        fprintf(fid, ...
            ['#!/bin/csh\n',...
             '# Job for Torque PBS 4.2.10\n\n',...
             '#PBS -j oe\n',...
             '#PBS -l nodes=1:ppn=%d\n',...
             '#PBS -M %s\n',...
             '#PBS -m abe\n',...
             '#PBS -N %s\n',...
             '#PBS -o Output_%s.LOG\n',...
             '#PBS -q %s\n',...
             '#PBS -r n\n',...
             '#PBS -S /bin/csh\n',...
             '# -------------------------------------\n\n'], ...
             cpuCount, userEmail, jobName, jobName, queueName);

        %% ---- RUN ABAQUS ----
        fprintf(fid, ...
            ['cd ${PBS_O_WORKDIR}\n\n',...
             'module load abaqus/%s\n\n',...
             'set input_file = "%s"\n',...
             'set job_name = `echo $input_file | sed ''s/\\.inp$//''`\n\n',...
             'abaqus input=$input_file job=$job_name cpus=%d\n\n'], ...
             abaqusVersion, inpName, cpuCount);

        %% ---- POST PROCESSING ----
        if want_FO
            fprintf(fid, ...
                ['# -------------------------------------\n',...
                 '# POST-PROCESSING (ANIMATION)\n',...
                 '# -------------------------------------\n\n',...
                 'abaqus cae noGUI=%s\n\n'], srcFile);
        end

        fprintf(fid, 'exit 0\n');
        fclose(fid);

        createdCount = createdCount + 1;
    end

    %% -------------------------------
    % CONFIRMATION
    %% -------------------------------
    msgbox(sprintf('Successfully created %d PBS script(s) in:\n%s', ...
           createdCount, inputDir), 'Done');

end
