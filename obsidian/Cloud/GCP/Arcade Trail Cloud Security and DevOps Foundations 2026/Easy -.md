## Task 1. Create a Cloud Storage bucket

In order to store the data for this lab you need to create your own Cloud Storage bucket.

1. Pick a name for your Cloud Storage bucket, such as **`<filled in at lab start>`-kms_lab**. For more information on naming buckets, see the Cloud Storage bucket [naming guidelines](https://cloud.google.com/storage/docs/naming). Run the following command in Cloud Shell to set a variable to your bucket name:

BUCKET_NAME="-kms_lab"

Copied!

2. Now create the bucket by running the following command:

gsutil mb gs://${BUCKET_NAME}

Copied!

Running this command should also help to verify that you've got the `gsutil` command line client set up correctly, authentication is working, and you have write access to the cloud project you're operating under.

3. After your bucket has been created, move on to the next step to download the Enron Corpus.

Click **Check my progress** to verify the objective.

Create a Cloud Storage bucket.

## Task 2. Review the data

The **Financial dataset** used in this lab is a collection of dummy financial documents. This data has been copied to the Cloud Storage bucket `gs://${GOOGLE_CLOUD_PROJECT}-kms-lab-data/`.

1. Download one of the source files locally so that you can see what it looks like by running:

gsutil cp gs://${GOOGLE_CLOUD_PROJECT}-kms-lab-data/finance-dept/inbox/1.txt .

Copied!

2. Now `tail` the downloaded file to verify the email text is there:

tail 1.txt

Copied!

You should receive the following output:

Content: This is a sample financial document for encryption (File 1).

This will display the contents of a plaintext mail file.

## Task 3. Enable Cloud KMS

[Cloud KMS](https://cloud.google.com/kms/) is a cryptographic key management service on Google Cloud. Before using KMS you need to enable it in your project. In this lab you have been provisioned KMS should already have been enabled. You can make sure of this by using one of the `gcloud` CLI commands.

- Run the following in your Cloud Shell session:

gcloud services enable cloudkms.googleapis.com

Copied!

**Note:** KMS and other services can also be enabled on your project using the [Cloud Console UI](https://console.cloud.google.com/apis/api/cloudkms.googleapis.com) as well.

You shouldn't have received any output. Cloud KMS is now enabled in your project!

## Task 4. Create a Keyring and Cryptokey

In order to encrypt the data, you need to create a KeyRing and a CryptoKey. KeyRings are useful for grouping keys. Keys can be grouped by environment (like **test**, **staging**, and **prod**) or by some other conceptual grouping. For this lab, your KeyRing will be called `labkey` and your CryptoKey will be called `qwiklab`.

1. Run the following command in Cloud Shell to set environment variables:

KEYRING_NAME=labkey CRYPTOKEY_NAME=qwiklab

Copied!

2. Execute the `gcloud` command to create the KeyRing. For this lab you will be using a global location, but it could also be set to a specific region:

gcloud kms keyrings create $KEYRING_NAME --location global

Copied!

3. Next, using the new KeyRing, create a CryptoKey named `qwiklab`:

gcloud kms keys create $CRYPTOKEY_NAME --location global \
      --keyring $KEYRING_NAME \
      --purpose encryption

Copied!

**Note:** CryptoKeys and KeyRings cannot be deleted in Cloud KMS!

You shouldn't see any output. Just like that, you've created a KeyRing and CryptoKey!

4. Open the [Key management](https://console.cloud.google.com/security/kms) through the Console by going to the **Navigation menu** > **Security** > **Key Management**.

The Key Management web UI allows you to view and manage your CryptoKeys and KeyRings. You will use this UI later when you manage permissions.

Click **Check my progress** to verify the objective.

Create a Keyring and Crypto key.

## Task 5. Encrypt your data

Next, try to encrypt some data!

1. Take the contents of the email you looked at earlier and `base64` encode it by running the following:

PLAINTEXT=$(cat 1.txt | base64 -w0)

Copied!

**Note**: Base64 encoding allows binary data to be sent to the API as plaintext. This command works for images, videos, or any other kind of binary data.

Using the encrypt endpoint, you can send the base64-encoded text you want to encrypt to the specified key.

2. Run the following:

curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:encrypt" \
  -d "{\"plaintext\":\"$PLAINTEXT\"}" \
  -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"\
  -H "Content-Type: application/json"

Copied!

**Note:** The `encrypt` action will return a different result each time even when using the same text and key.

The response will be a JSON payload containing the encrypted text in the attribute `ciphertext`.

Now that your data is encrypted, you can save it to a file and upload it to your Cloud Storage bucket.

3. To grab the encrypted text from the JSON response and save it to a file, use the command-line utility [jq](https://stedolan.github.io/jq/). The response from the previous call can be piped into jq, which can parse out the `ciphertext` property to the file `1.encrypted`. Run the following:

curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:encrypt" \
  -d "{\"plaintext\":\"$PLAINTEXT\"}" \
  -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"\
  -H "Content-Type:application/json" \
| jq .ciphertext -r > 1.encrypted

Copied!

4. To verify the encrypted data can be decrypted, call the `decrypt` endpoint to verify the decrypted text matches the original email. The encrypted data has information on which CryptoKey version was used to encrypt it, so the specific version is never supplied to the decrypt endpoint. Run the following:

curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:decrypt" \
  -d "{\"ciphertext\":\"$(cat 1.encrypted)\"}" \
  -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"\
  -H "Content-Type:application/json" \
| jq .plaintext -r | base64 -d

Copied!

**Note:** Usually decryption is performed at the application layer. For a walkthrough on how to encrypt and decrypt data in multiple programming languages, read the [Cloud KMS Quickstart](https://cloud.google.com/kms/docs/quickstart).

5. Now that you have verified the text has been encrypted successfully, upload the encrypted file to your Cloud Storage bucket.

gsutil cp 1.encrypted gs://${BUCKET_NAME}

Copied!

Click **Check my progress** to verify the objective.

Encrypt Your Data with the Cloud KMS key and upload it on the storage bucket.

## Task 6. Configure IAM permissions

In KMS, there are two major permissions to focus on. One permissions allows a user or service account to **manage KMS resources**, the other allows a user or service account to use keys to **encrypt and decrypt** data.

The permission to manage keys is `cloudkms.admin`, and allows anyone with the permission to create KeyRings and create, modify, disable, and destroy CryptoKeys. The permission to encrypt and decrypt is `cloudkms.cryptoKeyEncrypterDecrypter`, and is used to call the encrypt and decrypt API endpoints.

For this exercise, you will use the current authorized user to assign IAM permissions.

1. To get the current authorized user, run the command below:

USER_EMAIL=$(gcloud auth list --limit=1 2>/dev/null | grep '@' | awk '{print $2}')

Copied!

2. Next, assign that user the ability to manage KMS resources. Run the following `gcloud` command to assign the IAM permission to manage the KeyRing you just created:

gcloud kms keyrings add-iam-policy-binding $KEYRING_NAME \
    --location global \
    --member user:$USER_EMAIL \
    --role roles/cloudkms.admin

Copied!

Since CryptoKeys belong to KeyRings, and KeyRings belong to Projects, a user with a specific role or permission at a higher level in that hierarchy inherits the same permissions on the child resources. For example, a user who has the role of Owner on a Project is also an Owner on all the KeyRings and CryptoKeys in that project. Similarly, if a user is granted the `cloudkms.admin` role on a KeyRing, they have the associated permissions on the CryptoKeys in that KeyRing.

Without the `cloudkms.cryptoKeyEncrypterDecrypter` permission, the authorized user will not be able to use the keys to encrypt or decrypt data.

3. Run the following `gcloud` command to assign the IAM permission to encrypt and decrypt data for any CryptoKey under the KeyRing you created:

gcloud kms keyrings add-iam-policy-binding $KEYRING_NAME \
    --location global \
    --member user:$USER_EMAIL \
    --role roles/cloudkms.cryptoKeyEncrypterDecrypter

Copied!

Now you can view the assigned permissions in the Cryptographic Keys section of [Key Management](https://console.cloud.google.com/security/kms).

4. Check the box by the name of the key ring (`labkey`), then click **Add principals** in the right info panel.

This will open up a menu where you can see the accounts and permissions for the key ring you just added.

## Task 7. Back up data on the command line

Now that you have an understanding of how to encrypt a single file, and have permission to do so, you can run a script to backup all files in a directory. For this example, copy all files for **finance-dept**, encrypt them, and upload them to a Cloud Storage bucket.

1. First, copy all files for **finance-dept** into your current working directory:

gsutil -m cp -r gs://${GOOGLE_CLOUD_PROJECT}-kms-lab-data/finance-dept .

Copied!

2. Now copy and paste the following into Cloud Shell to back up and encrypt all the files in the **finance-dept** directory to your Cloud Storage bucket:

MYDIR=finance-dept
FILES=$(find $MYDIR -type f -not -name "*.encrypted")
for file in $FILES; do
  PLAINTEXT=$(cat $file | base64 -w0)
  curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:encrypt" \
    -d "{\"plaintext\":\"$PLAINTEXT\"}" \
    -H "Authorization:Bearer $(gcloud auth application-default print-access-token)" \
    -H "Content-Type:application/json" \
  | jq .ciphertext -r > $file.encrypted
done
gsutil -m cp finance-dept/inbox/*.encrypted gs://${BUCKET_NAME}/finance-dept/inbox

Copied!

This script loops over all the files in a given directory, encrypts them using the KMS API, and uploads them to Cloud Storage.

Click **Check my progress** to verify the objective.

Encrypt multiple files using KMS API and upload to Cloud Storage.

After the script completes, you can view the encrypted files when you click Storage from the Console's left menu.

3. To find the files, go to **Navigation menu** > **Cloud Storage** > **Buckets** > **kms_lab_bucket** > **finance-dept** > **inbox**. You should see something like this:

![Bucket content](https://cdn.qwiklabs.com/DD8yawYjf4pZ%2BRxR%2BPhS%2FwCRgjyBKOSt%2BuzNVeY%2Bm04%3D)

**Note:** Cloud Storage supports [Server Side Encryption](https://cloud.google.com/storage/docs/encryption), which supports key rotation of your data and is the recommended way to encrypt data in Cloud Storage. The above example is for demonstration purposes only.

## Task 8. View Cloud Audit logs

Google Cloud Audit Logging consists of two log streams, Admin Activity and Data Access, which are generated by Google Cloud services to help you answer the question "who did what, where, and when?" within your Google Cloud projects.

- To view the activity for any resource in KMS, go to **Navigation menu > Cloud Overview > Activity** tab. This will take you to the **Cloud Activity UI** and then click on **View Log Explorer**, Select **Cloud KMS Key Ring** as the `Resource Type` and you should see the creation and all modifications made to the KeyRing.

You've now encrypted and uploaded data using KMS and Cloud Storage!

### **What was covered**

- Using IAM to manage KMS permissions.
- Using KMS to encrypt data.
- Using Cloud Storage to store encrypted data.
- Using Cloud Audit Logging to view all activity for CryptoKeys and KeyRings.