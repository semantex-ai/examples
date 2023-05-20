[![N|Semantex](https://semantex.ai/wp-content/uploads/2022/06/cropped-Semantex-Logo-Final@1x.png)](https://semantex.ai)

# Semantex - Content Hub Example

## Installation

### Requirements
The following example requires *bash shell*, [cURL](https://curl.se/) and the [jq](https://stedolan.github.io/jq/download/) tool.  
Please ensure that they are in your path.

### Setup
Clone the git repository
```sh
$ git clone https://github.com/semantex-ai/examples.git
```
This will create a folder __*examples*__ in your current directory.

Change into the following directory.
```sh
$ cd examples/content_hub
```

If you have a Semantex APIKEY, you should define it here[^1][^2].
[^1]: In case, you don't have an APIKEY, you can skip this step, however, please note  that you will be working in a public sandboxed environment, where your application content will be publically viewable. 
[^2]: You can register for a __free__ APIKEY at our [registration](https://semantex.ai/trial-sign-up/) page.
```sh
$ export API_KEY="889543c8-8e1a0583-d895af11-183205330bf"
```

Load the Semantex Content Hub Application cURL-based API wrapper functions.
```sh
$ source playbook.sh
```
```sh
$ sem_help
The following functions are available.
-) sem_display_config    -> Display the current configuration.

-) sem_create_app        -> Create a new application.
-) sem_delete_app        -> Delete an existing application.
-) sem_list_apps         -> Lists all applications.

-) sem_add_pdf            -> Add a single PDF file to an application via PDF ingestion API.
-) sem_list_app_docs      -> Lists all documents for a given application.
-) sem_list_app_countents -> Lists all content items for a given application.
-) sem_get_app_content    -> GET the content by content id for a given application.

-) sem_similarity_by_cid  -> Finds similar items given a content id across a given application.
-) sem_similarity_by_txt  -> Finds similar items given a text across a given application.
-) sem_text_search        -> Simple keyword based search.

-) sem_dep_check         -> Check for dependencies.
-) sem_cleanup           -> Cleanup the environment variables and functions.
```

# Example Scenario
In this example scenario, we will demonstrate some of the basic operations for working with the Semantex content hub.

__List of actions:__
1. Create an application.
2. Index 3 PDF files.
3. List the documents of the application.
4. List of the content across all documents in the application.
5. Perform simple text search
6. Perform similarity search by using a:
a. content as a query using content id.
b. text query.
7. Get details of a specific content by its content id.
9. Delete a document from the application.
10. Delete the application.

## Create An Application
```sh
$ sem_create_app "My Test Semantex Application - 2023/05/19"
```
```json
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "app-id": "b6ee555d61df4c0ae30099d3ba4acf5c-90e5588b"
  }
}
```
Take a note of the applcation id returned.

## Index PDF Files
```sh
$ sem_add_pdf samples/letter-01.pdf
```
```json
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "did": "957bc66d",
    "cids": [
      "ead207e4",
      "e1c36dd1",
      "1bab2d28",
      "f6616c22",
      "468ace5b",
      "6eb1b4cc",
      "983b38fa",
      "68310d3e",
      "2a5f3898",
      "c4ce3e1b",
      "c915e6d7",
      "6955f407",
      "a6ceb20e",
      "c4d6a542",
      "150bf92a",
      "c5f971af"
    ]
  }
}
```
Index the other two PDFs as well.
```sh
$ sem_add_pdf samples/letter-02.pdf
$ sem_add_pdf samples/letter-03.pdf
```

## List Application Documents
```sh
$ sem_app_docs 
```
```json
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "documents": [
      {
        "did": "315e5732",
        "size": 69
      },
      {
        "did": "4aae8d37",
        "size": 29
      },
      {
        "did": "957bc66d",
        "size": 16
      }
    ]
  }
}
```
## List Application Contents
```sh
$ sem_app_contents 
```
```json
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "cids": ["ead207e4","e1c36dd1","1bab2d28","f6616c22","468ace5b","6eb1b4cc","983b38fa","68310d3e","2a5f3898","c4ce3e1b","c915e6d7","6955f407","a6ceb20e","c4d6a542","150bf92a","c5f971af","00bb57bc","b5e1a4d8","7696bbf9","d74a84e1","0c669d2b","d5b6df82","5e1c4fb0","3da0b868","81b6570f","1b7b8bc3","ae9ee171","ded97028","32d5b6c3","72dccf92","b313f281","9759d6ac","b3a7bb04","c5e93dc1","915cc6df","bf9b30f3","667ab777","e80e38fa","5c3e8bce","d25ae962","26a693ff","d1f10911","a21f6a03","06c1e6d4","32b185bc","6ae27968","9d04b771","934ae8b5","7be7a8ef","a6286a8e","8ea764bb","a804b2d6","306ea064","5a82d186","a247b728","398b3840","50d922f4","74ca1b1a","c02aad97","2af43b35","efd7a8d5","b3cc7f25","044f394e","44eab5b0","f0eefaa0","2798c644","5eb0c5e7","f4b85085","ba22b190","0e8deb75","f2eb374e","4dfbc553","d181f56c","ea0a98e3","216937a5","63353436","9df43de8","e98bd99d","d1183320","6aa16a33","b99200c7","8e7c9b26","d77435ec","94c9f314","1501db3e","c102ee79","d1546bf7","95a32298","f1893c59","3140d5ed","3f70f0ba","47e67802","c9385e42","fa3234f5","6a643afc","6c04c788","1246ed30","e8e25954","a16f0b79","174698d8","b37cc17b","d1ad0345","147e0daa","c5a9604a","32f8aef9","97dbdf11","ddd6d296","586bd1e9","88644392","b2f0f0b5","9c10a0fb","887bdf71","0f0330e4","87e18f63"]
  }
}
```

## Text (Keyword) Search
```sh
$ sem_text_search "banking relationship"
```
```json
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "hits": [
      {
        "relevance": 4.522109,
        "text": "1.  (Person providing support) has had a banking relationship with us to our entire satisfaction since\n(date account opened).  We believe the sponsor can afford the US $8,965  per 14-week semester\nfor tuition, fees and living expenses that the student may incur while studying at your institution.\nChoose one of the following three options:",
        "id": "c4ce3e1b"
      },
      {
        "relevance": 1.2094154,
        "text": "10.       WE HEREBY AGREE WITH YOU THAT EACH DULY COMPLETED PAYMENT\nCERTIFICATE AND SIGHT DRAFT DRAWN UNDER AND IN COMPLIANCE\nWITH THE TERMS OF THIS LETTER OF CREDIT WILL BE DULY HONORED\nUPON PRESENTATION TO US ON OR BEFORE THE EXPIRY DATE. IF\nDOCUMENTS ARE PRESENTED PRIOR TO 12:00 PM EASTERN TIME ON\nANY BUSINESS DAY, WE WILL HONOR THE SAME IN FULL IN\nIMMEDIATELY AVAILABLE FUNDS ON THE SAME BUSINESS DAY AND, IF\nSO PRESENTED AFTER 12:00 PM EASTERN TIME ON ANY BUSINESS DAY,\nWE WILL HONOR THE SAME IN FULL IN IMMEDIATELY AVAILABLE FUNDS\nON THE NEXT BANKING DAY FOLLOWING PRESENTATION.",
        "id": "95a32298"
      },
      {
        "relevance": 0.93166256,
        "text": "CHECKLIST OF REQUIREMENTS AND SAMPLE LANGUAGE\nUpdated June 17, 2022\nThis document provides an example format for California cap-and-trade program\nentities to submit a Letter of Credit (LOC or L/C) as a bid guarantee for an auction or\nreserve sale. A LOC submitted as a bid guarantee must be issued in a form that may\nbe accepted by the Financial Services Administrator (FSA) consistent with U.S. banking\nlaws and bank practices. Auction or reserve sale applicants are encouraged to work\nwith their financial institutions to ensure that all of the bid guarantee requirements are\nmet, as described in the Detailed Auction Requirements and Instructions (and\nsummarized in the checklist below), prior to submitting any bid guarantee documents to\nthe FSA. Auction and reserve sale applicants are also encouraged to submit a sample\nLOC to the FSA for review in advance of the bid guarantee deadline.",
        "id": "9d04b771"
      },
      {
        "relevance": 0.93166256,
        "text": "Provided below is sample LOC language, with areas highlighted in grey that need to be\ncompleted by the issuing bank or beneficiary bank. These areas include a description\nof the information to be entered in brackets, for example [Insert Information]. Language\nunderlined by double red lines would require revision to use this example letter of credit\nlanguage to submit a bond as a bid guarantee. To submit a bond as a bid guarantee,\nremove section nine (underlined by double red lines), which is LOC-specific. A bond\ndelivered as a bid guarantee must be in a form that may be accepted by the financial\nservices administrator consistent with U.S. banking laws and bank practices. Please note\nthat language provided here is meant as a guide only; all submitted LOCs must, at\nminimum, meet the required non-negotiable terms provided in the Checklist of\nRequirements above or will be rejected.",
        "id": "44eab5b0"
      }
    ]
  }
}
```

## Similarity Search By Content ID
```sh
$ sem_similarity_by_cid ead207e4
```
```json
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "hits": [
      {
        "id": "00bb57bc",
        "hash": "247d46caf00313971cb08e433d2db00e",
        "score": 0.861
      }
    ]
  }
}
```

## Similarity Search By Content Text
```sh
$ sem_similarity_by_txt "bank letter"
```
```json
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "hits": [
      {
        "id": "ead207e4",
        "hash": "cd5f82f214acd97a989e0539c7e91dc8",
        "score": 0.823
      },
      {
        "id": "b5e1a4d8",
        "hash": "0229f57c02f066e79c6a811b5398c1f0",
        "score": 0.754
      },
      {
        "id": "e1c36dd1",
        "hash": "1a2c1691cda21568d1fbd28ebd757e78",
        "score": 0.734
      },
      {
        "id": "00bb57bc",
        "hash": "247d46caf00313971cb08e433d2db00e",
        "score": 0.732
      },
      {
        "id": "32f8aef9",
        "hash": "ca0b9c970b82790ac9d50b6ea64ebe5e",
        "score": 0.537
      },
      {
        "id": "c5a9604a",
        "hash": "66f1ee681fe99f9623f450561a75e9fc",
        "score": 0.536
      },
      {
        "id": "9c10a0fb",
        "hash": "834fed6577f8111d76fdc198b3890452",
        "score": 0.515
      },
      {
        "id": "44eab5b0",
        "hash": "f42c4fba0d2c42fcfeb31fbf8c56c307",
        "score": 0.513
      }
    ]
  }
}
```

## Get Content Details by Content Id
```sh
$ sem_app_content 00bb57bc 
```
```json
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "content": {
      "id": "00bb57bc",
      "text": "SAMPLE OF A BANK LETTER",
      "hash": "247d46caf00313971cb08e433d2db00e",
      "metadata": {
        "location": {
          "left": 209.21,
          "right": 407.43,
          "top": 47.78,
          "bottom": 54.36,
          "page": 1
        }
      },
      "document": {
        "id": "4aae8d37",
        "metadata": {
          "finger-print": "77103f879cd1fe88610621cd9bba4898",
          "author": "volda01",
          "can-modify": true,
          "can-modify-annotations": true,
          "creator": "Microsoft® Office Word 2007",
          "encrypted": false,
          "layout": "SINGLE_PAGE",
          "producer": "Microsoft® Office Word 2007",
          "fonts": [
            {
              "name": "Arial,Bold",
              "family": "Arial,Bold",
              "color-code": "#000000",
              "size": 14.04,
              "space-size": 3.9031203
            },
            {
              "name": "Arial,Bold",
              "family": "Arial,Bold",
              "color-code": "#000000",
              "size": 12,
              "space-size": 3.3360004
            }
          ]
        }
      }
    }
  }
}
```

## Delete a Document and all its Content from the Application
```sh
$ sem_app_doc_del 315e5732
```
```json
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "message": "Docuemnt [315e5732] deleted"
  }
}
```

## Delete Application
```sh
$ sem_delete_app "b6ee555d61df4c0ae30099d3ba4acf5c-403fa8f6"
```
```json
{
  "status": {
    "success": true,
    "code": 200
  },
  "result": {
    "app-id": "b6ee555d61df4c0ae30099d3ba4acf5c-403fa8f6",
    "message": "Application deleted successfully"
  }
}
```
