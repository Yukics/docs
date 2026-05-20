## Task 1. Enable Google App Engine Admin API

The App Engine Admin API enables developers to provision and manage their App Engine Applications.

1. In the left menu, click **APIs & Services** > **Library**.

![The navigation path to the Library option.](https://cdn.qwiklabs.com/%2B2b6gVqGkKBE1lu1siHBCJHAH5eBdYMrf8IR9xO2QAQ%3D)

2. Type "App Engine Admin API" in search box.
3. Click **App Engine Admin API**.

![The highlighted Google App Engine Admin API result.](https://cdn.qwiklabs.com/RQAaQQVa0m9YYt0vHN7gxwsZQbIiXw4%2F49CKBOojl20%3D)

4. Click **Enable**(If required).

![The Enable button highlighted](https://cdn.qwiklabs.com/wByJ3ksLn1apN%2FTZ%2FdLiBXWYNzGGSPgIaEjJCNhDv8Y%3D)

## Task 2. Download the Hello World app

There is a simple Hello World app for Go that you can use to quickly get a feel for deploying an app to Google Cloud. Follow these steps to download Hello World to your Google Cloud instance.

1. Open a Cloud Shell session and enter the following command to clone the Hello World sample app repository:

git clone https://github.com/GoogleCloudPlatform/golang-samples.git

Copied!

2. Go to the directory that contains the sample code:

cd golang-samples/appengine/go11x/helloworld

Copied!

## Task 3. Deploy your app

1. To deploy your app to App Engine, run the following command from within the root directory of your application where the `app.yaml` file is located:

sudo apt-get install google-cloud-sdk-app-engine-go
gcloud app deploy

Copied!

2. Enter the number that represents your region:

**Sample output:**

Creating App Engine application in project [qwiklabs-gcp-58a2268dafa9e708] and region [asia-south1]....done.
Services to deploy:
descriptor:      [/home/gcpstaging8142_student/helloworld/app.yaml]
source:          [/home/gcpstaging8142_student/helloworld]
target project:  [qwiklabs-gcp-58a2268dafa9e708]
target service:  [default]
target version:  [20171117t080909]
target url:      [https://qwiklabs-gcp-58a2268dafa9e708.appspot.com]
Do you want to continue (Y/n)?

3. Enter **Y** to confirm the deployment of service when prompted.

**Sample output:**

Beginning deployment of service [default]...
Some files were skipped. Pass `--verbosity=info` to see which ones.
You may also view the gcloud log file, found at
[/tmp/tmp.4CytrNBIMQ/logs/2017.11.17/08.06.15.720314.log].
╔════════════════════════════════════════════════════════════╗
╠═ Uploading 2 files to Google Cloud Storage                ═╣
╚════════════════════════════════════════════════════════════╝
File upload done.
Updating service [default]...done.
Waiting for operation [apps/qwiklabs-gcp-58a2268dafa9e708/operations/27b6d801-9018-4a86-b8c0-6082f78fb09f] to complete...done.
Updating service [default]...done.
Deployed service [default] to [https://qwiklabs-gcp-58a2268dafa9e708.appspot.com]

You can stream logs from the command line by running:
  $ gcloud app logs tail -s default

To view your application in the web browser run:
  $ gcloud app browse

## Task 4. View your application

1. To launch your browser, enter the following command:

gcloud app browse

Copied!

2. Then click on the link it provides.

**Sample output, note your link will be different:**

!["Hello, World!" displayed on a web page.](https://cdn.qwiklabs.com/yCyeqHJcdRoG3A09%2ByeQszb4pHDynMZeXqQ1fh3I5e4%3D)

Your application is deployed and you can read the short message in your browser.