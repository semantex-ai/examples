![Semantex](https://semantex.ai/wp-content/uploads/2022/06/cropped-Semantex-Logo-Final@1x.png)

# Semantex Writing StyleBot: Sample Application

## Description
The **style_bot** is a simple proof-of-concept Restful API, that enforces a set of writing style guidelines for a given input text.  In this setting, we will take a closer look at how to access the API directly from a Word document via the [ScriptLab](https://learn.microsoft.com/en-us/office/dev/add-ins/overview/explore-with-script-lab) and Word integration using MS [Office Add-ins](https://learn.microsoft.com/en-us/office/dev/add-ins/) framework.

## Instructions
1. Install ScriptLab : [Explore Office JavaScript API using Script Lab](https://learn.microsoft.com/en-us/office/dev/add-ins/overview/explore-with-script-lab)
2. Semantex APIKEY
    * Use the public key from ([Semantex documentation](https://semantex.ai/apis/)) page.
    * Register for a personal key at the Semantex [sign up](https://semantex.ai/trial-sign-up/) page.
3. Open up the Word application and run the ScriptLab add-in. 
Both the desktop client or the web application are supported.
4. Inside the ScriptLab Add-in menu, import the [StyelBot Scriptlet YAML](https://raw.githubusercontent.com/semantex-ai/examples/main/style_bot/stylebot.yaml) file available at: ```https://raw.githubusercontent.com/semantex-ai/examples/main/style_bot/stylebot.yaml```
