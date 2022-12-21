var _PDF_DOC
var _OBJECT_URL;
var _JSON_RESP;
var _CUR_PAGE_INDEX=0;

async function parse_pdf(bytes) {
    const apikey = "889543c8-8e1a0583-d895af11-183205330bf"
    
    const query = new URLSearchParams({
        engine: $("#engine").val(),
        y_mul: $("#ymul").val(),
        draw_bb: true,
        y_mul_small: 1.01,
        w_mul: $("#wmul").val(),
        y_mul_space: $("#yspc").val()
      }).toString();

    console.log(query)

    const resp = await fetch(
        `https://w1waoh1clk.execute-api.us-east-1.amazonaws.com/semantex-qa/docs/parsers/pdf/image?${query}`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/pdf',
            'x-api-key': apikey
          },
          body: bytes
        }
      );
      
      const data = await resp.text();
      _JSON_RESP=JSON.parse(data)
      _CUR_PAGE_INDEX = 0;
      showImage()
      
}


function currentPageImage() {
    return _JSON_RESP.result.pages[_CUR_PAGE_INDEX].image.base64;
}

function getNumberOfPages() {
    return _JSON_RESP.result.pages.length;
}


function showImage() {
    const img_src = "data:image/jpeg;base64, " + currentPageImage();
    $("#pdf_img").attr("src",img_src);
}


function showPDF(pdf_url) {
    const loadingTask = pdfjsLib.getDocument({ url: pdf_url });
    loadingTask.promise.then(function(pdf_doc) {

        _PDF_DOC = pdf_doc;

        // show the first page of PDF
        //showPage(1);
        console.log(_PDF_DOC)

        console.log(_PDF_DOC.numPages)

        _PDF_DOC.getData().then(d => {
            console.log(d);
            parse_pdf(d);
        })

        // destroy previous object url
        URL.revokeObjectURL(_OBJECT_URL);
    }).catch(function(error) {
        // error reason
        alert(error.message);
    });;
}

function mod(n, m) {
    return ((n % m) + m) % m;
  }

document.querySelector("#pdf-file").addEventListener('change', function() {
    // user selected PDF
    var file = this.files[0];

    // allowed MIME types
    var mime_types = [ 'application/pdf' ];
    
    // validate whether PDF
    if(mime_types.indexOf(file.type) == -1) {
        alert('Error : Incorrect file type');
        return;
    }

    // validate file size
    if(file.size > 10*1024*1024) {
        alert('Error : Exceeded size 10MB');
        return;
    }

    // validation is successful

    // object url of PDF 
    _OBJECT_URL = URL.createObjectURL(file)

    console.log(_OBJECT_URL)

    $("#resend").prop('disabled', false)

    showPDF(_OBJECT_URL)
});

$("#button-prev").click(function() {
    const totalPages = getNumberOfPages();
    _CUR_PAGE_INDEX=mod(_CUR_PAGE_INDEX-1, totalPages);
    showImage();
});

$("#button-next").click(function() {
    const totalPages = getNumberOfPages();
    _CUR_PAGE_INDEX=mod(_CUR_PAGE_INDEX+1, totalPages);
    showImage();
});

$("#resend").click(function() {
    _PDF_DOC.getData().then(d => {
        console.log(d);
        parse_pdf(d);
    })
})

$("#pre-selects").change(function() {
    var value = $("#pre-selects option:selected").val();
    
    if("lines" === value) {
        $("#engine").val('v2')
        $("#ymul").val('0')
        $("#wmul").val('10')
        $("#yspc").val('0')

    } else if("paragraphs" === value) {
        $("#engine").val('v2')
        $("#ymul").val('1.75')
        $("#wmul").val('7.25')
        $("#yspc").val('1.10')

    } else if("sections" === value) {
        $("#engine").val('v2')
        $("#ymul").val('3')
        $("#wmul").val('10')
        $("#yspc").val('3')

    } else if("custom" === value) {
        alert("custom")
    } else {
        alert("unknown")
    }

});