def handler(event, context):
    return {
        "body": "hello world!",
        "statusCode": 200,
        "statusDescription": "200 OK",
        "isBase64Encoded": False,
        "headers": {"Content-Type": "text/json; charset=utf-8"}
    }
