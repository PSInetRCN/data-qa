---
name: New dataset
about: Issue to document a new dataset as it moves through QA
title: "[DATASET]"
labels: dataset
assignees: ''

---

# Info

* Dataset identifier:
* Submitting author:
* Submitting author email:
* SFN or PN:
* Raw file box ID:
* Cleaned files box IDs:
* Dataset DOI:
* Dataset branch: 
* Dataset cleaning script:
* Dataset cleaned:
* Dataset archived:
* Dataset approved by author:

# QA

- [ ] Create a branch for this dataset.
- [ ] Create a dataset cleaning script from the appropriate template.
- [ ] Run the general purpose cleaning script. List any errors below, under General QA Errors
- [ ] Add code to the dataset cleaning script to resolve the errors.
- [ ] Write cleaned versions of the dataset to new Box files.
- [ ] Create a PR merging this dataset branch to main. Don't merge. 

# Author review and archiving

- [ ] Send the submitting authors the cleaned data for review.
- [ ] Obtain a DOI for the dataset
- [ ] Obtain authors' permission to include the cleaned version of the data in PSInet.
- [ ] Merge dataset branch to main. 

# General QA errors

- [ ] error one
- [ ] error two