import grpc

# pip install -r requirements.txt
from watson_nlp_runtime_client import (
    common_service_pb2,
    common_service_pb2_grpc,
    syntax_types_pb2,
)

# if no TLS
channel = grpc.insecure_channel("localhost:8085")

# if TLS
# with open('tls.crt', 'rb') as f:
#     root_certificate = f.read()
# channel = grpc.secure_channel(url, credentials=grpc.ssl_channel_credentials(root_certificates=root_certificate))

stub = common_service_pb2_grpc.NlpServiceStub(channel)

request = common_service_pb2.SyntaxRequest(
    raw_document=syntax_types_pb2.RawDocument(text="This is a test"),
    parsers=("sentence", "token", "part_of_speech", "lemma", "dependency"),
)

response = stub.SyntaxPredict(
    request, metadata=[("mm-model-id", "syntax_izumo_lang_en_stock")]
)

print(response)
