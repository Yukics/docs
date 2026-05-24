## Task 1. Deploy the application and protect it with IAP

This is an App Engine Standard application written in Python that simply displays a "Hello, World" welcome page. We will deploy and test it, then restrict access to it using IAP.

### Review the application code

- Change from the main project folder to the `1-HelloWorld` subfolder that contains code for this step.

cd 1-HelloWorld

Copied!

The application code is in the `main.py` file. It uses the [Flask](http://flask.pocoo.org/) web framework to respond to web requests with the contents of a template. That template file is in `templates/index.html`, and for this step contains only plain HTML. A second template file contains a skeletal example privacy policy in `templates/privacy.html`.

There are two other files: `requirements.txt` lists all the non-default Python libraries the application uses, and `app.yaml` tells Google Cloud that this is a Python App Engine application.

You can list each file in the shell using the cat command, as in:

cat main.py

Copied!

Or you can launch the Cloud Shell code editor by clicking the Pencil icon at the top right-hand side of the Cloud Shell window, and examine the code that way.

You do not need to change any files for this step.

### Deploy to App Engine

1. Update python runtime to `python313`.

sed -i 's/python37/python313/g' app.yaml

Copied!

2. Deploy the app to the App Engine Standard environment for Python.

gcloud app deploy

Copied!

3. Select a region `REGION`.
    
4. When you are asked if you want to continue, enter **Y** for yes.
    

**Note:** If you get a **Gaia propagation** related error message, re-run the `gcloud app deploy` command.

In a few minutes the deployment completes. You will see a message that you can view your application with `gcloud app browse`.

5. Enter that command:

gcloud app browse

Copied!

6. Click the displayed link to open it in a new tab, or copy it to a manually opened new tab if necessary. Since this is the first time this app is run, it will take a few seconds to appear while a cloud instance is started, and you should see the following window.

![IAP Hello World tabbed page](https://cdn.qwiklabs.com/BUrEJObysrNmE%2FqmU234RAj3kMiAvwOswH%2FAmSdJ%2FNY%3D)

You can open that same URL from any computer connected to the Internet to see that web page. Access is not yet restricted.

Click **Check my progress** to verify the objective.

Deploy an App Engine application

### Restrict access with IAP

1. In the cloud console window, click the **Navigation menu** ![Navigation menu icon](https://cdn.qwiklabs.com/tkgw1TDgj4Q%2BYKQUW4jUFd0O5OEKlUMBRYbhlCrF0WY%3D) > **Security** > **Identity-Aware Proxy**.
    
2. Click **Enable API**.
    
3. Click **Go to Identity Aware Proxy**.
    
4. To configure your project's OAuth consent screen, go to the [OAuth consent screen](https://console.cloud.google.com/apis/credentials/consent?_ga=2.103865344.1617079303.1650346554-1715893018.1650346554)
    
5. Click **Get Started**.
    
6. For **App name**, enter `IAP Example`.
    
7. Click **User support email**, and then click the student email and then click **Next**.
    
8. For **Audience**, select **Internal**, and then click **Next**.
    
    Users with access to the project should be able to log in to the app.
    
9. On the left panel of the lab instructions, copy the **Username**.
    
10. For **Contact information**, paste the copied username.
    
11. Click **Next**.
    
12. Click **Checkbox** to agree the User Data Policy and click **Continue** and then click **Create.**
    
    The consent screen is now set up.
    
13. In Cloud Shell, run this command to disable the Flex API:
    

gcloud services disable appengineflex.googleapis.com

Copied!

**Note:** App Engine has its standard and flexible environments which are optimized for different application architectures. Currently, when enabling IAP for App Engine, if the Flex API is enabled, Google Cloud will look for a Flex Service Account. Your lab project comes with a multitude of APIs already enabled for the purpose of convenience. However, this creates a unique situation where the Flex API is enabled without a Service Account created.

14. Return to the Identity-Aware Proxy page and refresh it. You should now see a list of resources you can protect.

Click the toggle button in the IAP column in the **App Engine app** row to turn **IAP** on.

15. The domain will be protected by IAP. Click **Turn On**.

### Test that IAP is turned on

1. Open a browser tab and navigate to the URL for your app. A Sign in with Google screen opens and requires you to log in to access the app.
    
2. Sign in with the account you used to log into the console. You will see a screen denying you access.
    

You have successfully protected your app with IAP, but you have not yet told IAP which accounts to allow through.

3. Return to the Identity-Aware Proxy page of the console, select the checkbox next to **App Engine app**, and see the App Engine sidebar to the right.

Each email address (or Google Group address, or Workspace domain name) that should be allowed access needs to be added as a Member.

4. Click **Add Principal**.
    
5. Enter your **Student** email address.
    
6. Then, pick the **Cloud IAP** > **IAP-Secured Web App User** role to assign to that address.
    

You may enter more addresses or Workspace domains in the same way.

![Add principals to "App Engine App" dialog box, Cloud IAP > IAP-secured Web App User](https://cdn.qwiklabs.com/%2B%2Bz37ggBAGLOnH5bbMnE0u70erSWgzXVTqLcsPK%2F1z0%3D)

7. Click **Save**.

The message "Policy Updated" will appear at the bottom of the window.

Click **Check my progress** to verify the objective.

Enable and add policy to IAP

### Test access

Navigate back to your app and reload the page. You should now see your web app, since you already logged in with a user you authorized.

If you still see the "You don't have access" page, IAP did not recheck your authorization. In that case, do the following steps:

1. Open your web browser to the home page address with `/_gcp_iap/clear_login_cookie` added to the end of the URL, as in `https://iap-example-999999.appspot.com/_gcp_iap/clear_login_cookie`.
2. You will see a new Sign in with Google screen, with your account already showing. Do not click the account. Instead, click Use another account, and re-enter your credentials.

**Note:** It takes a minute for the role change to take effect. If the page still shows the "You don't have access" message after following the previous steps, wait a minute and try refreshing the page.

These steps cause IAP to recheck your access and you should now see your application's home screen.

If you have access to another browser or can use Incognito Mode in your browser, and have another valid Gmail or Workspace account, you can use that browser to navigate to your app page and log in with the other account. Since that account has not been authorized, it will see the "You Don't Have Access" screen instead of your app.

## Task 2. Access user identity information

Once an app is protected with IAP, it can use the identity information that IAP provides in the web request headers it passes through. In this step, the application will get the logged-in user's email address and a persistent unique user ID assigned by the Google Identity Service to that user. That data will be displayed to the user in the welcome page.

- In Cloud Shell, change to the folder for this step:

cd ~/user-authentication-with-iap/2-HelloUser

Copied!

### Deploy to App Engine

1. Update python runtime to `python313`.

sed -i 's/python37/python313/g' app.yaml

Copied!

2. Since deployment takes a few minutes, start by deploying the app to the App Engine Standard environment for Python:

gcloud app deploy

Copied!

3. When you are asked if you want to continue, enter **Y** for yes.

In a few minutes the deployment should complete. While you are waiting you can examine the application files as described below.

Click **Check my progress** to verify the objective.

Access User Identity Information

### Examine the application files

This folder contains the same set of files as seen in the previous app you deployed, `1-HelloWorld`, but two of the files have been changed: `main.py` and `templates/index.html`. The program has been changed to retrieve the user information that IAP provides in request headers, and the template now displays that data.

There are two lines in `main.py` that get the IAP-provided identity data:

user_email = request.headers.get('X-Goog-Authenticated-User-Email')
user_id = request.headers.get('X-Goog-Authenticated-User-ID')

The **X-Goog-Authenticated-User-** headers are provided by IAP, and the names are case-insensitive, so they could be given in all lower or all upper case if preferred. The render_template statement now includes those values so they can be displayed:

page = render_template('index.html', email=user_email, id=user_id)

The index.html template can display those values by enclosing the names in double curly braces:

Hello, {{ email }}! Your persistent ID is {{ id }}.

As you can see, the provided data is prefixed with `accounts.google.com`, showing where the information came from. Your application can remove everything up to and including the colon to get the raw values if desired.

### Test the updated IAP

Going back to the deployment, when it is ready, you will see a message that you can view your application with `gcloud app browse`.

1. Enter that command:

gcloud app browse

Copied!

2. If a new tab does not open on your browser, copy the displayed link and open it in a new tab normally. You should see a page similar to the following:

![IAP Hello User tabbed page](https://cdn.qwiklabs.com/fe3%2F6PJvDcVemwODFLnePjFaHoMPvNhbWWsNmuJQC4s%3D)

You may need to wait a few minutes for the new version of your application to replace the prior version. Refresh the page if needed to see a page similar to the above.

### Turn off IAP

What happens to this app if IAP is disabled, or somehow bypassed (such as by other applications running in your same cloud project)? Turn off IAP to see.

1. In the cloud console window, click **Navigation menu** > **Security** > **Identity-Aware Proxy**.
2. Click the **IAP** toggle switch next to App Engine app to turn **IAP** off. Click **TURN OFF**.

You will be warned that this will allow all users to access the app.

3. Refresh the application web page. You should see the same page, but without any user information:

![IAP Hello User tabbed page with no user information](https://cdn.qwiklabs.com/60irmGWAbgzDgFX1H3yCFeBha4t3oo%2F%2B2HmbxvVa2vQ%3D)

Since the application is now unprotected, a user could send a web request that appeared to have passed through IAP. For example, you can run the following curl command from the Cloud Shell to do that (replace `<your-url-here>` with the correct URL for your app):

curl -X GET <your-url-here> -H "X-Goog-Authenticated-User-Email: totally fake email"

Copied!

The web page will be displayed on the command line, and look like the following:

<!doctype html>
<html>
<head>
  <title>IAP Hello User</title>
</head>
<body>
  <h1>Hello World</h1>

  <p>
    Hello, totally fake email! Your persistent ID is None.
  </p>

  <p>
    This is step 2 of the <em>User Authentication with IAP&lt;/em&gt;
    codelab.
 &lt;/p&gt;

&lt;/body&gt;
&lt;/html&gt;
</em>

There is no way for the application to know that IAP has been disabled or bypassed. For cases where that is a potential risk, Cryptographic Verification shows a solution.

## Task 3. Use Cryptographic Verification

If there is a risk of IAP being turned off or bypassed, your app can check to make sure the identity information it receives is valid. This uses a third web request header added by IAP, called `X-Goog-IAP-JWT-Assertion`. The value of the header is a cryptographically signed object that also contains the user identity data. Your application can verify the digital signature and use the data provided in this object to be certain that it was provided by IAP without alteration.

Digital signature verification requires several extra steps, such as retrieving the latest set of Google public keys. You can decide whether your application needs these extra steps based on the risk that someone might be able to turn off or bypass IAP, and the sensitivity of the application.

- In Cloud Shell, change to the folder for this step:

cd ~/user-authentication-with-iap/3-HelloVerifiedUser

Copied!

### Deploy to App Engine

1. Update python runtime to `python313`.

sed -i 's/python37/python313/g' app.yaml

Copied!

2. Deploy the app to the App Engine Standard environment for Python:

gcloud app deploy

Copied!

3. When you are asked if you want to continue, enter **Y** for yes.

In a few minutes the deployment should complete. While you are waiting you can examine the application files as described below.

Click **Check my progress** to verify the objective.

Use Cryptographic Verification

### Examine the application files

This folder contains the same set of files as seen in `2-HelloUser`, with two files altered and one new file. The new file is `auth.py`, which provides a `user()` method to retrieve and verify the cryptographically signed identity information. The changed files are `main.py` and `templates/index.html`, which now use the results of that method. The unverified headers as found in the last deployment are also shown for comparison.

- The new functionality is primarily in the `user()` function:

def user():
    assertion = request.headers.get('X-Goog-IAP-JWT-Assertion')
    if assertion is None:
        return None, None

    info = jwt.decode(
        assertion,
        keys(),
        algorithms=['ES256'],
        audience=audience()
    )

    return info['email'], info['sub']

Copied!

The `assertion` is the cryptographically signed data provided in the specified request header. The code uses a library to validate and decode that data. Validation uses the public keys that Google provides for checking data it signs, and knowing the audience that the data was prepared for (essentially, the Google Cloud project that is being protected). Helper functions `keys()` and `audience()` gather and return those values.

The signed object has two pieces of data we need: the verified email address, and the unique ID value (provided in the `sub`, for subscriber, standard field).

This completes Step 3.

### Test the Cryptographic Verification

When the deployment is ready you will see a message that you can view your application with `gcloud app browse`.

- Enter that command:

gcloud app browse

Copied!

If a new tab does not open on your browser, copy the displayed link and open it in a new tab normally.

Recall that you previously disabled IAP, so the application provides no IAP data. You should see a page similar to the following:

![IAP Hello Verified tabbed page ID is None](https://cdn.qwiklabs.com/12FJLOT7gwhCPABz0vIPhRKHeE9UwzkCkhPywu5XULw%3D)

As before, you may need to wait a few minutes for the newest version to be live to see the new version of the page.

Since IAP is disabled, no user information is available. Now turn IAP back on.

1. In the cloud console window, click the **Navigation menu** > **Security** > **Identity-Aware Proxy**.
    
2. Click the **IAP** toggle switch next to App Engine app to turn IAP on again. Click **TURN ON**.
    
3. Refresh the page. The page should look like the following:
    

![Hello Verified User tabbed page, you have an ID](https://cdn.qwiklabs.com/UsOXUWd8w0x29naS7Dgiii1kedVbpV5BGxi7PLKFR98%3D)

Notice that the email address provided by the verified method does not have the `accounts.google.com:` prefix.

If IAP is turned off or bypassed, the verified data would either be missing, or invalid, since it cannot have a valid signature unless it was created by the holder of Google's private keys.