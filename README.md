# group-validity-action

This GitHub action is developed for the 2021 spring offering of the course [DD2482 Automated Software Testing and DevOps](https://github.com/KTH/devops-course) at KTH. It is intended to be used in the repository of said course to check that when students make pull requests for project proposals they are legal from a group composition perspective. The requirements that the action checks are:
- The students cannot work with the same people in a project more than some maximum amount of times (this also applies for working alone).
- The group size does not exceed the maximum number of allowed members.
- The KTH email addresses in the README file of the pull request match with the name of the folder that contains the README file. For example if in the README file it is written that the accounts are a@kth.se and b@kth.se then the folder containing the README file should be "a-b" or "b-a".

## What it does
The action interprets the pull request and if it does not look like a student project proposal it posts a comment stating that. If it looks like a proposal then it checks whether the email addresses in the README and the folder name correspond with each other. If they don't this is posted as a comment and it fails the check, otherwise a comment is posted with information regarding if the group composition is allowed and the check fails or passes depending on the outcome.

Some typical scenarios that can occur:
1. The pull request does not add exactly one README file under [*basefolder*](#basefolder). In this case, it could be a TA that created the pull request. The action will only post a comment about the submission probably not being from a student and then end with a pass. 
2. The KTH email-addresses in the README and the name of the folder do not match. The action will post a comment saying that it's not valid if it's a student project proposal, and will fail the check on the PR. 
3. The size of the group is not allowed. The action will fail the pull request and post a comment regarding this. 
4. The members have worked together more than the maximum allowed times. The action will fail the pull request and post a comment regarding this. 
5. The pull request satisfied all the requirements. Then this action will post a comment saying this and end with a pass.

For a more in-depth showcase of different scenarios see the dedicated repository: https://github.com/hengque/group-validity-action-example 

## Usage
The action has 6 inputs:
- github-token: The GitHub secret token that gives access to several git functions.
- payload: The JSON payload that contains information about the pull request.
- filesAdded: A list of files added in the pull request, on the form "\[file1_path,file2_path,...\]".
- <a name="basefolder">basefolder</a>: A folder which all relevant student proposal submissions will be under. This is used to limit the part of the repo considered for student project proposals.
- maxGroupSize: Maximum number of members accepted.
- maxCollaborationTimes: Maximum number of times two members can work together in a group.

The inputs have default values (where applicable) that corresponds the requirements from the project course https://github.com/KTH/devops-course for the 2021 spring offering. 
To allow the action to function correctly for pull requests from forks, it must run on *pull_request_target*. 

An example usage of the action is found here: https://github.com/EleonoraBorzis/group-validity-action/blob/update-readme/.github/workflows/main.yml. Below we briefly explain the "steps" of this example.

---
Here we make use of another [action](https://github.com/trilom/file-changes-action) to get the files added in the correct format.
```yaml
      - name: Get file added in the pullrequest
        id: file_changes
        uses: trilom/file-changes-action@v1.2.3
```

---
Here we extract the event payload from an environment variable that is automatically set and save it in a terminal variable. We also must account for specific characters that might break our variable (e.g. newlines). Then we save it as a GitHub action output variable so we can access it later.
```yaml
      - id: getPayload
        run: |
          payload=$(cat $GITHUB_EVENT_PATH)
          payload="${payload//'%'/'%25'}"
          payload="${payload//$'\n'/'%0A'}"
          payload="${payload//$'\r'/'%0D'}"
          echo "::set-output name=payload::$payload"
```  

---
Here we make use of the values we acquired through our previous steps as input for the group-validity-action. We also input our chosen values for *basefolder*, *maxGroupSize* and *maxCollaborationTimes*.
```yaml                 
      - uses: EleonoraBorzis/group-validity-action@main
        with: 
          github-token: ${{ secrets.GITHUB_TOKEN }}
          payload:  ${{ steps.getPayload.outputs.payload }}
          filesAdded: ${{ steps.file_changes.outputs.files_added}}
          basefolder: contributions/ 
          maxGroupSize: 3 
          maxCollaborationTimes: 2 
```
---
