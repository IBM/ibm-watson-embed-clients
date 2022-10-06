// npm install
// node client.js

let messages = require("@ibm/watson-nlp-runtime-client/common-service_pb");
let services = require("@ibm/watson-nlp-runtime-client/common-service_grpc_pb");
let syntaxTypes = require("@ibm/watson-nlp-runtime-client/syntax-types_pb");

let grpc = require("@grpc/grpc-js");

function main() {
  let target = "localhost:8085";
  let client = new services.NlpServiceClient(
    target,
    grpc.credentials.createInsecure()
  );

  let rawDocument = new syntaxTypes.RawDocument();
  rawDocument.setText("We have a working runtime woohoo");

  let request = new messages.SyntaxRequest();

  request.setRawDocument(rawDocument);
  request.setParsersList(["token"]);

  let meta = new grpc.Metadata();
  meta.add("mm-model-id", "syntax_izumo_en_stock");

  client.syntaxPredict(request, meta, function (err, response) {
    console.log(JSON.stringify(response.toObject(), null, 2));
  });
}

main();
