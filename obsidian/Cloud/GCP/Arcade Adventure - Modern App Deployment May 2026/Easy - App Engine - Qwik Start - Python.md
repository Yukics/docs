## Task 1. Enable Google App Engine Admin API

The App Engine Admin API enables developers to provision and manage their App Engine Applications.

1. In the left **Navigation menu**, click **APIs & Services** > **Library**.
2. Type "App Engine Admin API" in the search box.
3. Click the **App Engine Admin API** card.
4. Click **Enable**. If there is no prompt to enable the API, then it is already enabled and no action is needed.

## Task 2. Download the Hello World app

There is a simple Hello World app for Python you can use to quickly get a feel for deploying an app to Google Cloud. Follow these steps to download Hello World to your Google Cloud instance.

1. Enter the following command to copy the Hello World sample app repository to your Google Cloud instance:

git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git

Copied!

2. Go to the directory that contains the sample code:

cd python-docs-samples/appengine/standard_python3/hello_world

Copied!

3. Setup python environment:

sudo apt update
sudo apt install -y python3-venv
python3 -m venv myenv
source myenv/bin/activate

Copied!

## Task 3. Test the application

Test the application using the Google Cloud development server (`dev_appserver.py`), which is included with the preinstalled App Engine SDK.

1. From within your helloworld directory where the app's [app.yaml](https://cloud.google.com/appengine/docs/standard/python/config/appref) configuration file is located, start the Google Cloud development server with the following command:

flask --app main run

Copied!

The development server is now running and listening for requests on port 5000.

2. View the results by clicking the **Web preview** (![web preview icon](https://cdn.qwiklabs.com/7b9oXblGsiFuNK7hmDZjFB%2B7Lrwdv5T64bbmo8X9FAo%3D)) > **Change port**.
    
3. Change the Port Number to **5000** and click **Change and Preview**.
    
    You'll see this in a new browser window:
    
    ![Browser window with Hello World! on the page](https://cdn.qwiklabs.com/qRnWPDdjyMzurnNk2hnzqDcNdLUZy6lnksVB958XQ24%3D)
    
4. Press **CTRL + C** to stop the server.
    

## Task 4. Make a change

In this task, you edit `main.py` to change "Hello World!" to "Hello, Cruel World!".

1. Enter the following to open main.py in nano to edit the content:

nano main.py

Copied!

2. Change "Hello World!" to "Hello, Cruel World!".
    
3. Save the file with **CTRL + S** and exit with **CTRL + X**.
    
4. Restart the Google Cloud development server using the following command:
    

flask --app main run

Copied!

5. Reload the Hello World! Browser or click the **Web Preview** (![web preview icon](https://cdn.qwiklabs.com/7b9oXblGsiFuNK7hmDZjFB%2B7Lrwdv5T64bbmo8X9FAo%3D)) > **Preview on port 5000** to see the results.
    
    ![Browser window with Hello, Cruel World! on the page](https://cdn.qwiklabs.com/%2FZMP8zd61k67G2ljtZRh5dtzQMXd4vTql6L1C3E50bQ%3D)
    
6. Press **CTRL + C** to stop the server.
    

## Task 5. Deploy your app

1. To deploy your app to App Engine, run the following command from within the root directory of your application where the app.yaml file is located:

gcloud app deploy

Copied!

2. Enter the number that represents your region: `<REGION>`

3. The App Engine application will then be created.

Example output:

Creating App Engine application in project [qwiklabs-gcp-233dca09c0ab577b] and region ["REGION"]....done.
Services to deploy:

descriptor:      [/home/gcpstaging8134_student/python-docs-samples/appengine/standard/hello_world/app.yaml]
source:          [/home/gcpstaging8134_student/python-docs-samples/appengine/standard/hello_world]
target project:  [qwiklabs-gcp-233dca09c0ab577b]
target service:  [default]
target version:  [20171117t072143]
target url:      [https://qwiklabs-gcp-233dca09c0ab577b.appspot.com]

Do you want to continue (Y/n)?

4. Enter **Y** when prompted to confirm the details and begin the deployment of service.

Example output:

Beginning deployment of service [default]...
Some files were skipped. Pass `--verbosity=info` to see which ones.
You may also view the gcloud log file, found at
[/tmp/tmp.dYC7xGu3oZ/logs/2017.11.17/07.18.27.372768.log].
╔════════════════════════════════════════════════════════════╗
╠═ Uploading 5 files to Google Cloud Storage                ═╣
╚════════════════════════════════════════════════════════════
File upload done.
Updating service [default]...done.
Waiting for operation [apps/qwiklabs-gcp-233dca09c0ab577b/operations/2e88ab76-33dc-4aed-93c4-fdd944a95ccf] to complete...done.
Updating service [default]...done.
Deployed service [default] to [https://qwiklabs-gcp-233dca09c0ab577b.appspot.com]

You can stream logs from the command line by running:
  $ gcloud app logs tail -s default

To view your application in the web browser run:
  $ gcloud app browse

**Note:** If you receive an error as "Unable to retrieve P4SA" while deploying the app, then re-run the above command.

## Task 6. View your application

- To launch your browser enter the following command, then click on the link it provides:

gcloud app browse

Copied!

Example output (note that your link will be different):

Did not detect your browser. Go to this link to view your app:
https://qwiklabs-gcp-233dca09c0ab577b.appspot.com

![Browser window with Hello, Cruel Word! on the page](https://cdn.qwiklabs.com/dUofhxFTEGaFVp5MfYbMZ9urnCd2W4Ecsj%2B9O5KWS00%3D)

Your application is deployed and you can read the short message in your browser.