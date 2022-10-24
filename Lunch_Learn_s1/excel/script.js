/**
 * Call the Semantex text similarity API to 
 * compute similarity between two text inputs.
 */
async function pair_similarity(text1: string, lang1: string, text2: string, lang2: string, algo: string) {

  const basePath = 'semantex-qa';
  const resp = await fetch(
    `https://w1waoh1clk.execute-api.us-east-1.amazonaws.com/${basePath}/text/similarity`,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': '889543c8-8e1a0583-d895af11-183205330bf'
      },
      body: JSON.stringify({
        text1: text1,
        lang1: lang1,
        text2: text2,
        lang2: lang2,
        algo: algo
      })
    }
  );

  return await resp.json();

}



/**
 * Excel integration.
 */
async function main(workbook: ExcelScript.Workbook) {

  const sheet = workbook.getWorksheet("Similarity");

  const input_range = sheet.getRange("a2:d2")
      .getExtendedRange(ExcelScript.KeyboardDirection.down)
  
  const ans_range = sheet.getRangeByIndexes(1, 4, input_range.getRowCount(), 2)
  ans_range.clear()

  
  const records = input_range.getValues()
  
  const results: (string | boolean| number)[][] = []
  for (var row of records) {
    const s1:string = row[0].toString();
    const l1:string = row[1].toString();
    const s2 = row[2].toString();
    const l2 = row[3].toString();
    const algo = "sem.ssm"

    const response:Response = await pair_similarity(s1, l1, s2, l2, algo);
    console.log(response)
    results.push([response.result.prediction.match, response.result.prediction.conf]);
  }

  console.log(JSON.stringify(results));
  ans_range.setValues(results)

}

/**  
 * Response Model 
 */
interface Response {
    readonly status: {
      success: boolean,
      code: number
    },
    result: {
      text1: string,
      text2: string,
      score: number,
      prediction: {
        match: boolean,
        conf: number
      }
    }
}
