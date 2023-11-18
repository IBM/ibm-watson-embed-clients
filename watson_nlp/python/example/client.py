import grpc

# pip install -r requirements.txt
from watson_nlp_runtime_client import (
    watsonnlpservice_pb2,
    watsonnlpservice_pb2_grpc
)
from caikit.runtime.WatsonNlp import syntaxtaskrequest_pb2
from watson_nlp_data_model import rawdocument_pb2
from caikit_data_model.common import strsequence_pb2

# if no TLS
channel = grpc.insecure_channel("localhost:8085")

# if TLS
# with open('tls.crt', 'rb') as f:
#     root_certificate = f.read()
# channel = grpc.secure_channel(url, credentials=grpc.ssl_channel_credentials(root_certificates=root_certificate))

stub = watsonnlpservice_pb2_grpc.WatsonNlpServiceStub(channel)

request = syntaxtaskrequest_pb2.SyntaxTaskRequest(
  raw_document=rawdocument_pb2.RawDocument(text="This is a test"), 
  parsers_str_sequence=strsequence_pb2.StrSequence(values=["sentence", "token", "part_of_speech", "lemma", "dependency"])
)

response = stub.SyntaxTaskPredict(request, metadata=[("mm-model-id", "syntax_izumo_lang_en_stock")])

print(response)
