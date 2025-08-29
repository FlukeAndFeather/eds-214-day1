# Exceeds spec

## 1 - The analysis produces the expected output 
- My figure can be found in the figures folder, and it looks similar to the article, with some improvements in the colors displayed.

## 2 - The README includes a flowchart and text explaining how the analysis works - 
My README contains all the required instructions and includes an explanation of how to run the analysis





#Collaboration
My peer feedback went well. I struggled a little with the time needed to analyze the repo, but I was still able to give constructive feedback. I suggested improvements to the README page and the Quarto document, focusing on structure and organization, and I also helped correct parts of the code that didn’t follow conventional formatting.

Link to the closed issues

1 - https://github.com/hylaea-miller/eds-214-day1/issues/7
2 - https://github.com/hylaea-miller/eds-214-day1/issues/5
3 - https://github.com/hylaea-miller/eds-214-day1/issues/4



https://github.com/hylaea-miller/eds-214-day1/commit/374eb42461274cf5221039217cf9cf02ddaddc89


# Instructor feedback

## Automate

[M] **Running the entire analysis requires rendering one Quarto document**

[M] The analysis runs without errors

[M] **The analysis produces the expected output**
- Figure is reproduced twice, should only be plotted once

[NY] **Data import/cleaning is handled in its own script(s)**
  - After line 65, code is analysis and should not be included in data import/cleaning script

## Organize

[M] Raw data is contained in its own folder

[NY] Intermediate outputs are created and saved to a separate folder from raw data
- Intermediate outputs should be all stored `output` not under `paper` too

[M] **At least one piece of functionality has been refactored into a function in its own file**

## Document

[M] The repo has a README that explains where to find (1) data, (2) analysis script, (3) supporting code, and (4) outputs

[M] **The README includes a flowchart and text explaining how the analysis works**

[M] **The code is appropriately commented**

[M] **Variable and function names are descriptive and follow a consistent naming convention**
- Inconsitent spacing and case in file-naming convention (e.g., `Function.R` vs. `Data wrangling.R`

## Scale

After cloning the repo on Workbench:

[NY] Running the environment initialization script installs all required packages
- `install.packages()` should only be in `install_packages.R` script not in scripts under the `R/` folder

[M] The analysis script runs without errors

## Collaborate

[M] **The student has provided attentive, constructive feedback in a peer review**

[M] **The student has contributed to a peer's repo by opening an issue and creating a pull request**

[M] The repo has at least three closed GitHub issues

[M] The commit history includes at least one merged branch and a resolved merge conflict

[M] The rendered analysis is accessible via GitHub Pages
