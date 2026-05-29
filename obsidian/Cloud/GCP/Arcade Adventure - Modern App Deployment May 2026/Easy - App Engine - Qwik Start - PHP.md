## Task 1. Enable Google App Engine Admin API

The App Engine Admin API enables developers to provision and manage their App Engine Applications.

1. In the left menu, click **APIs & Services** > **Library**.

![The navigation path to the Library option.](https://cdn.qwiklabs.com/HArVguiohtDtUhiPIWzqNnBfeRlqtNk7dDsZ%2F6EO13E%3D)

2. Type "App Engine Admin API" in search box.
    
3. Click **App Engine Admin API**.
    

![The search result for App Engine Admin API.](https://cdn.qwiklabs.com/Z4PwF8PiQv%2BX%2FyqcbbT60QzaQzfwoKtsW3BgOBeuENs%3D)

4. Click **Enable**.

![The Enable button highlighted in the UI.](https://cdn.qwiklabs.com/el15KNfycJRm8XLGBymxvep2QQ4okMT706X8TWMKF5k%3D)

## Task 2. Download the Hello World app

A simple Hello World app for PHP has been created so you can quickly get a feel for deploying an app to Google Cloud. Follow these steps to download Hello World to your Google Cloud instance.

1. Enter the following command to clone the Hello World sample app repository to your Google Cloud instance:

git clone https://github.com/GoogleCloudPlatform/php-docs-samples.git

Copied!

**Output:**

Cloning into 'php-docs-samples'...
remote: Enumerating objects: 13, done.
remote: Counting objects: 100% (13/13), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 13607 (delta 11), reused 9 (delta 9), pack-reused 13594
Receiving objects: 100% (13607/13607), 12.22 MiB | 23.45 MiB/s, done.
Resolving deltas: 100% (8848/8848), done.

2. Go to the directory that contains the sample code:

cd php-docs-samples/appengine/standard/helloworld

Copied!

3. Set the runtime version in `app.yaml` to the latest required version.

sed -i 's/^runtime: php.*/runtime: php83/' app.yaml

Copied!

4. Verify that the runtime was updated successfully.

grep runtime app.yaml

Copied!

Expected output:

 runtime: php83 

## Task 3. Deploy your app

1. To deploy your app to App Engine, run the following command from within the root directory of your application where the `app.yaml` file is located:

gcloud app deploy

Copied!

2. Enter the number that represents your region:

**Output:**

Services to deploy:
descriptor:      [/home/gcpstaging8140_student/helloworld/app.yaml]
source:          [/home/gcpstaging8140_student/helloworld]
target project:  [qwiklabs-gcp-e6160e374e92ffbf]
target service:  [default]
target version:  [20171117t091157]
target url:      [https://qwiklabs-gcp-e6160e374e92ffbf.appspot.com]
Do you want to continue (Y/n)?

3. Enter **Y** when prompted to confirm the deployment of service.

**Sample output:**

Beginning deployment of service [default]...
Some files were skipped. Pass `--verbosity=info` to see which ones.
You may also view the gcloud log file, found at
[/tmp/tmp.YZRoP4bCoj/logs/2017.11.17/09.08.37.201396.log].
╔════════════════════════════════════════════════════════════╗
╠═ Uploading 5 files to Google Cloud Storage                ═╣
╚════════════════════════════════════════════════════════════════════════╝
File upload done.
Updating service [default]...done.
Updating service [default]...Waiting for operation [apps/qwiklabs-gcp-e6160e374e92ffbf/operat
ions/bf540c31-338f-4532-bcdc
-e47768040d0c] to complete...done.
Updating service [default]...done.
Deployed service [default] to [https://qwiklabs-gcp-e6160e374e92ffbf.appspot.com]
You can stream logs from the command line by running:
  $ gcloud app logs tail -s default
To view your application in the web browser run:
  $ gcloud app browse

## Task 4. View your application

1. To launch your browser, enter the following command:

gcloud app browse

Copied!

**Sample output, your link will be different:**

Did not detect your browser. Go to this link to view your app:
https://qwiklabs-gcp-e6160e374e92ffbf.appspot.com

2. Click on the link to view your application.

![A web page displaying the text "hello world!".](https://cdn.qwiklabs.com/ZqMB5wyDt4KLHW6HcJtlsaSVFXxQL2QrTtyXsSrzgs8%3D)

Your application is deployed and you can read the short message in your browser.

Click **Check my progress** to verify the objective.

Deploy your app.

## Task 5. Make a change

Now make a change to your sample app.

1. Open the `index.php` file with the nano editor:

nano index.php

Copied!

2. Now change "hello world!" to "goodbye world!".
    
3. Press **CTRL** + **X** > **Y** > **Enter** to exit and save the file.
    
4. In Cloud Shell, run the following command to redeploy your application:
    

gcloud app deploy

Copied!

5. Enter **Y** when prompted to confirm the deployment of service.

**Soon after you should receive the following output:**

To view your application in the web browser run:
  $ gcloud app browse

6. Refresh the browser tab with your App Engine deployment. You should see the following:
    
    ![A web page displaying the text "goodbye world!".](https://cdn.qwiklabs.com/WzF1kD58gLMHl%2Fpp0vSsbpC2Y8xL%2BbM%2B%2FrJkX108B5A%3D)