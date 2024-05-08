$("#stylebot").click(() => tryCatch(style));
$("#stylebot_all").click(() => tryCatch(style_all));

async function style_all() {
  await Word.run(async (context) => {
    const loader = document.getElementById("loader");
    await handleExistingComments(context);
    const model = await getModel();

    var paragraphs = context.document.body.paragraphs;
    paragraphs.load("text, range");
    await context.sync();

    // Filter paragraphs and prepare promises for each paragraph processing
    const processingPromises = paragraphs.items
      .filter((p) => p.text.trim().length > 0)
      .map(async (paragraph) => {
        const text = paragraph.text;
        const response = await check_style(text, model);
        const range = paragraph.getRange();
        range.load("text");
        return processResponse(context, range, response);
      });

    // Wait for all promises to resolve
    loader.classList.remove("hidden"); // Show the loader
    await Promise.all(processingPromises);
    loader.classList.add("hidden");
    await context.sync();
  });
}

async function style() {
  await Word.run(async (context) => {
    const loader = document.getElementById("loader");
    const range = await getSelectedRange(context);
    const text = await getTextFromRange(context, range);

    // Make sure we have selected text
    if (!text.trim()) {
      console.log("No text selected. Please select some text to check for style violations.");
      return;
    }

    // Clear the existing comments if checked.
    await handleExistingComments(context);

    const model = await getModel();

    loader.classList.remove("hidden"); // Show the loader

    // Validate the selected text using Semantex API
    const response = await check_style(range.text, model);

    // Create the comments
    await processResponse(context, range, response);

    loader.classList.add("hidden");

    await context.sync();
  });
}

async function check_style(text, model) {
  console.log("Processing:\n" + text + "\nModel: " + model);
  const response = await fetch(`https://tjpriw2omfpe2ufrm3qlovmtoa0cpxic.lambda-url.us-east-1.on.aws/`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "x-api-key": "889543c8-8e1a0583-d895af11-183205330bf"
    },
    body: JSON.stringify({ text: text.trim(), model: model })
  });
  return response.json();
}

async function handleExistingComments(context) {
  const clearExisting = $("#replace").is(":checked");
  if (clearExisting) {
    const comments = context.document.body.getComments();
    comments.load("items");
    await context.sync();

    comments.items.forEach((comment) => comment.delete());
    await context.sync();
  }
}

async function getModel() {
  const model = $("#models").val();
  return model;
}

async function processResponse(context, paragraph, response) {
  let hasViolations = false;
  for (let violation of response.result.violations) {
    if (violation.applies) {
      hasViolations = true;
      let formattedViolation = `${violation.category} - ${violation.rule}\n\nViolation: ${violation.violation}\n\nCorrection: ${violation.correction}\n\nContext: ${violation.context}`;
      paragraph.insertComment(formattedViolation);
    }
  }
  if (!hasViolations) {
    console.log("Clean Text: No violations found.");
  }
  await context.sync();
}

async function tryCatch(callback) {
  try {
    await callback();
  } catch (error) {
    console.error("Error caught:", error);
  }
}

function getSelectedRange(context) {
  const range = context.document.getSelection();
  return range;
}

async function getTextFromRange(context, range) {
  range.load("text");
  await context.sync();

  console.log(range.text);
  return range.text;
}

