Example Uber app for developers
==============================

We will be pushing a Python Flask authetication application that uses Uber's external authetication API to production on AWS using ECS and Fargate.
We will be using GitHub Actions to run our pipeline.

How To Use This
---------------
NOTE: You will need to  ahve a valid uber organization account to access the 0 auth scopes.

1. Navigate over to https://developer.uber.com/, and sign up for an Uber developer account.
2. Register a new Uber application and make your Redirect URI `http://localhost:7000/submit` - ensure that both the `profile` and `history` OAuth scopes are checked.
3. Fill in the relevant information in the `config.json` file in the root folder and add your client id and secret as the environment variables `UBER_CLIENT_ID` and `UBER_CLIENT_SECRET`.
4. Run `export UBER_CLIENT_ID="`*{your client id}*`"&&export UBER_CLIENT_SECRET="`*{your client secret}*`"`
5. Run `pip install -r requirements.txt` to install dependencies
6. Run `python app.py`
7. Navigate to http://localhost:7000 in your browser

Testing
-------

1. Install the dependencies with `make bootstrap`
2. Run the command `make test`
3. If you delete the fixtures, or decide to add some of your own, you’ll have to re-generate them, and the way this is done is by running the app, getting an auth_token from the main page of the app. Paste that token in place of the `test_auth_token` at the top of the `test_endpoints.py` file, then run the tests.

Additional instructions
-----------------------
Assumptions to complete this tutorial:
1. You have an AWS account set up and have an IAM profile with admin permissions setup locally for the AWS CLI (your acc should have funds to provision lb and fargate).
3. GitHub's account and Git setup locally with ssh keys.
5. Docker Installed.
6. Basic knowledge of VPC networking.
7. A key pair generated from the AWS Console.
8. Python3 and pip installed.

Initial setup
-------------

Create a remote repo on GitHub with the same directory name you choose for the cloned repo, then connect to it either using HTTPs or SSH and switch to the dev branch.

- `git clone https://github.com/0xsudo/python-api.git`
- `cd python-api`
- `git init`
- `git remote add origin https://github.com/<USER>/<REPO>.git` #change accordingly
- `git checkout -b dev`

Go into the cloudformation directory and update with the necessary `[aws-acc-id]`, you can get this by running `aws sts get-caller-identity` on your terminal.

Note that in the `.github/workflows/main.yaml` our workflow is triggered using a `pull_request`, you can change this to your desired action like `push`.

Once you save the changes:

 - `git add .`
 - `git commit -m "relevant message"`
 - `git push origin dev`

 Go into our repo on GitHub, create a `pull request` and `merge` into the main brach or any other, this `action` will trigger our `workflow`, go into `actions` tab to view the workflow steps.