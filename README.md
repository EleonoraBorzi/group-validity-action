# validity-group-action

This github action automatically checks if the group submitting a pull request to github repo satisfies the requirements. The requirements that the action checks are:
- You cannot work with the same persons in a projects more than a maximum amount of times  (it also apply for working alone)
- The group size does not exceed the maximum number of members
- the account name in the README file of the pull request match with the name of the folder that contains the README file. For example if in the README file it is written that the accounts are a@kth.se and b@kth.se then the folder containing the README file should be "a-b" 
Below there is code that shows how to use the action in yaml file. 

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
- github-token: The github secret token that gives access to several git functions
- payload: The JSON payload that contain information about the pull request
- filesAdded: A list of file added in the pull request
- basefolder: The folder where the folders named with the accounts name are placed 
- maxGroupSize: Maximum number of members accepted 
- maxCollaborationTimes: Maximum number of times two members can work together in a group.

The action will post a comment on the PR depending if the requirements are met and what type of scenario the pull request is. 
In this action the scenarios there are three scenarion:
1. The pull request does not contain a README file. In this case, it could be a TA that created the pull request so not not interfer, the action will post the comment "There wasn't exactly one readme added under collaborations/ . This is assumed not to be a student submission." The action will not fail the pull request. 
2. The accounts in the README and the name of the folder does not match. The following will be posted as a comment on the PR "The ID:s constituting the folder name did not match with the email addresses in the README file. If this is a student submission, please revise the pull request." The action will fail the check on the PR. 
3.  The size of the group is not allowed. The action will fail the pull request and print the following comment "The group size is 4, but the maximum allowed group size is 3. This group is thus not allowed."
4.  The members have worked together more than the maximum number, the following will be posted as a comment "A and B appears to have worked together 10 times, while the maximum allowed is 2. Consequently they may not work together here".
5.  The pull request satisfied all the requirements then the following will be commented on the pull request "The ID:s constituting the folder name matched with the email addresses in the README file. The group consisting of  A and B appears to have worked together 2 times. Maximum group size allowed: 3. Maximum number of collaborations 2. The group composition is allowed. 
