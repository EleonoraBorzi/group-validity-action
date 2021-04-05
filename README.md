# validity-group-action

This github action automatically checks if the group submitting a project proposal as a pull request to a github repo satisfies some requirements. The action is implemented with Docker to make it easier to access the action without needing to clone the python script. The requirements that the action checks are:
- The students cannot work with the same persons in a projects more than some maximum amount of times (this also applies for working alone)
- The group size does not exceed the maximum number of allowed members
- The KTH email addresses in the README file of the pull request match with the name of the folder that contains the README file. For example if in the README file it is written that the accounts are a@kth.se and b@kth.se then the folder containing the README file should be "a-b" or "b-a".
Below there is some code that shows how to use the action in a yaml file. 

```yaml
name: Group validity check
on:
  pull_request_target:
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Get file added in the pullrequest
        id: file_changes
        uses: trilom/file-changes-action@v1.2.3
      - id: getPayload
        run: |
          payload=$(cat $GITHUB_EVENT_PATH)
          payload="${payload//'%'/'%25'}"
          payload="${payload//$'\n'/'%0A'}"
          payload="${payload//$'\r'/'%0D'}"
          echo "::set-output name=payload::$payload"
      - uses: EleonoraBorzis/group-validity-action@main
        with: 
          github-token: ${{ secrets.GITHUB_TOKEN }}
          payload:  ${{ steps.getPayload.outputs.payload }}
          filesAdded: ${{ steps.file_changes.outputs.files_added}}
          basefolder: contributions/ 
          maxGroupSize: 3 
          maxCollaborationTimes: 2 

```
The action has 6 inputs:
- github-token: The GitHub secret token that gives access to several git functions.
- payload: The JSON payload that contains information about the pull request.
- filesAdded: A list of files added in the pull request.
- basefolder: A folder which all relevant student proposal submissions will be under. This is used to limit the part of the repo considered for student project proposals.
- maxGroupSize: Maximum number of members accepted .
- maxCollaborationTimes: Maximum number of times two members can work together in a group.

The inputs have a default value that corresponds the requirements from the project course https://github.com/KTH/devops-course/blob/2021/grading-criteria.md#course-automation. 

The action must run on pull_request_target otherwise it will not work. 

The action will post a comment on the PR depending on if the requirements are met and what type of scenario the pull request is.  
In this action there can be the following scenarios:
1. The pull request is not from a fork. Then this action will end early with a pass and not do anything else.
2. The pull request does not add exactly one README file. In this case, it could be a TA that created the pull request so to not interfere, the action will post a comment about the submission probably not being from a student. The action will then end with a pass. 
3. The KTH mail addresses in the README and the name of the folder does not match. The action will post a comment saying that it's not valid if it's a student project proposal and will fail the check on the PR. 
4.  The size of the group is not allowed. The action will fail the pull request and post a comment regarding this. 
5.  The members have worked together more than the maximum number. The action will fail the pull request and post a comment regarding this. 
6.  The pull request satisfied all the requirements. Then this action will post a comment saying this and end with a pass.


