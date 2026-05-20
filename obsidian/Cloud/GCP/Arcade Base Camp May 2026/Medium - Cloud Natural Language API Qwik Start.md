## Task 1. Create an API key

1. First, you will set an environment variable with your PROJECT_ID which you will use throughout this lab:

export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value core/project)

Copied!

2. Next, create a new service account to access the Natural Language API:

gcloud iam service-accounts create my-natlang-sa \
  --display-name "my natural language service account"

Copied!

3. Then, create credentials to log in as your new service account. Create these credentials and save it as a JSON file "~/key.json" by using the following command:

gcloud iam service-accounts keys create ~/key.json \
  --iam-account my-natlang-sa@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com

Copied!

4. Finally, set the GOOGLE_APPLICATION_CREDENTIALS environment variable. The environment variable should be set to the full path of the credentials JSON file you created, which you can see in the output from the previous command:

export GOOGLE_APPLICATION_CREDENTIALS="/home/USER/key.json"

Copied!

Create an API Key

## Task 2. Make an entity analysis request

In order to perform next steps please connect to the instance provisioned for you via ssh. Open the navigation menu and select **Compute Engine**. You should see the following provisioned linux instance:

![VM Instances page](https://cdn.qwiklabs.com/XQiYB4E8wduqZuLRkwzV%2FZsKQZy2XdbgDe%2BdBk1Wjjs%3D)

1. Click on the **SSH** button. You will be brought to an interactive shell. **Remain in this SSH session for the rest of the lab.**

Now you'll try out the Natural Language API's entity analysis with the following sentence:

_Michelangelo Caravaggio, Italian painter, is known for 'The Calling of Saint Matthew'_

2. Run the following `gcloud` command:

gcloud ml language analyze-entities --content="Michelangelo Caravaggio, Italian painter, is known for 'The Calling of Saint Matthew'." > result.json

Copied!

Make an Entity Analysis Request

3. Run the below command to preview the output of result.json file:

cat result.json

Copied!

You should see a response similar to the following in the result.json file:

{
  "entities": [
    {
      "name": "Michelangelo Caravaggio",
      "type": "PERSON",
      "metadata": {
        "wikipedia_url": "http://en.wikipedia.org/wiki/Caravaggio",
        "mid": "/m/020bg"
      },
      "salience": 0.83047235,
      "mentions": [
        {
          "text": {
            "content": "Michelangelo Caravaggio",
            "beginOffset": 0
          },
          "type": "PROPER"
        },
        {
          "text": {
            "content": "painter",
            "beginOffset": 33
          },
          "type": "COMMON"
        }
      ]
    },
    {
      "name": "Italian",
      "type": "LOCATION",
      "metadata": {
        "mid": "/m/03rjj",
        "wikipedia_url": "http://en.wikipedia.org/wiki/Italy"
      },
      "salience": 0.13870546,
      "mentions": [
        {
          "text": {
            "content": "Italian",
            "beginOffset": 25
          },
          "type": "PROPER"
        }
      ]
    },
    {
      "name": "The Calling of Saint Matthew",
      "type": "EVENT",
      "metadata": {
        "mid": "/m/085_p7",
        "wikipedia_url": "http://en.wikipedia.org/wiki/The_Calling_of_St_Matthew_(Caravaggio)"
      },
      "salience": 0.030822212,
      "mentions": [
        {
          "text": {
            "content": "The Calling of Saint Matthew",
            "beginOffset": 69
          },
          "type": "PROPER"
        }
      ]
    }
  ],
  "language": "en"
}

Read through your results. For each "entity" in the response, you'll see:

- The entity `name` and `type`, a person, location, event, etc.
- `metadata`, an associated Wikipedia URL if there is one.
- `salience`, and the indices of where this entity appeared in the text. Salience is a number in the [0,1] range that refers to the centrality of the entity to the text as a whole.
- `mentions`, which is the same entity mentioned in different ways.

You've sent your first request to the Cloud Natural Language API.