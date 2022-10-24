# Introduction
The file `sem_functions` contains the basic (Bourne) shell scripts for invoking the APIs using 
the basic [cURL](https://curl.se/) command. The script also requires the [jq](https://stedolan.github.io/jq/) tool
to contruct the proper JSON based payloads for the API calls.

# Requirements
1. [cURL](https://curl.se/)
2. [jq](https://stedolan.github.io/jq/)
3. An API Key. You can get a demonstration key from [semantex.ai/apis/] page.

# Configuration
As long as the requirments are met, no additional configuration is required to execute the scripts.
If you would like to use your own registered API_KEY, simply set it as a shell environment variable:
`export API_KEY="YOUR_API_KEY"`

# Execution
The file `sem_functions` define the following functions as werapper for the corresponding API calls. 
Refer to the [API documentation](semantex.ai/apis/) pages for details on input and output. 
1. `sem_lang_detect()`: Detects the language code for a given text input.
2. `sem_sentiment()`: Detects the sentiment of a given text.
3. `sem_entities()`: Detects the named entities in a given text.
4. `sem_spellcheck()`: Detects the named entities in a given text.
5. `sem_parse_pdf()`: Parses a PDF file into its text clusters.
6. `sem_similarity()`: Computes the similarity between two text inputs.

The wrapper functions must be loaded first into the shell environment as follows:
```$ source sem_functions```

## Examples
Ensure to load the functions first as follows:
```$ source sem_functions```

If you want to see the pretty-formatted JSON response, pipe it to the `jq` command.

### Language detect
```
$ sem_lang_detect "I am writing text in English." | jq 
```
```
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "label": "en",
    "conf": 1
  }
}
```

### Sentiment
```
$ sem_sentiment "I am happy the sun came out today." | jq 
```
```
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "label": "POSITIVE",
    "conf": {
      "positive": 0.998,
      "negative": 0,
      "neutral": 0.002,
      "mixed": 0
    }
  }
}
```

### Text Similarity
```
$ sem_similarity "how are you" "how old are you" en en "sem.ssm" | jq 
```
```
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "text1": "how are you",
    "text2": "how old are you",
    "prediction": {
      "match": false,
      "conf": 0.5223
    }
  }
}
```

### PDF Parsing
```
$ sem_parse_pdf samples/sample_1.pdf | jq 
```
```
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "pages": [
      {
        "index": 1,
        "hasAnnotations": false,
        "height": 792,
        "width": 612,
        "rotation": 0,
        "contains-text": true
      }
    ],
    "fonts": [
      {
        "name": "Calibri",
        "family": "Calibri",
        "color-code": "#000000",
        "size": 11.25,
        "space-size": 2.5425
      }
    ],
    "metadata": {
      "finger-print": "a2595fe414dcbdf5198514da3fce7211",
      "author": null,
      "can-modify": true,
      "can-modify-annotations": true,
      "creator": "PDFium",
      "encrypted": false,
      "layout": "SINGLE_PAGE",
      "producer": "PDFium"
    },
    "contents": [
      {
        "text": "Dear John Smith,",
        "hash": "b87ee11717ce73021356a3c7c8512ff4",
        "metadata": {
          "location": {
            "left": 72.1,
            "right": 148.3,
            "top": 77,
            "bottom": 82.6,
            "page": 1
          }
        }
      },
      {
        "text": "This is a notice that you have not succeeded in meeting your sales goals this month. Continuation of a\nfailure to perform adequately will result in a formal warning.",
        "hash": "db933a22c2456aecd00780ed3677ee51",
        "metadata": {
          "location": {
            "left": 72.1,
            "right": 526.1,
            "top": 99.5,
            "bottom": 119.4,
            "page": 1
          }
        }
      },
      {
        "text": "We take the success of our employees very seriously. Therefore, we will be requiring you to take\nadditional training before your next assignment.",
        "hash": "6c9a92cb8f4b9ac4f1391c7ff0e8b585",
        "metadata": {
          "location": {
            "left": 72.1,
            "right": 504.2,
            "top": 136.2,
            "bottom": 156.9,
            "page": 1
          }
        }
      },
      {
        "text": "Thank you,\nLouis",
        "hash": "81739fced632f5a8a6dcf32b750678d0",
        "metadata": {
          "location": {
            "left": 72.1,
            "right": 122.1,
            "top": 173.8,
            "bottom": 193.7,
            "page": 1
          }
        }
      }
    ]
  }
}
```
